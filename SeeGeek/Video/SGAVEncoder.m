//
//  SGAVEncoder.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGAVEncoder.h"
#import <x264.h>
#import "SGEncodedFrame.h"
#import "SGVideoConfigration.h"
#import "NSError+Constructor.h"

@interface SGAVEncoder ()

@property (nonatomic, assign) AudioConverterRef   audioConverter;
@property (nonatomic, strong) SGVideoConfigration *videoConfigration;

@property (nonatomic, assign) x264_t              *x264Encoder;
@property (nonatomic, assign) x264_param_t        *x264Param;
@property (nonatomic, assign) x264_picture_t      *x264PictureIn;
@property (nonatomic, assign) x264_picture_t      *x264PictureOut;
@property (nonatomic, assign) UInt8               *yuvData;

@property (nonatomic, assign) BOOL                x264EncoderReady;
@property (nonatomic, assign) BOOL                aacEncoderReady;

@end

@implementation SGAVEncoder

#pragma mark - life cycle
- (void)dealloc {
    [self destroyAudioEncoder];
    [self destroyX264Encoder];
}

- (instancetype)init {
    self = [super init];
    if(self) {

    }
    return self;
}


#pragma mark - public method
- (void)encodeAACWithSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    char aacData[4096];
    int aacLen = sizeof(aacData);
    if(!self.audioConverter) {
        [self setupAudioConvert:sampleBuffer];
        [self notifyCompleteFrame:[SGEncodedFrame frameWithData:[self aacHeader] type:SGEncodedFrameTypeAudioHeader]];
    }
    if(!self.aacEncoderReady) {
        [self notifyAudioError:[NSError errorWithCode:-1 message:@"setupAudioConvert failed"]];
        return;
    }
    CMBlockBufferRef blockBuffer = nil;
    AudioBufferList inBufferList;
    if (CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(sampleBuffer, NULL, &inBufferList, sizeof(inBufferList), NULL, NULL, 0, &blockBuffer) != noErr) {
        DDLogWarn(@"CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer failed");
        [self notifyAudioError:[NSError errorWithCode:-1 message:@"CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer failed"]];
        return;
    }
    // 初始化一个输出缓冲列表
    AudioBufferList outBufferList;
    outBufferList.mNumberBuffers = 1;
    outBufferList.mBuffers[0].mNumberChannels = 2;
    outBufferList.mBuffers[0].mDataByteSize = aacLen;
    // 设置缓冲区大小
    outBufferList.mBuffers[0].mData = aacData;
    // 设置AAC缓冲区
    UInt32 outputDataPacketSize = 1;
    OSStatus status = AudioConverterFillComplexBuffer(_audioConverter, inputDataProc, &inBufferList, &outputDataPacketSize, &outBufferList, NULL);
    if (status != noErr)
    {
        DDLogWarn(@"AudioConverterFillComplexBuffer failed %d", (int)status);
        [self notifyAudioError:[NSError errorWithCode:-1 message:@"AudioConverterFillComplexBuffer failed"]];
        return;
    }
    aacLen = outBufferList.mBuffers[0].mDataByteSize;
    //设置编码后的AAC大小
    CFRelease(blockBuffer);
    NSData *aacRawData = [NSData dataWithBytes:aacData length:aacLen];
    [self notifyCompleteFrame:[SGEncodedFrame frameWithData:aacRawData type:SGEncodedFrameTypeAudioBody]];
}

