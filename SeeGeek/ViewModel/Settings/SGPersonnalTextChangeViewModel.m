//
//  SGPersonnalTextChangeViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGPersonnalTextChangeViewModel.h"
#import <ReactiveCocoa.h>
#import "NSString+Resource.h"

@interface SGPersonnalTextChangeViewModel ()

@property (nonatomic, assign)SGPersonnalTextType textType;
@property (nonatomic, copy)NSString *currentText;

@end

@implementation SGPersonnalTextChangeViewModel

- (instancetype)initWithTextType:(SGPersonnalTextType)type {
    self = [self init];
    if(self) {
        self.textType = type;
    }
    return self;
}

#pragma mark - SGPersonnalTextChangeViewModelProtocol
/**
 *  页面标题
 *
 *  @return
 */
- (NSString *)pageTitle {
    switch (self.textType) {
        case SGPersonnalTextTypeName: {
            return [NSString stringForKey:SG_TEXT_NICK_NAME];
        }
        case SGPersonnalTextTypeSign: {
            return [NSString stringForKey:SG_TEXT_PERSONNAL_SIGN];
        }
    }
}

/**
 *  当前的文本值
 *
 *  @return
 */
- (NSString *)currentText {
    return _currentText;
}

/**
 *  提交
 *
 *  @param text 修改后的值
 *
 *  @return
 */
- (RACSignal *)signalForSubmitWithText:(NSString *)text {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGPersonnalTextChangeViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeNavigationChild;
}

@end
