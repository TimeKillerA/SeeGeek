//
//  SGLanchViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGLanchViewModel.h"
#import "SGAPIHelper.h"

@implementation SGLanchViewModel

#pragma mark - SGLaunchViewModelProtocol
- (BOOL)isFirstLaunchForThisVersion {
    return YES;
}

- (void)dispatchToNextPage {

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
