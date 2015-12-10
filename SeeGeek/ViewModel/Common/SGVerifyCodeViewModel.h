//
//  SGVerifyCodeViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/7.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@interface SGVerifyCodeViewModel : NSObject

@property (nonatomic, copy)NSString *phoneNumber;
@property (nonatomic, assign)NSTimeInterval timeInterval;
@property (nonatomic, assign, readonly)NSTimeInterval leftTimeToWait;

/**
 *  初始化方法
 *
 *  @param time 两次请求验证码的最小时间间隔
 *
 *  @return
 */
- (instancetype)initWithMinInterval:(NSTimeInterval)time;

- (RACSignal *)signalForSendCode;

@end
