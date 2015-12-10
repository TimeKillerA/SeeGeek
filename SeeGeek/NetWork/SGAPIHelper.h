//
//  SGAPIHelper.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SGAPICallback)(BOOL success, id data, NSError *error);

@interface SGAPIHelper : NSObject

/**
 *  请求启动页面的广告数据
 *
 *  @param callback 回调
 */
+ (void)sendRequestForLaunchAdDataWithCallback:(SGAPICallback)callback;

@end
