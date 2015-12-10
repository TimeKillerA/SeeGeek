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
 *  返回rgba描述的颜色值
 *
 *  @param argb 形式如下：
 *  1.0xfff, 2.0xffffff, 3.0xff,0xff,0xff, 4.255,255,255
 *  5.0xffffffff, 6.0xff,0xff,0xff,0xff, 5.255,255,255,255
 *
 *  @return
 */
+ (instancetype)colorForARGB:(NSString *)rgba;

@end
