//
//  UIColor+Resource.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "UIColor+Resource.h"
#import "ResourceManager.h"

@implementation UIColor (Resource)

+ (instancetype)colorForKey:(NSString *)key {
    NSString *value = [[ResourceManager sharedInstance] colorValueForKey:key];
    return [UIColor colorForARGB:value];
}

+ (instancetype)colorForFontKey:(NSString *)key {
    NSDictionary *fontDictionary = [[ResourceManager sharedInstance] fontValueForKey:key];
    NSString *fontColorValue = [fontDictionary objectForKey:SG_FONT_COLOR_KEY];
    return [UIColor colorForARGB:fontColorValue];
}

+ (instancetype)colorForARGB:(NSString *)argb {
    UIColor *resultColor = [UIColor clearColor];
    NSString *a, *r, *g, *b;
    unsigned int valueA, valueR, valueG, valueB;
    do {
        if(argb.length == 0) {
            break;
        }
        if([argb hasPrefix:@"#"]) {
            NSString *sub = [argb substringFromIndex:1];
            if(sub.length == 3) {
                a = @"ff";
                r = [sub substringWithRange:NSMakeRange(0, 1)];
                g = [sub substringWithRange:NSMakeRange(1, 1)];
                b = [sub substringWithRange:NSMakeRange(2, 1)];
                r = [NSString stringWithFormat:@"%@%@", r, r];
                g = [NSString stringWithFormat:@"%@%@", g, g];
                b = [NSString stringWithFormat:@"%@%@", b, b];
            } else if(sub.length == 4) {
                a = [sub substringWithRange:NSMakeRange(0, 1)];
                r = [sub substringWithRange:NSMakeRange(1, 1)];
                g = [sub substringWithRange:NSMakeRange(2, 1)];
                b = [sub substringWithRange:NSMakeRange(3, 1)];
                a = [NSString stringWithFormat:@"%@%@", a, a];
                r = [NSString stringWithFormat:@"%@%@", r, r];
                g = [NSString stringWithFormat:@"%@%@", g, g];
                b = [NSString stringWithFormat:@"%@%@", b, b];
            } else if(sub.length == 6) {
                a = @"ff";
                r = [sub substringWithRange:NSMakeRange(0, 2)];
                g = [sub substringWithRange:NSMakeRange(2, 2)];
                b = [sub substringWithRange:NSMakeRange(4, 2)];
            } else if(sub.length == 8) {
                a = [sub substringWithRange:NSMakeRange(0, 2)];
                r = [sub substringWithRange:NSMakeRange(2, 2)];
                g = [sub substringWithRange:NSMakeRange(4, 2)];
                b = [sub substringWithRange:NSMakeRange(6, 2)];
            }
            [[NSScanner scannerWithString:a] scanHexInt:&valueA];
            [[NSScanner scannerWithString:r] scanHexInt:&valueR];
            [[NSScanner scannerWithString:g] scanHexInt:&valueG];
            [[NSScanner scannerWithString:b] scanHexInt:&valueB];
        } else {
            NSArray *array = [argb componentsSeparatedByString:@","];
            if([array count] == 3) {
                a = @"255";
                r = [array objectAtIndex:0];
                g = [array objectAtIndex:1];
                b = [array objectAtIndex:2];
            } else if([array count] == 4) {
                a = [array objectAtIndex:0];
                r = [array objectAtIndex:1];
                g = [array objectAtIndex:2];
                b = [array objectAtIndex:3];
            }
            valueA = [a intValue];
            valueR = [r intValue];
            valueG = [g intValue];
            valueB = [b intValue];
        }
        resultColor = [UIColor colorWithRed:valueR/255.0 green:valueG/255.0 blue:valueB/255.0 alpha:valueA/255.0];
    } while (NO);
    return resultColor;
}

@end

NSString *const SG_COLOR_WHITE      = @"white";
NSString *const SG_COLOR_BLACK      = @"black";
NSString *const SG_COLOR_NAVIGATION = @"navigation";
NSString *const SG_COLOR_TAB        = @"tab";
NSString *const SG_COLOR_TAB_SELECT = @"tab_select";
NSString *const SG_COLOR_REFRESH_CELL_BG = @"refresh_cell_bg";
NSString *const SG_COLOR_NORMAL_GRAY_BG = @"normal_gray_bg";




