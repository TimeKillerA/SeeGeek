//
//  SGHomeViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/9.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGHomeViewController.h"
#import "SGViewControllerHeader.h"
#import "SGHomeViewModelProtocol.h"
#import <RDVTabBarItem.h>
#import "SGViewControllerDelegate.h"
#import "SGMainPageViewController.h"
#import "SGMainLocationViewController.h"
#import "SGMainRecordViewController.h"
#import "SGMainFindViewController.h"
#import "SGMainUserViewController.h"
#import "SGResource.h"
#import "SGSwipNavigationController.h"

@interface SGHomeViewController ()<SGViewControllerDelegate, RDVTabBarControllerDelegate>

@property (nonatomic, strong)UINavigationController *navigationTab1;
@property (nonatomic, strong)UINavigationController *navigationTab2;
@property (nonatomic, strong)UINavigationController *navigationTab3;
@property (nonatomic, strong)UINavigationController *navigationTab4;
@property (nonatomic, strong)UINavigationController *navigationTab5;

@property (nonatomic, strong)id<SGHomeViewModelProtocol> viewModel;

@end

@implementation SGHomeViewController

#pragma mark - life cycle
- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupListeners];
    [self setupViewControllers];
    [self setupTabbar];
    [self setupTabbarItem];
}

#pragma mark - setup
- (void)setupListeners {
    [self listenTabbarHidden];
    self.delegate = self;
}

- (void)setupTabbar {
    self.tabBar.translucent = YES;
    [self.tabBar setHeight:TAB_BAR_HEIGHT];
    self.tabBar.backgroundView.backgroundColor = [UIColor colorForKey:SG_COLOR_TAB];
}

- (void)setupTabbarItem {
    int i = 0;
    NSArray *TABBAR_TITLES = @[[NSString stringForKey:SG_TEXT_HOME], [NSString stringForKey:SG_TEXT_LOCATION], [NSString stringForKey:SG_TEXT_RECORD], [NSString stringForKey:SG_TEXT_FIND], [NSString stringForKey:SG_TEXT_ME]];
    for (RDVTabBarItem *item in [[self tabBar] items]) {
        item.title = [TABBAR_TITLES objectAtIndex:i];
        if(i != 2) {
            item.unselectedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontForKey:SG_FONT_A], NSFontAttributeName, [UIColor colorForFontKey:SG_FONT_A], NSForegroundColorAttributeName, nil];
            item.selectedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontForKey:SG_FONT_B], NSFontAttributeName, [UIColor colorForFontKey:SG_FONT_B], NSForegroundColorAttributeName, nil];
        } else {
            item.unselectedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontForKey:SG_FONT_C], NSFontAttributeName, [UIColor colorForFontKey:SG_FONT_C], NSForegroundColorAttributeName, nil];
            item.selectedTitleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontForKey:SG_FONT_C], NSFontAttributeName, [UIColor colorForFontKey:SG_FONT_C], NSForegroundColorAttributeName, nil];
        }
        item.titlePositionAdjustment = UIOffsetMake(0, 3);
        switch (i) {
            case 0:
                [item setFinishedSelectedImage:[UIImage imageForKey:SG_IMAGE_TAB_HOME_SELECT] withFinishedUnselectedImage:[UIImage imageForKey:SG_IMAGE_TAB_HOME]];
                break;
            case 1:
                [item setFinishedSelectedImage:[UIImage imageForKey:SG_IMAGE_TAB_LOCATION_SELECT] withFinishedUnselectedImage:[UIImage imageForKey:SG_IMAGE_TAB_LOCATION]];
                break;
            case 2:
                [item setBackgroundColor:[UIColor colorForKey:SG_COLOR_TAB_SELECT]];
                [item setFinishedSelectedImage:[UIImage imageForKey:SG_IMAGE_TAB_RECORD] withFinishedUnselectedImage:[UIImage imageForKey:SG_IMAGE_TAB_RECORD]];
                break;
            case 3:
                [item setFinishedSelectedImage:[UIImage imageForKey:SG_IMAGE_TAB_FIND_SELECT] withFinishedUnselectedImage:[UIImage imageForKey:SG_IMAGE_TAB_FIND]];
                break;
            case 4:
                [item setFinishedSelectedImage:[UIImage imageForKey:SG_IMAGE_TAB_ME_SELECT] withFinishedUnselectedImage:[UIImage imageForKey:SG_IMAGE_TAB_ME]];
                break;
            default:
                break;
        }
        i++;
    }
}

- (void)setupViewControllers {
    [self setViewControllers:@[self.navigationTab1, self.navigationTab2, self.navigationTab3, self.navigationTab4, self.navigationTab5]];
}

