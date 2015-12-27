//
//  SGPersonLocationSettingViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol SGPersonLocationSettingViewModelProtocol <NSObject>

/**
 *  请求地址数据（省市县等）
 *
 *  @return
 */
- (RACSignal *)signalForLoadLocationData;

/**
 *  提交选择的地址
 *
 *  @return
 */
- (RACSignal *)signalForCommit;

/**
 *  国家列表
 *
 *  @return
 */
- (NSArray *)countryArray;

/**
 *  根据国家请求省列表
 *
 *  @param country 国家的唯一标识符
 *
 *  @return
 */
- (NSArray *)provinceArrayForCountry:(NSString *)country;

/**
 *  根据省请求城市列表
 *
 *  @param province 省的唯一标识符
 *
 *  @return
 */
- (NSArray *)cityArrayForProvince:(NSString *)province;

/**
 *  根据城市请求县/区列表
 *
 *  @param city 市的唯一标识符
 *
 *  @return
 */
- (NSArray *)areaArrayForCity:(NSString *)city;

/**
 *  页面标题
 *
 *  @return
 */
- (NSString *)pageTitle;

@end
