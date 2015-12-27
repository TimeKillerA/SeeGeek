//
//  SGMainUserViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol SGMainUserViewModelProtocol <NSObject>

/**
 *  发布视频的数量
 *
 *  @return
 */
- (NSInteger)countForPublish;

/**
 *  关注的数量
 *
 *  @return
 */
- (NSInteger)countForFocus;

/**
 *  粉丝数量
 *
 *  @return
 */
- (NSInteger)countForFans;

/**
 *  用户签名
 *
 *  @return
 */
- (NSString *)userSign;

/**
 *  用户头像
 *
 *  @return
 */
- (NSString *)userHeadImage;

/**
 *  用户名称
 *
 *  @return
 */
- (NSString *)userName;

/**
 *  请求到的视频流列表
 *
 *  @return
 */
- (NSArray *)streams;

/**
 *  加载数据数量，发布数、关注数、粉丝数
 *
 *  @return
 */
- (RACSignal *)signalForLoadCountData;

/**
 *  加载用户数据，头像、名称、个性签名等
 *
 *  @return
 */
- (RACSignal *)signalForLoadUserData;

/**
 *  加载发布的流信息
 *
 *  @param more 是否加载更多
 *
 *  @return
 */
- (RACSignal *)signalForLoadStreamData:(BOOL)more;

/**
 *  进入系统设置
 */
- (void)dispatchToSystemSettings;

/**
 *  进入个人设置
 */
- (void)dispatchToPersonnalSettings;

@end
