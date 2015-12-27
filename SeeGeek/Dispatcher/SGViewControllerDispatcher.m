//
//  SGViewControllerDispatcher.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGViewControllerDispatcher.h"
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SGViewControllerDelegate.h"
#import "SGHomeViewController.h"

@implementation SGViewControllerDispatcher

+ (void)dispatchToViewControllerWithViewControllerDispatcherDataSource:(id<SGViewControllerDispatcherDataSource>)dataSource {

    AppDelegate *app = [UIApplication sharedApplication].delegate;

    NSString *className = nil;
    if([dataSource respondsToSelector:@selector(classNameForViewController)]) {
        className = [dataSource classNameForViewController];
    }

    if(className.length == 0) {
        return;
    }

    SGViewControllerType type = 0;
    if([dataSource respondsToSelector:@selector(viewControllerType)]) {
        type = [dataSource viewControllerType];
    }

    BOOL animation = YES;
    if([dataSource respondsToSelector:@selector(shouldShowAnimation)]) {
        animation = [dataSource shouldShowAnimation];
    }

    Class class = NSClassFromString(className);
    if(!class){
        return;
    }
    id object = [[class alloc] init];
    if(![object isKindOfClass:[UIViewController class]] || ![object respondsToSelector:@selector(onViewModelLoaded:)]) {
        return;
    }
    id<SGViewControllerDelegate> viewController = object;
    id viewModel = nil;
    if([dataSource respondsToSelector:@selector(viewModelForViewController)]) {
        viewModel = [dataSource viewModelForViewController];
    }
    [viewController onViewModelLoaded:viewModel];

    switch (type) {
        case SGViewControllerTypeModel:
            [[SGViewControllerDispatcher currentViewController] presentViewController:(UIViewController *)object animated:animation completion:nil];
            break;
        case SGViewControllerTypeWindowRoot:
            app.window.rootViewController = (UIViewController *)object;
            break;
        case SGViewControllerTypeNavigationChild:
            [((UINavigationController *)[SGViewControllerDispatcher currentViewController]) pushViewController:(UIViewController *)object animated:animation];
            break;
        default:
            break;
    }

}

+ (UIViewController *)currentViewController {
    UIViewController* activityViewController = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if(tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }

    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0) {
        UIView *frontView = [viewsArray objectAtIndex:0];
        id nextResponder = [frontView nextResponder];
        if([nextResponder isKindOfClass:[UIViewController class]]) {
            activityViewController = nextResponder;
        } else{
            activityViewController = window.rootViewController;
        }
    }
    if([activityViewController isKindOfClass:[SGHomeViewController class]]) {
        activityViewController = [(SGHomeViewController *)activityViewController selectedViewController];
    }

    return activityViewController;
}

@end
