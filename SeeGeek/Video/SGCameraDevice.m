//
//  SGCameraDevice.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGCameraDevice.h"
#import "SGVideoConfigration.h"
#import "SGAudioConfigration.h"
#import "SGStreamConfigration.h"
#import <ReactiveCocoa.h>
#import "SGAVPublisher.h"
#import "SGAVEncoder.h"
#import "SGVideoRecorder.h"

@interface SGCameraDevice ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, SGAVEncoderDelegate, SGAVPublisherDelegate>

@property (nonatomic, strong) SGVideoConfigration        *videoConfigration;
@property (nonatomic, strong) SGAudioConfigration        *audioConfigration;
@property (nonatomic, strong) SGStreamConfigration       *streamConfigration;

@property (nonatomic, strong) AVCaptureSession           *captureSession;
@property (nonatomic, strong) AVCaptureVideoDataOutput   *videoOutput;
@property (nonatomic, strong) AVCaptureAudioDataOutput   *audioOutput;
@property (nonatomic, strong) AVCaptureDevice            *videoDevice;
@property (nonatomic, strong) AVCaptureDevice            *audioDevice;
@property (nonatomic, strong) AVCaptureDeviceInput       *videoInput;
@property (nonatomic, strong) AVCaptureDeviceInput       *audioInput;
@property (nonatomic, strong) dispatch_queue_t           videoQueue;
@property (nonatomic, strong) dispatch_queue_t           audioQueue;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic, strong) SGVideoRecorder            *recorder;
@property (nonatomic, strong) SGAVEncoder                *encoder;
@property (nonatomic, strong) SGAVPublisher              *publisher;

@end

@implementation SGCameraDevice

#pragma mark - live cycle
- (void)dealloc {
    [self stopPublish];
}

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithVideoConfigration:(SGVideoConfigration *)videoConfigration
                        audioConfigration:(SGAudioConfigration *)audioConfigration
                       streamConfigration:(SGStreamConfigration *)streamConfigration {
    self = [self init];
    if(self) {
        [self updateVideoConfigration:videoConfigration];
        [self updateAudioConfigration:audioConfigration];
        [self updateStreamConfigration:streamConfigration];
    }
    return self;
}

#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    if([captureOutput isKindOfClass:[AVCaptureVideoDataOutput class]]) {
        [self.encoder encodeH264WithSampleBuffer:sampleBuffer];
        [self.recorder appendSampleBuffer:sampleBuffer forVideo:YES];
    } else if ([captureOutput isKindOfClass:[AVCaptureAudioDataOutput class]]) {
        [self.recorder appendSampleBuffer:sampleBuffer forVideo:NO];
        [self.encoder encodeAACWithSampleBuffer:sampleBuffer];
    }
}

#pragma mark - SGAVEncoderDelegate
- (void)encoder:(SGAVEncoder *)encoder audioEncodeFailed:(NSError *)error {
    DDLogWarn(@"audioEncodeFailed %@", error);
}

- (void)encoder:(SGAVEncoder *)encoder videoEncodeFailed:(NSError *)error {
    DDLogWarn(@"videoEncodeFailed %@", error);
}

- (void)encoder:(SGAVEncoder *)encoder didEncodedFrame:(SGEncodedFrame *)frame {
    [self.publisher publishFrame:frame];
}

#pragma mark - SGAVPublisherDelegate
- (void)publisher:(SGAVPublisher *)publisher
    connectFailed:(NSError *)error {
    DDLogWarn(@"connectFailed %@", error);
}

- (void)publisher:(SGAVPublisher *)publisher
     didSendFrame:(SGEncodedFrame *)frame
            error:(NSError *)error {
    if(error) {
        DDLogWarn(@"didSendFrame %@", error);
    }
}


#pragma mark - public method
- (void)startPublish {
    if(self.isPublishStart) {
        return;
    }
    if(self.audioConfigration == nil
       || self.videoConfigration == nil
       || self.streamConfigration == nil) {
        return;
    }
    [self startSession];
    [self setupPreviewLayer];
    [self setIsPublishStart:YES];
}

- (void)stopPublish {
    if(!self.isPublishStart) {
        return;
    }
    [self stopSession];
    [self setIsPublishStart:NO];
}

- (void)startRecord {
    [self.recorder startRecordWithVideoConfigration:self.videoConfigration audioConfigration:self.audioConfigration];
}

- (void)stopRecord {
    [self.recorder stopRecord];
}

- (void)updateVideoConfigration:(SGVideoConfigration *)videoConfigration {
    self.videoConfigration = videoConfigration;
    [self.encoder updateVideoEncoderWithVideoConfigration:videoConfigration];
    [self updateConfigration];
}

- (void)updateAudioConfigration:(SGAudioConfigration *)audioConfigration {
    self.audioConfigration = audioConfigration;
}

- (void)updateStreamConfigration:(SGStreamConfigration *)streamConfigration {
    self.streamConfigration = streamConfigration;
    [self.publisher updateStreamConfigration:streamConfigration];
}

#pragma mark - help method
- (NSString *)sessionPreset {
    switch (self.videoConfigration.presetType) {
        case SGVideoPresetType352X288:
            return AVCaptureSessionPreset352x288;
            break;
        case SGVideoPresetType640X480:
            return AVCaptureSessionPreset640x480;
        default:
            return AVCaptureSessionPreset640x480;
    }
}

