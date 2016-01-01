//
//  SGVideoViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol SGVideoViewModelProtocol <NSObject>

- (SGStreamType)streamType;
- (BOOL)isVideoPublisher;

#pragma mark - play

/**
 *  视频的播放地址
 *
 *  @return
 */
- (NSString *)playUrl;

/**
 *  视频的上传地址
 *
 *  @return
 */
- (NSString *)publishUrl;

/**
 *  播放时间变化信号
 *
 *  @return
 */
- (RACSignal *)signalForPlayTimeChanged;

#pragma mark - action
/**
 *  举报
 *
 *  @return
 */
- (RACSignal *)signalForReport;

/**
 *  点赞
 *
 *  @return
 */
- (RACSignal *)signalForLike;

/**
 *  发布评论
 *
 *  @param comment 评论内容
 *
 *  @return
 */
- (RACSignal *)signalForSendComment:(NSString *)comment;

/**
 *  发布分享
 *
 *  @param shareType 平台类型
 *
 *  @return
 */
- (RACSignal *)signalForShareWithType:(SGThirdPartType)shareType;

/**
 *  请求用户信息
 *
 *  @param userId 用户ID
 *
 *  @return
 */
- (RACSignal *)signalForLoadUserDataWithId:(SGIDInteger)userId;

/**
 *  关注或取消关注用户
 *
 *  @param userId 用户ID
 *  @param focus  是否关注
 *
 *  @return
 */
- (RACSignal *)signalForFocusUserWithId:(SGIDInteger)userId focus:(BOOL)focus;

/**
 *  关注或取消关注地理位置
 *
 *  @param longitude 经度
 *  @param lantitude 纬度
 *  @param focus
 *
 *  @return
 */
- (RACSignal *)signalForFocusPlaceLongitude:(double)longitude lantitude:(double)lantitude focus:(BOOL)focus;

/**
 *  上传文件
 *
 *  @param videoFilePath 文件路径
 *
 *  @return
 */
- (RACSignal *)signalForUploadVideoFile:(NSString *)videoFilePath;

@end
