//
//  SGFindPasswordViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/7.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGFindPasswordViewModel.h"
#import <ReactiveCocoa.h>
#import "SGRuntimeHeader.h"

@interface SGFindPasswordViewModel ()

@end

@implementation SGFindPasswordViewModel

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGRegisterViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeNavigationChild;
}

#pragma mark - SGRegisterViewModelDelegate
OBJC_ASSOCIATED(phoneNumber, setPhoneNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);
OBJC_ASSOCIATED(verifyCode, setVerifyCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
OBJC_ASSOCIATED(password, setPassword, OBJC_ASSOCIATION_COPY_NONATOMIC);
OBJC_ASSOCIATED(verifyPassword, setVerifyPassword, OBJC_ASSOCIATION_COPY_NONATOMIC);

- (RACSignal *)signalForRequestVerifyCode {
    return nil;
}

- (RACSignal *)signalForResetPassword {
    return nil;
}

- (RACSignal *)signalForLeftTimeSendCodeChanged {
    return nil;
}

@end
