//
//  SGLoginViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGLoginViewModel.h"
#import "../../Macro/SGRuntimeHeader.h"
#import <ReactiveCocoa.h>

@implementation SGLoginViewModel

#pragma mark - life cycle


#pragma mark - SGLoginViewModelProtocol

OBJC_ASSOCIATED(account, setAccount, OBJC_ASSOCIATION_COPY_NONATOMIC)
OBJC_ASSOCIATED(password, setPassword, OBJC_ASSOCIATION_COPY_NONATOMIC)

- (NSString *)accountForLastLogin {
    return nil;
}

- (RACSignal *)signalForLogin {
    return nil;
}

- (RACSignal *)signalForLoginWithThirdpartType:(SGThirdPartType)type {
    return nil;
}

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGLoginViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeNavigationRoot;
}

@end
