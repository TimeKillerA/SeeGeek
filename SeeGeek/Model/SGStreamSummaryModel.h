//
//  SGStreamSummaryModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGStreamSummaryModel : NSObject

/**
 *  视频流的ID
 */
@property (nonatomic, assign) SGIDInteger streamID;

/**
 *  视频流类型
 */
@property (nonatomic, assign) SGStreamType streamType;

/**
 *  视频流发生的地点
 */
@property (nonatomic, copy  ) NSString    *location;

/**
 *  视频流发生的经度
 */
@property (nonatomic, assign) double      longtitude;

/**
 *  视频流发生的维度
 */
@property (nonatomic, assign) double      lantitude;

/**
 *  视频流标题
 */
@property (nonatomic, copy  ) NSString    *streamTitle;

/**
 *  视频流标签
 */
@property (nonatomic, copy  ) NSString    *streamTag;

/**
 *  视频流标签ID
 */
@property (nonatomic, assign) SGIDInteger streamTagID;

/**
 *  喜欢数（点赞数）
 */
@property (nonatomic, assign) NSInteger   likeNumber;

/**
 *  评论数
 */
@property (nonatomic, assign) NSInteger   commentNumber;

/**
 *  视频时长,只在streamType == SGStreamTypeClip时才有意义
 */
@property (nonatomic, assign) NSInteger   duration;

/**
 *  视频流快照图片URL
 */
@property (nonatomic, copy  ) NSString    *snapshotUrl;

/**
 *  推荐的类型
 */
@property (nonatomic, assign) NSInteger   recommendType;

/**
 *  推荐类型描述（如“关注的地点”、“关注的人”等）
 */
@property (nonatomic, copy  ) NSString    *recommendTypeString;

@end
