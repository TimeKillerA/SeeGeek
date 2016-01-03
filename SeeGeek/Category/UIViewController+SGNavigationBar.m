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
#import "SGRuntimeHeader.h"
#import "SGResource.h"

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

#pragma mark - public method
- (void)showDefaultNavigationBarWithTitle:(NSString *)title
{
    __weak typeof(self) weakSelf = self;
    [self showNavigationBarWithTitle:title right:nil rightAction:nil left:[UIImage imageForKey:SG_IMAGE_NAVIGATION_BACK] leftAction:^{
        if(weakSelf.navigationController)
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)showDefaultNavigationBarWithTitle:(NSString *)title right:(id)right rightAction:(NavigationAction)rightAction
{
    __weak typeof(self) weakSelf = self;
    [self showNavigationBarWithTitle:title right:right rightAction:rightAction left:[UIImage imageForKey:SG_IMAGE_NAVIGATION_BACK] leftAction:^{
        if(weakSelf.navigationController)
        {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)showNavigationBarWithTitle:(NSString *)title right:(id)right rightAction:(NavigationAction)rightAction left:(id)left leftAction:(NavigationAction)leftAction
{
    [self setup];
    self.navigationBarTitleLabel.text = title;
    self.navigationBarRightAction = rightAction;
    self.navigationBarLeftAction = leftAction;
    if([left isKindOfClass:[NSString class]])
    {
        [self.navigationBarLeftButton setTitle:left forState:UIControlStateNormal];
    }
    else if ([left isKindOfClass:[UIImage class]])
    {
        [self.navigationBarLeftButton setTitle:nil forState:UIControlStateNormal];
        [self.navigationBarLeftButton setImage:left forState:UIControlStateNormal];
    }
    else
    {
        [self.navigationBarLeftButton setTitle:nil forState:UIControlStateNormal];
        [self.navigationBarLeftButton setImage:nil forState:UIControlStateNormal];
    }
    if([right isKindOfClass:[NSString class]])
    {
        [self.navigationBarRightButton setTitle:right forState:UIControlStateNormal];
    }
    else if ([right isKindOfClass:[UIImage class]])
    {
        [self.navigationBarRightButton setImage:right forState:UIControlStateNormal];
    }
    else
    {
        [self.navigationBarRightButton setTitle:nil forState:UIControlStateNormal];
        [self.navigationBarRightButton setImage:nil forState:UIControlStateNormal];
    }
}

#pragma mark - setup
- (void)setup
{
    if(self.navigationBarView)
    {
        return;
    }
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, NAVIGATION_BAR_HEIGHT)];
    self.navigationBarView.backgroundColor = [UIColor colorForKey:SG_COLOR_TAB_SELECT];
    [self.view addSubview:self.navigationBarView];
    [self.view bringSubviewToFront:self.navigationBarView];

    self.navigationBarLineView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT - 0.5, SCREEN_WIDTH, 0.5)];
    self.navigationBarLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.14];
    [self.navigationBarView addSubview:self.navigationBarLineView];

    self.navigationBarLeftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 88, 44)];
    [self.navigationBarLeftButton setImage:[UIImage imageForKey:SG_IMAGE_NAVIGATION_BACK] forState:UIControlStateNormal];
    [self.navigationBarLeftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBarLeftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.navigationBarLeftButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 0)];
    [self.navigationBarView addSubview:self.navigationBarLeftButton];

    self.navigationBarRightButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth - 88, 20, 88, 44)];
    [self.navigationBarRightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationBarRightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationBarRightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    self.navigationBarRightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    [self.navigationBarView addSubview:self.navigationBarRightButton];

    self.navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 20, screenWidth - 88 * 2, 44)];
    self.navigationBarTitleLabel.font = [UIFont fontForKey:SG_FONT_H];
    self.navigationBarTitleLabel.textColor = [UIColor colorForFontKey:SG_FONT_H];
    self.navigationBarTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.navigationBarView addSubview:self.navigationBarTitleLabel];
}

#pragma mark - ui response
- (void)buttonClick:(UIButton *)sender
{
    if(sender == self.navigationBarLeftButton && self.navigationBarLeftAction)
    {
        self.navigationBarLeftAction();
    }
    else if (sender == self.navigationBarRightButton && self.navigationBarRightAction)
    {
        self.navigationBarRightAction();
    }
}

#pragma mark - accessory
OBJC_ASSOCIATED(navigationBarColor, setNavigationBarColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
OBJC_ASSOCIATED(navigationBarView, setNavigationBarView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
OBJC_ASSOCIATED(navigationBarTitleLabel, setNavigationBarTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
OBJC_ASSOCIATED(navigationBarLeftButton, setNavigationBarLeftButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
OBJC_ASSOCIATED(navigationBarRightButton, setNavigationBarRightButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
OBJC_ASSOCIATED(navigationBarLineView, setNavigationBarLineView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

- (NavigationAction)navigationBarLeftAction {
    return objc_getAssociatedObject(self, @selector(navigationBarLeftAction));
}

- (void)setNavigationBarLeftAction:(NavigationAction)navigationBarLeftAction {
    objc_setAssociatedObject(self, @selector(navigationBarLeftAction), navigationBarLeftAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NavigationAction)navigationBarRightAction {
    return objc_getAssociatedObject(self, @selector(navigationBarRightAction));
}

- (void)setNavigationBarRightAction:(NavigationAction)navigationBarRightAction {
    objc_setAssociatedObject(self, @selector(navigationBarRightAction), navigationBarRightAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
