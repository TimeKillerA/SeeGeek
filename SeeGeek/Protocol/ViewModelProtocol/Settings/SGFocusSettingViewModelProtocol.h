//
//  SGFocusSettingViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGNetworkRequestProtocol.h"

@protocol SGFocusSettingViewModelProtocol <SGNetworkRequestProtocol>

/**
 *  页面标题
 *
 *  @return
 */
- (NSString *)pageTitle;

/**
 *  数据列表
 *
 *  @return
 */
- (NSArray *)dataArray;

/**
 *  关注或取消关注指定位置的数据
 *
 *  @param focus 是否关注
 *  @param index 位置
 *
 *  @return
 */
- (RACSignal *)signalForFocus:(BOOL)focus atIndex:(NSInteger)index;

/**
 *  删除粉丝
 *
 *  @param index 位置
 *
 *  @return
 */
- (RACSignal *)signalForRemoveFansAtIndex:(NSInteger)index;

/**
 *  加入黑名单
 *
 *  @param index 位置
 *
 *  @return
 */
- (RACSignal *)signalForAddToBlackList:(NSInteger)index;

@end
