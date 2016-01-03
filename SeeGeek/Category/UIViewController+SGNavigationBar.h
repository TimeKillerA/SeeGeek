//
//  UIViewController+SGNavigationBar.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^NavigationAction)();

@interface UIViewController (SGNavigationBar)

@property (nonatomic, strong) UIColor          *navigationBarColor;
@property (nonatomic, copy  ) NavigationAction navigationBarLeftAction;
@property (nonatomic, copy  ) NavigationAction navigationBarRightAction;
@property (nonatomic, strong) UIView           *navigationBarView;
@property (nonatomic, strong) UILabel          *navigationBarTitleLabel;
@property (nonatomic, strong) UIButton         *navigationBarLeftButton;
@property (nonatomic, strong) UIButton         *navigationBarRightButton;
@property (nonatomic, strong) UIView           *navigationBarLineView;

- (void)showDefaultNavigationBarWithTitle:(NSString *)title;

- (void)showDefaultNavigationBarWithTitle:(NSString *)title right:(id)right rightAction:(NavigationAction)rightAction;

- (void)showNavigationBarWithTitle:(NSString *)title right:(id)right rightAction:(NavigationAction)rightAction left:(id)left leftAction:(NavigationAction)leftAction;


@end
