//
//  SGPersonLocationSettingViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGPersonLocationSettingViewModel.h"
#import <ReactiveCocoa.h>

@interface SGPersonLocationSettingViewModel ()

@property (nonatomic, assign)SGPersonLocationType locationType;

@end

@implementation SGPersonLocationSettingViewModel

- (instancetype)initWithLocationType:(SGPersonLocationType)type {
    self = [self init];
    if(self) {
        self.locationType = type;
    }
    return self;
}

#pragma mark - SGPersonLocationSettingViewModelProtocol
- (RACSignal *)signalForLoadLocationData {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)signalForCommit {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (NSArray *)countryArray {
    return nil;
}

- (NSArray *)provinceArrayForCountry:(NSString *)country {
    return nil;
}

- (NSArray *)cityArrayForProvince:(NSString *)province {
    return nil;
}

- (NSArray *)areaArrayForCity:(NSString *)city {
    return nil;
}

- (NSString *)pageTitle {
    return nil;
}

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGPersonLocationSettingViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeNavigationChild;
}

@end
