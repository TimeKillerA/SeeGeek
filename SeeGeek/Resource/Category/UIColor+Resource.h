//
//  UIColor+Resource.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIColor (Resource)

+ (instancetype)colorForKey:(NSString *)key;
+ (instancetype)colorForFontKey:(NSString *)key;

/**
 *  返回argb描述的颜色值
 *
 *  @param argb 形式如下：
 *  1.#ffffffff, 2.255,255,255,255
 *
 *  若数值部分只有6位，则认为无透明度
 *  若数值部分只有3位或4位，则补齐至6位或8位  #333-》#333333
 *  @return
 */
+ (instancetype)colorForARGB:(NSString *)argb;

+ (instancetype)lineColor;

- (instancetype)alpha:(CGFloat)alpha;

@end

FOUNDATION_EXTERN NSString *const SG_COLOR_WHITE;
FOUNDATION_EXTERN NSString *const SG_COLOR_BLACK;
FOUNDATION_EXTERN NSString *const SG_COLOR_NAVIGATION;
FOUNDATION_EXTERN NSString *const SG_COLOR_TAB;
FOUNDATION_EXTERN NSString *const SG_COLOR_TAB_SELECT;
FOUNDATION_EXTERN NSString *const SG_COLOR_REFRESH_CELL_BG;
FOUNDATION_EXTERN NSString *const SG_COLOR_NORMAL_GRAY_BG;
FOUNDATION_EXTERN NSString *const SG_COLOR_CONTROLLER_GRAY_BG;
FOUNDATION_EXTERN NSString *const SG_COLOR_RED_BG;
FOUNDATION_EXTERN NSString *const SG_COLOR_SHARE_TITLE_BG;
FOUNDATION_EXTERN NSString *const SG_COLOR_BLUE_BUTTON_BG;
FOUNDATION_EXTERN NSString *const SG_COLOR_FIELD_GRAY;




