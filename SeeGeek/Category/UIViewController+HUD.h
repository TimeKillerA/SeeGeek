//
//  UIViewController+HUD.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showDefaultProgressHUD;
- (void)showProgressHUDWithProgress:(CGFloat)progress;
- (void)showDefaultTextHUD:(NSString *)text;
- (void)showTextHUD:(NSString *)text duration:(CGFloat)duration;
- (void)dismissHUD;

@end
