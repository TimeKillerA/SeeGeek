//
//  SGCameraDevice.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SGCameraDevice;

@protocol SGCameraDeviceDelegate <NSObject>

@optional
- (void)cameraDevice:(SGCameraDevice *)cameraDevice
        previewLayer:(AVCaptureVideoPreviewLayer *)previewLayer;

- (void)cameraDevice:(SGCameraDevice *)cameraDevice
   didRecordComplete:(NSURL *)fileURL;

- (void)cameraDevice:(SGCameraDevice *)cameraDevice
     didRecordFailed:(NSError *)error;

- (void)cameraDevice:(SGCameraDevice *)cameraDevice
       publishFailed:(NSError *)error;

@end

@class SGVideoConfigration;
@class SGAudioConfigration;
@class SGStreamConfigration;

@interface SGCameraDevice : NSObject

@property (nonatomic, assign, readonly)BOOL isPublishStart;
@property (nonatomic, assign)BOOL flashOn;
@property (nonatomic, assign)BOOL frontCamera;
@property (nonatomic, weak)id<SGCameraDeviceDelegate> delegate;

- (instancetype)initWithVideoConfigration:(SGVideoConfigration *)videoConfigration
                        audioConfigration:(SGAudioConfigration *)audioConfigration
                       streamConfigration:(SGStreamConfigration *)streamConfigration;

- (void)startPublish;
- (void)stopPublish;

- (void)startRecord;
- (void)stopRecord;

- (void)updateVideoConfigration:(SGVideoConfigration *)videoConfigration;
- (void)updateAudioConfigration:(SGAudioConfigration *)audioConfigration;
- (void)updateStreamConfigration:(SGStreamConfigration *)streamConfigration;

@end
