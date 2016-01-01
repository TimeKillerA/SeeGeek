//
//  SGAPIHelper.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSError+Constructor.h"

typedef void(^SGAPICallback)(BOOL success, id data, NSError *error);

@interface SGAPIHelper : NSObject

/**
 *  请求启动页面的广告数据
 *
 *  @param callback 回调
 */
+ (void)sendRequestForLaunchAdDataWithCallback:(SGAPICallback)callback;

#pragma mark - stream list
/**
 *  获取关注列表
 *
 *  @param start    起始位置
 *  @param count    请求数量
 *  @param callback
 */
+ (void)sendRequestForFocusStreamListWithStart:(NSInteger)start
                                         count:(NSInteger)count
                                      callback:(SGAPICallback)callback;

@end
