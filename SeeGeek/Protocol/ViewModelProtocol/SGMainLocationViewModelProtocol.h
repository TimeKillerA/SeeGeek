//
//  SGMainLocationViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/19.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@class SGVideoLocationModel;

@protocol SGMainLocationViewModelProtocol <NSObject>

/**
 *  返回SGVideoLocationModel的数组
 *
 *  @return
 */
- (NSArray *)streamLocationArray;

/**
 *  返回model对应的streamSummary数组，需要在调用了signalForLoadStreamDataWithLocation方法后调用此方法
 *
 *  @param model
 *
 *  @return
 */
- (NSArray *)streamSummaryArrayForLocation:(SGVideoLocationModel *)model;

- (RACSignal *)signalForLoadLocationData;
- (RACSignal *)signalForLoadStreamDataWithLocation:(SGVideoLocationModel *)model
                                              more:(BOOL)more;
- (RACSignal *)signalForSearchWithKeyWorld:(NSString *)keyworld;
- (RACSignal *)signalForFocusLocation:(SGVideoLocationModel *)model;

@end
