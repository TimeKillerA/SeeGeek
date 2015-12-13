//
//  SGMainPageViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol SGMainPageViewModelProtocol <NSObject>

/**
 *  返回视频流字典结构的列表
 *  每一个item都是一个dictionary，每个dictionary的结构如下
 *  key:推荐类型字符串（“热门”）
 *  value:SGStreamSummaryModel的列表
 *
 *  @return
 */
- (NSArray *)streamsArray;

/**
 *  请求某个Section中的数据
 *
 *  @param section
 *  @param more
 *
 *  @return
 */
- (RACSignal *)signalForLoadDataWithSection:(NSInteger)section more:(BOOL)more;

/**
 *  进入Section和index指向的SGStreamSummaryModel的详情页
 *
 *  @param key
 *  @param index
 */
- (void)dispatchWithSection:(NSInteger)section index:(NSInteger)index;

- (void)setExpand:(BOOL)expand atSection:(NSInteger)section;
- (BOOL)expandAtSection:(NSInteger)section;

@end
