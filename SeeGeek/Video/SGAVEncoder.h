//
//  SGAVEncoder.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SGAVEncoder;
@class SGEncodedFrame;
@class SGVideoConfigration;

@protocol SGAVEncoderDelegate <NSObject>

- (void)encoder:(SGAVEncoder *)encoder audioEncodeFailed:(NSError *)error;
- (void)encoder:(SGAVEncoder *)encoder videoEncodeFailed:(NSError *)error;
- (void)encoder:(SGAVEncoder *)encoder didEncodedFrame:(SGEncodedFrame *)frame;

@end

@interface SGAVEncoder : NSObject

@property (nonatomic, weak)id<SGAVEncoderDelegate> delegate;

- (void)updateVideoEncoderWithVideoConfigration:(SGVideoConfigration *)videoConfigration;

- (void)encodeAACWithSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)encodeH264WithSampleBuffer:(CMSampleBufferRef)sampleBuffer;

@end
