//
//  SGVideoRecorder.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, SGVideoRecorderStatus) {
    SGVideoRecorderStatusIdel,
    SGVideoRecorderStatusPrepared,
    SGVideoRecorderStatusWriting,
    SGVideoRecorderStatusStopped,
};

@class SGVideoConfigration;
@class SGAudioConfigration;

@interface SGVideoRecorder : NSObject

@property (nonatomic, assign, readonly)SGVideoRecorderStatus status;

- (void)startRecordWithVideoConfigration:(SGVideoConfigration *)videoConfigration
                       audioConfigration:(SGAudioConfigration *)audioConfigration;
- (void)stopRecord;
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer forVideo:(BOOL)isVideo;

@end
