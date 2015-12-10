//
//  SGAVPublisher.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SGEncodedFrame;
@class SGStreamConfigration;
@class SGAVPublisher;

@protocol SGAVPublisherDelegate <NSObject>

@optional
- (void)publisher:(SGAVPublisher *)publisher
    connectFailed:(NSError *)error;

- (void)publisher:(SGAVPublisher *)publisher
     didSendFrame:(SGEncodedFrame *)frame
           error:(NSError *)error;

@end

@interface SGAVPublisher : NSObject

@property (nonatomic, weak)id<SGAVPublisherDelegate> delegate;

- (void)updateStreamConfigration:(SGStreamConfigration *)streamConfigration;
- (void)startPublish;
- (void)stopPublish;
- (void)publishFrame:(SGEncodedFrame *)frame;

@end
