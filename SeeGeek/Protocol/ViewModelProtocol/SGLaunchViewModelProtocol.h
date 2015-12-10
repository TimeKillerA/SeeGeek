//
//  SGLaunchViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGNetworkRequestProtocol.h"

/**
 *  启动页面协议，定义启动页面包含的操作
 */
@protocol SGLaunchViewModelProtocol <SGNetworkRequestProtocol>

/**
 *  对于当前版本是否是第一次启动
 *
 *  @return 是否第一次启动
 */
- (BOOL)isFirstLaunchForThisVersion;

/**
 *  进入下一页
 */
- (void)dispatchToNextPage;

@end
