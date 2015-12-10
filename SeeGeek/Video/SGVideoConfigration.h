//
//  SGVideoConfigration.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SGVideoPresetType) {
    SGVideoPresetType640X480,
    SGVideoPresetType352X288,
};

@interface SGVideoConfigration : NSObject

/**
 *  录制视频的宽高, 默认SGVideoPresetType640X480
 */
@property (nonatomic, assign) SGVideoPresetType     presetType;

/**
 *  帧率,默认25FPS
 */
@property (nonatomic, assign) NSInteger             frameRate;

/**
 *  关键帧的间隔时间，默认1秒
 */
@property (nonatomic, assign) NSInteger             keyFrameInterval;

/**
 *  比特率，默认400*1000
 */
@property (nonatomic, assign) NSInteger             bitRate;
@property (nonatomic, assign, readonly) NSInteger   width;
@property (nonatomic, assign, readonly) NSInteger   height;

@end