- (void)encodeH264WithSampleBuffer:(CMSampleBufferRef)sampleBuffer {

    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    UInt8 *bufferPtr = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
    UInt8 *bufferPtr1 = (UInt8 *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,1);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    size_t bytesrow0 = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
    size_t bytesrow1  = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,1);

    if(self.yuvData == NULL){
        self.yuvData = (UInt8 *)malloc(width * height *3/2);
    }
    memset(self.yuvData, 0, width * height * 3/2);

    /* convert NV12 data to YUV420*/
    UInt8 *pY = bufferPtr ;
    UInt8 *pUV = bufferPtr1;
    UInt8 *pU = self.yuvData + width * height;
    UInt8 *pV = pU + width * height / 4;
    for(int i = 0; i < height; i++) {
        memcpy(self.yuvData + i * width, pY + i * bytesrow0, width);
    }
    for(int j = 0;j < height/2; j++) {
        for(int i = 0; i < width/2; i++) {
            *(pU++) = pUV[i<<1];
            *(pV++) = pUV[(i<<1) + 1];
        }
        pUV += bytesrow1;
    }

    self.x264PictureIn->img.i_plane = 3;
    self.x264PictureIn->img.plane[0] = self.yuvData;
    self.x264PictureIn->img.plane[1] = self.x264PictureIn->img.plane[0] + (int)(self.videoConfigration.width * self.videoConfigration.height);
    self.x264PictureIn->img.plane[2] = self.x264PictureIn->img.plane[1] + (int)(self.videoConfigration.width * self.videoConfigration.height / 4);
    self.x264PictureIn->img.i_stride[0] = (int)self.videoConfigration.width;
    self.x264PictureIn->img.i_stride[1] = (int)self.videoConfigration.width / 2;
    self.x264PictureIn->img.i_stride[2] = (int)self.videoConfigration.width / 2;
    self.x264PictureIn->i_pts++;

    x264_nal_t *pNals = NULL;
    int iNal = 0;
    int frame_size = 0;

    // 编码
    long start = [[NSDate date] timeIntervalSince1970] * 1000;
    frame_size = x264_encoder_encode(self.x264Encoder, &pNals, &iNal, self.x264PictureIn, self.x264PictureOut);
    DDLogWarn(@"编码时间 %d", (int)([[NSDate date] timeIntervalSince1970] * 1000 - start));

    if(frame_size > 0) {
        for (int i = 0; i < iNal; ++i) {
            if (pNals[i].i_type == NAL_SPS) {

                int sps_len = pNals[i].i_payload - 4;
                char sps[sps_len];
                memcpy(sps,pNals[i].p_payload+4,sps_len);
                NSData *data = [NSData dataWithBytes:sps length:sps_len];
                [self notifyCompleteFrame:[SGEncodedFrame frameWithData:data type:SGEncodedFrameTypeVideoSPS]];
            } else if (pNals[i].i_type == NAL_PPS) {

                int pps_len = pNals[i].i_payload - 4;
                char pps[pps_len];
                memcpy(pps,pNals[i].p_payload+4,pps_len);
                NSData *data = [NSData dataWithBytes:pps length:pps_len];
                [self notifyCompleteFrame:[SGEncodedFrame frameWithData:data type:SGEncodedFrameTypeVideoPPS]];
            } else {

                /*发送普通帧*/
                NSData *data = [[NSData alloc] initWithBytes:pNals[i].p_payload length:pNals[i].i_payload];
                [self notifyCompleteFrame:[SGEncodedFrame frameWithData:data type:SGEncodedFrameTypeVideoData]];
            }
        }
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
}

- (void)updateVideoEncoderWithVideoConfigration:(SGVideoConfigration *)videoConfigration {
    self.videoConfigration = videoConfigration;
    [self destroyX264Encoder];
    [self setupX264Encoder];
}

#pragma mark - audio 
- (void)setupAudioConvert:(CMSampleBufferRef)sampleBuffer {
    if(self.audioConverter) {
        return;
    }
    AudioStreamBasicDescription inputFormat = *(CMAudioFormatDescriptionGetStreamBasicDescription(CMSampleBufferGetFormatDescription(sampleBuffer)));
    AudioStreamBasicDescription outputFormat;
    memset(&outputFormat, 0, sizeof(outputFormat));
    outputFormat.mSampleRate = inputFormat.mSampleRate;
    outputFormat.mFormatID = kAudioFormatMPEG4AAC;
    outputFormat.mChannelsPerFrame = 2;
    outputFormat.mFramesPerPacket = 1024;
    AudioClassDescription *desc                                                                    = [self getAudioClassDescriptionWithType:kAudioFormatMPEG4AAC fromManufacturer:kAppleSoftwareAudioCodecManufacturer];
    if (AudioConverterNewSpecific(&inputFormat, &outputFormat, 1, desc, &_audioConverter) != noErr) {
        DDLogWarn(@"AudioConverterNewSpecific failed");
        self.aacEncoderReady = NO;
        return;
    }
    self.aacEncoderReady = YES;
}