- (void)updateConfigration {

}

- (void)setupPreviewLayer {
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    if([self.delegate respondsToSelector:@selector(cameraDevice:previewLayer:)]) {
        [self.delegate cameraDevice:self previewLayer:self.previewLayer];
    }
}

- (void)startSession {
    [self.captureSession startRunning];
    [self.publisher startPublish];
}

- (void)stopSession {
    [self.captureSession removeInput:self.videoInput];
    [self.captureSession removeInput:self.audioInput];
    [self.captureSession removeOutput:self.videoOutput];
    [self.captureSession removeOutput:self.audioOutput];
    self.videoInput = nil;
    self.audioInput = nil;
    self.videoOutput = nil;
    self.audioOutput = nil;
    [self.captureSession stopRunning];
    self.captureSession = nil;
    [self.publisher stopPublish];
    [self.recorder stopRecord];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (void)setIsPublishStart:(BOOL)isPublishStart {
    _isPublishStart = isPublishStart;
}

#pragma mark - accessory
- (AVCaptureSession *)captureSession {
    if(!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureSession.sessionPreset = [self sessionPreset];
        if([_captureSession canAddInput:self.videoInput]) {
            [_captureSession addInput:self.videoInput];
        }
        if([_captureSession canAddInput:self.audioInput]) {
            [_captureSession addInput:self.audioInput];
        }
        if([_captureSession canAddOutput:self.videoOutput]) {
            [_captureSession addOutput:self.videoOutput];
        }
        if([_captureSession canAddOutput:self.audioOutput]) {
            [_captureSession addOutput:self.audioOutput];
        }
    }
    return _captureSession;
}

- (AVCaptureDeviceInput *)videoInput {
    if(!_videoInput) {
        _videoInput = [AVCaptureDeviceInput deviceInputWithDevice:self.videoDevice error:nil];
    }
    return _videoInput;
}

- (AVCaptureDeviceInput *)audioInput {
    if(!_audioInput) {
        _audioInput = [AVCaptureDeviceInput deviceInputWithDevice:self.audioDevice error:nil];
    }
    return _audioInput;
}

- (AVCaptureDevice *)videoDevice {
    if(!_videoDevice) {
        _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _videoDevice;
}

- (AVCaptureDevice *)audioDevice {
    if(!_audioDevice) {
        _audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    }
    return _audioDevice;
}

- (AVCaptureAudioDataOutput *)audioOutput {
    if(!_audioOutput) {
        _audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        [_audioOutput setSampleBufferDelegate:self queue:self.audioQueue];
    }
    return _audioOutput;
}

- (AVCaptureVideoDataOutput *)videoOutput {
    if(!_videoOutput) {
        _videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        [_videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
        NSDictionary *setcapSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange], kCVPixelBufferPixelFormatTypeKey,
                                        nil];
        _videoOutput.videoSettings = setcapSettings;
    }
    return _videoOutput;
}

- (dispatch_queue_t)videoQueue {
    if(!_videoQueue) {
        _videoQueue = dispatch_queue_create("queue.capture.video", NULL);
    }
    return _videoQueue;
}

- (dispatch_queue_t)audioQueue {
    if(!_audioQueue) {
        _audioQueue = dispatch_queue_create("queue.capture.audio", NULL);
    }
    return _audioQueue;
}

- (SGVideoRecorder *)recorder {
    if(!_recorder) {
        _recorder = [[SGVideoRecorder alloc] init];
    }
    return _recorder;
}

- (SGAVPublisher *)publisher {
    if(!_publisher) {
        _publisher = [[SGAVPublisher alloc] init];
        _publisher.delegate = self;
    }
    return _publisher;
}

- (SGAVEncoder *)encoder {
    if(!_encoder) {
        _encoder = [[SGAVEncoder alloc] init];
        _encoder.delegate = self;
    }
    return _encoder;
}

- (void)setFlashOn:(BOOL)flashOn {
    _flashOn = flashOn;
    if(![self.videoDevice hasTorch] || ![self.videoDevice hasFlash]) {
        return;
    }
    [self.captureSession beginConfiguration];
    [self.videoDevice lockForConfiguration:nil];
    if (flashOn) {
        [self.videoDevice setTorchMode:AVCaptureTorchModeOn];
        [self.videoDevice setFlashMode:AVCaptureFlashModeOn];
    } else {
        [self.videoDevice setTorchMode:AVCaptureTorchModeOff];
        [self.videoDevice setFlashMode:AVCaptureFlashModeOff];
    }
    [self.videoDevice unlockForConfiguration];
    [self.captureSession commitConfiguration];
}

- (void)setFrontCamera:(BOOL)frontCamera {
    if(_frontCamera == frontCamera) {
        return;
    }
    _frontCamera = frontCamera;
    AVCaptureDevice *newCamera = nil;
    AVCaptureDeviceInput *newInput = nil;
    if (!frontCamera) {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
    } else {
        newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
    }
    if(newCamera == nil) {
        return;
    }
    newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if(newInput == nil || ![self.captureSession canAddInput:newInput]) {
        return;
    }
    [self.captureSession beginConfiguration];
    [self.captureSession removeInput:self.videoInput];
    [self.captureSession addInput:self.videoInput];
    [self.captureSession commitConfiguration];
    _videoInput = newInput;
    _videoDevice = newCamera;
}


@end
