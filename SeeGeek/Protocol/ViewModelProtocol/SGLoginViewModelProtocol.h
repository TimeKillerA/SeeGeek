//
//  SGLoginViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol SGLoginViewModelProtocol <NSObject>

@property (nonatomic, copy)NSString *account;
@property (nonatomic, copy)NSString *password;

@optional

/**
 *  上次登录使用的账号
 *
 *  @return
 */
- (NSString *)accountForLastLogin;

/**
 *  发起登录请求并返回登录的信号
 *
 *  @return
 */
- (RACSignal *)signalForLogin;

/**
 *  发起第三方登录请求并返回登录信号
 *
 *  @param type 第三方登录类型
 *
 *  @return 
 */
- (RACSignal *)signalForLoginWithThirdpartType:(SGThirdPartType)type;

@end