- (AudioClassDescription*)getAudioClassDescriptionWithType:(UInt32)type
                                          fromManufacturer:(UInt32)manufacturer
{
    // 获得相应的编码器
    static AudioClassDescription audioDesc;
    UInt32 encoderSpecifier = type, size = 0;
    OSStatus status;
    memset(&audioDesc, 0, sizeof(audioDesc));
    status = AudioFormatGetPropertyInfo(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size);
    if (status)
    {
        DDLogWarn(@"error getting audio format propery info: %d", (int)(status));
        return nil;
    }
    uint32_t count = size / sizeof(AudioClassDescription);
    AudioClassDescription descs[count];
    status = AudioFormatGetProperty(kAudioFormatProperty_Encoders, sizeof(encoderSpecifier), &encoderSpecifier, &size, descs);
    for (uint32_t i = 0; i < count; i++)
    {
        if ((type == descs[i].mSubType) && (manufacturer == descs[i].mManufacturer)) { memcpy(&audioDesc, &descs[i], sizeof(audioDesc));
            break;
        }
    }
    return &audioDesc;
}

OSStatus inputDataProc(AudioConverterRef inConverter,
                       UInt32 *ioNumberDataPackets,
                       AudioBufferList *ioData,
                       AudioStreamPacketDescription **outDataPacketDescription,
                       void *inUserData){
    //AudioConverterFillComplexBuffer 编码过程中，会要求这个函数来填充输入数据，也就是原始PCM数据
    AudioBufferList bufferList = *(AudioBufferList*)inUserData;
    ioData->mBuffers[0].mNumberChannels = 1;
    ioData->mBuffers[0].mData = bufferList.mBuffers[0].mData;
    ioData->mBuffers[0].mDataByteSize = bufferList.mBuffers[0].mDataByteSize;
    return noErr;
}

- (NSData *)aacHeader {
    char body[4] = {0};

    // 用于描述AAC应该如何被解析，1010【aac】 11【44K sample rate】 1【sample size 16bit】 1[channels stereo]  最终为0xAF
    // 其第二个字节表示数据包类型，0 则为 AAC 音频同步包，1 则为普通 AAC 数据包
    // 综合以上，音频同步包的数据即为0xaf00
    char sepc_info[2] = {0xaf, 0x00};
    body[0] = sepc_info[0];
    body[1] = sepc_info[1];

    uint16_t audio_spec_config = 0;
    audio_spec_config |= ((2 << 11) & 0xf800);  // 2: AACLC
    audio_spec_config |= ((4 << 7) & 0x0780);   // 4:44kHz
    audio_spec_config |= ((2 << 3) & 0x78);     // 2:stereo
    audio_spec_config |= (0 & 0x07);            // padding:000
    body[2] = (audio_spec_config >> 8) & 0xff;
    body[3] = audio_spec_config & 0xff;
    return [NSData dataWithBytes:body length:4];
}

- (void)destroyAudioEncoder {
    if(!_audioConverter) {
        AudioConverterDispose(_audioConverter);
        _audioConverter = NULL;
    }
}

#pragma mark - video
- (void)setupX264Encoder {
    [self initX264EncoderParams];
    if(!self.x264EncoderReady) {
        [self notifyVideoError:[NSError errorWithCode:-1 message:@"VIDEO ENCODER INIT FAILED"]];
        DDLogWarn(@"VIDEO ENCODER INIT FAILED");
        return;
    }
    self.x264Encoder = x264_encoder_open(self.x264Param);
    if(self.x264Encoder == NULL) {
        self.x264EncoderReady = NO;
        [self notifyVideoError:[NSError errorWithCode:-1 message:@"VIDEO ENCODER OPEN FAILED"]];
        DDLogWarn(@"VIDEO ENCODER OPEN FAILED");
    }
}

