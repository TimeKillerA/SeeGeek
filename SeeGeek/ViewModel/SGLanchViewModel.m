//
//  SGLanchViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGLanchViewModel.h"
#import "SGAPIHelper.h"
#import "ParameterUtil.h"
#import "SGHomeViewModel.h"
#import "SGViewControllerDispatcher.h"

@interface SGLanchViewModel ()

@property (nonatomic, assign)BOOL firstLaunch;

@end

@implementation SGLanchViewModel

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setup];
    }
    return self;
}

#pragma mark - private method
- (void)setup {
    [self setupFirstLaunch];
}

- (void)setupFirstLaunch {
//    NSString *version = [ParameterUtil appVersion];
//    if(![[NSUserDefaults standardUserDefaults] objectForKey:version])
//    {
//        _firstLaunch = YES;
//        [[NSUserDefaults standardUserDefaults] setValue:version forKey:version];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//    }
//    else
//    {
//        _firstLaunch = NO;
//    }
    _firstLaunch = NO;
}

- (void)dispatchToHomePage {
    SGHomeViewModel *viewModel = [[SGHomeViewModel alloc] init];
    [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
}

- (void)dispatchToGuidePage {

}

#pragma mark - SGLaunchViewModelProtocol
- (BOOL)isFirstLaunchForThisVersion {
    return self.firstLaunch;
}

- (void)dispatchToNextPage {
    if(self.isFirstLaunchForThisVersion) {
        [self dispatchToGuidePage];
    } else {
        [self dispatchToHomePage];
    }
}

#pragma mark - SGNetworkRequestProtocol
- (RACSignal *)signalForLoadData {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [SGAPIHelper sendRequestForLaunchAdDataWithCallback:^(BOOL success, id data, NSError *error) {
            if(success) {

            } else {
                [subscriber sendError:error];
            }
        }];
        return nil;
    }];
}

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGLaunchViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeWindowRoot;
}

@end
