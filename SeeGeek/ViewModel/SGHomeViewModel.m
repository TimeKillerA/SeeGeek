
//
//  SGHomeViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGHomeViewModel.h"
#import "SGMainPageViewModel.h"
#import "SGMainLocationViewModel.h"
#import "SGMainFindViewModel.h"
#import "SGMainUserViewModel.h"
#import "SGVideoViewModel.h"
#import "SGViewControllerDispatcher.h"

@interface SGHomeViewModel ()

@end

@implementation SGHomeViewModel

#pragma mark - SGViewControllerDispatcherDataSource

- (NSString *)classNameForViewController {
    return @"SGHomeViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (BOOL)shouldShowAnimation {
    return NO;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeWindowRoot;
}

#pragma mark - SGHomeViewModelProtocol
- (id)viewModelAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [[SGMainPageViewModel alloc] init];
        case 1:
            return [[SGMainLocationViewModel alloc] init];
        case 3:
            return [[SGMainFindViewModel alloc] init];
        case 4:
            return [[SGMainUserViewModel alloc] init];
        default:
            break;
    }
    return nil;
}

- (void)dispatchToVideoPublisher {
    SGVideoViewModel *viewModel = [[SGVideoViewModel alloc] init];
    [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
}

@end
