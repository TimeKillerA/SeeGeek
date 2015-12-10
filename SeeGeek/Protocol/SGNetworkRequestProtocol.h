//
//  SGNetworkRequestProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa.h>

/**
 *  定义发起网络请求的接口
 */
@protocol SGNetworkRequestProtocol <NSObject>

@optional

/**
 *  请求详细数据的接口
 *
 *  @return
 */
- (RACSignal *)signalForLoadData;

/**
 *  请求分页加载的列表数据
 *
 *  @param more 是否请求更多数据
 *
 *  @return
 */
- (RACSignal *)signalForLoadMoreData:(BOOL)more;

/**
 *  请求需要带额外参数的数据
 *
 *  @param params 参数列表
 *
 *  @return 
 */
- (RACSignal *)signalForLoadDataWithExternParams:(NSDictionary *)params;

@end
