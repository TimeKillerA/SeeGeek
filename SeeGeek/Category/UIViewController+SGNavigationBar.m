//
//  UIViewController+SGNavigationBar.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "UIViewController+SGNavigationBar.h"
#import <Aspects.h>
#import "SGViewControllerDelegate.h"

@implementation UIViewController (SGNavigationBar)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        // viewWillAppear
        [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
            UIViewController *viewController = aspectInfo.instance;

            // 如果未实现SGViewControllerDelegate，则认为不是本工程创建的viewcontroller，直接返回
            if(![viewController respondsToSelector:@selector(onViewModelLoaded:)]) {
                return;
            }
            // 隐藏系统的navigationbar
            viewController.navigationController.navigationBarHidden = YES;

            // 取消edgesForExtendedLayout
            viewController.edgesForExtendedLayout = UIRectEdgeNone;
        } error:NULL];

        // viewWillDisappear
        [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated){

        }error:NULL];
    });
}

@end
