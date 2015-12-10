//
//  SGRegisterViewModelDelegate.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/7.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol SGRegisterViewModelDelegate <NSObject>

@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *verifyPassword;

/**
 *  请求验证码
 *
 *  @return
 */
- (RACSignal *)signalForRequestVerifyCode;

/**
 *  请求注册
 *
 *  @return 
 */
- (RACSignal *)signalForRegist;

/**
 *  发送验证码的剩余时间发生改变
 *
 *  @return
 */
- (RACSignal *)signalForLeftTimeSendCodeChanged;

@end