/**
 *  为h264编码器填充必要的参数
 */
- (void)initX264EncoderParams {
    do {
        if(!self.videoConfigration) {
            break;
        }
        self.x264Param = (x264_param_t *)malloc(sizeof(x264_param_t));
        if(self.x264Param == NULL) {
            break;
        }
        x264_param_default_preset(self.x264Param, "veryfast", "zerolatency");
        self.x264Param->i_threads = X264_SYNC_LOOKAHEAD_AUTO;
        self.x264Param->i_width = (int)self.videoConfigration.width;
        self.x264Param->i_height = (int)self.videoConfigration.height;
        self.x264Param->b_cabac = 0;
        self.x264Param->b_interlaced = 0;
        self.x264Param->i_frame_reference = 3;
        self.x264Param->i_bframe = 4;
        self.x264Param->i_bframe_pyramid = 0;
        self.x264Param->i_level_idc = 30;
        self.x264Param->i_frame_total = 0;
        self.x264Param->rc.i_rc_method = X264_RC_ABR;
        self.x264Param->rc.f_rf_constant = 0;
        self.x264Param->rc.f_rf_constant_max = 15;
        self.x264Param->rc.i_bitrate = (int)(self.videoConfigration.bitRate / 1000);
        self.x264Param->rc.i_vbv_max_bitrate = (int)((self.videoConfigration.bitRate * 2) / 1000);
        self.x264Param->b_repeat_headers = 1;
        self.x264Param->i_fps_num = (int)self.videoConfigration.frameRate;
        self.x264Param->i_fps_den = 1;
        self.x264Param->b_intra_refresh = 0;
        self.x264Param->b_annexb = 1;
        self.x264Param->i_keyint_max = (int)(self.videoConfigration.frameRate * self.videoConfigration.keyFrameInterval);
        x264_param_apply_profile(self.x264Param, "baseline");

        self.x264PictureIn = (x264_picture_t *)malloc(sizeof(x264_picture_t));
        memset(self.x264PictureIn, 0, sizeof(x264_picture_t));
        x264_picture_init(self.x264PictureIn);
        x264_picture_alloc(self.x264PictureIn, X264_CSP_I420, self.x264Param->i_width, self.x264Param->i_height);
        self.x264PictureIn->i_type = X264_TYPE_AUTO;

        self.x264PictureOut = (x264_picture_t *)malloc(sizeof(x264_picture_t));
        memset(self.x264PictureOut, 0, sizeof(x264_picture_t));
        x264_picture_init(self.x264PictureOut);
        self.x264EncoderReady = YES;
        return;
    } while (NO);
    self.x264EncoderReady = NO;
}

- (void)destroyX264Encoder {
    if(self.x264PictureIn) {
        x264_picture_clean(self.x264PictureIn);
        free(self.x264PictureIn);
        self.x264PictureIn = NULL;
    }
    if(self.x264PictureOut) {
        x264_picture_clean(self.x264PictureOut);
        free(self.x264PictureOut);
        self.x264PictureOut = NULL;
    }
    if(self.x264Encoder) {
        x264_encoder_close(self.x264Encoder);
        self.x264Encoder = NULL;
    }
    if(self.x264Param) {
        free(self.x264Param);
        self.x264Param = NULL;
    }
    if(self.yuvData) {
        free(self.yuvData);
        self.yuvData = NULL;
    }
}

#pragma mark - callback
- (void)notifyVideoError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(encoder:videoEncodeFailed:)]) {
        [self.delegate encoder:self videoEncodeFailed:error];
    }
}

- (void)notifyAudioError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(encoder:audioEncodeFailed:)]) {
        [self.delegate encoder:self audioEncodeFailed:error];
    }
}

- (void)notifyCompleteFrame:(SGEncodedFrame *)frame {
    if([self.delegate respondsToSelector:@selector(encoder:didEncodedFrame:)]) {
        [self.delegate encoder:self didEncodedFrame:frame];
    }
}

@end
