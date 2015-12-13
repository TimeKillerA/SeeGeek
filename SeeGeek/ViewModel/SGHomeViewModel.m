
//
//  SGHomeViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGHomeViewModel.h"
#import "SGMainPageViewModel.h"

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
            break;

        default:
            break;
    }
    return nil;
}

@end
