//
//  SGMainFindViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/20.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGNetworkRequestProtocol.h"

@protocol SGMainFindViewModelProtocol <SGNetworkRequestProtocol>

/**
 *  获取当前的数据列表
 *
 *  @return
 */
- (NSArray *)currentDataArray;

/**
 *  获取自最后一次有事件开始到当前的时间间隔，单位是秒
 *
 *  @return 
 */
- (NSInteger)timeIntervalFromLastAction;

/**
 *  进入下一页
 *
 *  @param index
 */
- (void)dispatchToNextAtIndex:(NSInteger)index;

@end
