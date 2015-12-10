//
//  SGVideoRecorder.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGVideoRecorder.h"
#import "SGAudioConfigration.h"
#import "SGVideoConfigration.h"

@interface SGVideoRecorder ()

@property (nonatomic, copy)NSString *directorPath;
@property (nonatomic, strong)SGAudioConfigration *audioConfigration;
@property (nonatomic, strong)SGVideoConfigration *videoConfigration;
@property (nonatomic, strong)AVAssetWriter *writer;
@property (nonatomic, assign)CMTime lastSampleTime;
@property (nonatomic, strong)AVAssetWriterInput *videoInput;
@property (nonatomic, strong)AVAssetWriterInput *audioInput;

@end

@implementation SGVideoRecorder

#pragma mark - life cycle

- (void)dealloc {
    [self stopRecord];
}

- (instancetype)init {
    self = [super init];
    if(self) {

    }
    return self;
}

#pragma mark - public method
- (void)startRecordWithVideoConfigration:(SGVideoConfigration *)videoConfigration
                       audioConfigration:(SGAudioConfigration *)audioConfigration {
    self.videoConfigration = videoConfigration;
    self.audioConfigration = audioConfigration;
    [self setup];
    _status = SGVideoRecorderStatusPrepared;
}
- (void)stopRecord {
    if(self.status != SGVideoRecorderStatusWriting) {
        return;
    }
    _status = SGVideoRecorderStatusStopped;
    [self.writer endSessionAtSourceTime:self.lastSampleTime];
    [self.writer finishWritingWithCompletionHandler:^{

    }];
}

- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer forVideo:(BOOL)isVideo {
    if(self.status == SGVideoRecorderStatusIdel || self.status == SGVideoRecorderStatusStopped) {
        return;
    }
    self.lastSampleTime = CMSampleBufferGetPresentationTimeStamp(sampleBuffer);
    if(self.status == SGVideoRecorderStatusPrepared) {
        _status = SGVideoRecorderStatusWriting;
        [self.writer startWriting];
        [self.writer startSessionAtSourceTime:self.lastSampleTime];
        
    }
    if(isVideo) {
        if(self.writer.status > AVAssetWriterStatusWriting) {
            DDLogWarn(@"Warning: writer status is %d", (int)self.writer.status);
            if(self.writer.status == AVAssetWriterStatusFailed) {
                DDLogError(@"Error: %@", self.writer.error);
            }
            return;
        }
        if([self.videoInput isReadyForMoreMediaData]) {
            if(![self.videoInput appendSampleBuffer:sampleBuffer]) {
                DDLogWarn(@"Unable to write to video input");
            }
        }
    } else {
        if(self.writer.status > AVAssetWriterStatusWriting) {
            DDLogWarn(@"Warning: writer status is %d", (int)self.writer.status);
            if(self.writer.status == AVAssetWriterStatusFailed) {
                DDLogError(@"Error: %@", self.writer.error);
            }
            return;
        }
        if([self.audioInput isReadyForMoreMediaData]) {
            if(![self.audioInput appendSampleBuffer:sampleBuffer]) {
                DDLogWarn(@"Unable to write to audio input");
            }
        }
    }
}

#pragma mark - help method
- (void)setup {
    if(self.videoConfigration == nil || self.audioConfigration == nil) {
        DDLogWarn(@"Can not record if video configration or audio configration is null");
        return;
    }
    [self initWriter];
    [self addVideoInput];
    [self addAudioInput];
}

- (void)initWriter {
    long long now = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *filePath = [NSString stringWithFormat:@"%@/%lld.mp4", self.directorPath, now];
    NSError *error;
    self.writer = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:filePath] fileType:AVFileTypeMPEG4 error:&error];
    if(self.writer == nil || error) {
        DDLogWarn(@"video record writer: %@ error: %@ path: %@", self.writer, error, filePath);
    }
}

- (void)addVideoInput {
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,[NSNumber numberWithInteger:self.videoConfigration.width], AVVideoWidthKey,[NSNumber numberWithInteger:self.videoConfigration.height],AVVideoHeightKey, nil];
    self.videoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    self.videoInput.expectsMediaDataInRealTime = YES;
    [self.writer addInput:self.videoInput];
}

- (void)addAudioInput {
    NSDictionary *audioOutputSettings = [ NSDictionary dictionaryWithObjectsAndKeys:
                                         [ NSNumber numberWithInt:kAudioFormatMPEG4AAC], AVFormatIDKey,
                                         [ NSNumber numberWithFloat:self.audioConfigration.sampleRate], AVSampleRateKey,
                                         [ NSNumber numberWithInteger:self.audioConfigration.channels], AVNumberOfChannelsKey,
                                         nil ];
    self.audioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioOutputSettings];
    [self.writer addInput:self.audioInput];
}

#pragma mark - accessory
- (NSString *)directorPath {
    if(!_directorPath) {
        NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _directorPath = [NSString stringWithFormat:@"%@/movie", document];
        BOOL isDirectory;
        do {
            if(![[NSFileManager defaultManager] fileExistsAtPath:_directorPath isDirectory:&isDirectory]) {
                break;
            }
            if(!isDirectory) {
                break;
            }
            return _directorPath;
        } while (NO);
        [[NSFileManager defaultManager] createDirectoryAtPath:_directorPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return _directorPath;
}

@end
