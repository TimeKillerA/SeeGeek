//
//  SGEncodedFrame.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SGEncodedFrameType) {
    SGEncodedFrameTypeVideoSPS = 1,
    SGEncodedFrameTypeVideoPPS,
    SGEncodedFrameTypeVideoData,
    SGEncodedFrameTypeAudioHeader,
    SGEncodedFrameTypeAudioBody,
};

@interface SGEncodedFrame : NSObject

@property (nonatomic, copy)NSData *data;
@property (nonatomic, assign)SGEncodedFrameType type;

+ (instancetype)frameWithData:(NSData *)data type:(SGEncodedFrameType)type;

@end