- (void)listenTabbarHidden {
    WS(weakSelf);
    RACSignal*showNavigationController1RootSignal = [RACObserve(self.navigationTab1, viewControllers) map:^id(NSArray *value) {
        return [NSNumber numberWithInteger:[value count]];
    }];
    RACSignal*showNavigationController2RootSignal = [RACObserve(self.navigationTab2, viewControllers) map:^id(NSArray *value) {
        return [NSNumber numberWithInteger:[value count]];
    }];
    RACSignal*showNavigationController3RootSignal = [RACObserve(self.navigationTab3, viewControllers) map:^id(NSArray *value) {
        return [NSNumber numberWithInteger:[value count]];
    }];
    RACSignal*showNavigationController4RootSignal = [RACObserve(self.navigationTab4, viewControllers) map:^id(NSArray *value) {
        return [NSNumber numberWithInteger:[value count]];
    }];
    RACSignal*showNavigationController5RootSignal = [RACObserve(self.navigationTab5, viewControllers) map:^id(NSArray *value) {
        return [NSNumber numberWithInteger:[value count]];
    }];
    RACSignal *showTabbarSignal = [RACSignal combineLatest:@[showNavigationController1RootSignal, showNavigationController2RootSignal, showNavigationController3RootSignal, showNavigationController4RootSignal, showNavigationController5RootSignal] reduce:^id(NSNumber *count1, NSNumber *count2, NSNumber *count3, NSNumber *count4, NSNumber *count5){
        if([count1 integerValue] > 1 || [count2 integerValue] > 1 || [count3 integerValue] > 1 || [count4 integerValue] > 1 || [count5 integerValue] > 1)
        {
            return @NO;
        }
        return @YES;
    }];
    [showTabbarSignal subscribeNext:^(id x) {
        if([x boolValue])
        {
            if(!weakSelf.tabBar.hidden)
            {
                return;
            }
            [weakSelf setTabBarHidden:NO animated:YES];
        }
        else
        {
            if(weakSelf.tabBar.hidden)
            {
                return;
            }
            [weakSelf setTabBarHidden:YES animated:YES];
        }
    }];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - RDVTabBarControllerDelegate
- (BOOL)tabBarController:(RDVTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if(viewController != self.navigationTab3) {
        return YES;
    }
    [self.viewModel dispatchToVideoPublisher];
    return NO;
}

#pragma mark - accessory
- (UINavigationController *)navigationTab1 {
    if(!_navigationTab1) {
        SGMainPageViewController *viewController = [[SGMainPageViewController alloc] init];
        if([viewController respondsToSelector:@selector(onViewModelLoaded:)]) {
            [viewController onViewModelLoaded:[self.viewModel viewModelAtIndex:0]];
        }
        _navigationTab1 = [[SGSwipNavigationController alloc] initWithRootViewController:viewController];
    }
    return _navigationTab1;
}

- (UINavigationController *)navigationTab2 {
    if(!_navigationTab2) {
        SGMainLocationViewController *viewController = [[SGMainLocationViewController alloc] init];
        if([viewController respondsToSelector:@selector(onViewModelLoaded:)]) {
            [viewController onViewModelLoaded:[self.viewModel viewModelAtIndex:1]];
        }
        _navigationTab2 = [[SGSwipNavigationController alloc] initWithRootViewController:viewController];
    }
    return _navigationTab2;
}

- (UINavigationController *)navigationTab3 {
    if(!_navigationTab3) {
        SGMainRecordViewController *viewController = [[SGMainRecordViewController alloc] init];
        if([viewController respondsToSelector:@selector(onViewModelLoaded:)]) {
            [viewController onViewModelLoaded:[self.viewModel viewModelAtIndex:2]];
        }
        _navigationTab3 = [[SGSwipNavigationController alloc] initWithRootViewController:viewController];
    }
    return _navigationTab3;
}

- (UINavigationController *)navigationTab4 {
    if(!_navigationTab4) {
        SGMainFindViewController *viewController = [[SGMainFindViewController alloc] init];
        if([viewController respondsToSelector:@selector(onViewModelLoaded:)]) {
            [viewController onViewModelLoaded:[self.viewModel viewModelAtIndex:3]];
        }
        _navigationTab4 = [[SGSwipNavigationController alloc] initWithRootViewController:viewController];
    }
    return _navigationTab4;
}

- (UINavigationController *)navigationTab5 {
    if(!_navigationTab5) {
        SGMainUserViewController *viewController = [[SGMainUserViewController alloc] init];
        if([viewController respondsToSelector:@selector(onViewModelLoaded:)]) {
            [viewController onViewModelLoaded:[self.viewModel viewModelAtIndex:4]];
        }
        _navigationTab5 = [[SGSwipNavigationController alloc] initWithRootViewController:viewController];
    }
    return _navigationTab5;
}

@end
