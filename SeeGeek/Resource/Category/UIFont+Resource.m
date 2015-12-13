//
//  UIFont+Resource.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "UIFont+Resource.h"
#import "ResourceManager.h"

@implementation UIFont (Resource)

+ (instancetype)fontForKey:(NSString *)key {
    NSDictionary *fontDic = [[ResourceManager sharedInstance] fontValueForKey:key];
    CGFloat fontSize = [[fontDic objectForKey:SG_FONT_SIZE_KEY] floatValue];
    NSString *fontName = [fontDic objectForKey:SG_FONT_NAME_KEY];
    NSString *fontStyle = [fontDic objectForKey:SG_FONT_STYLE_KEY];
    UIFont *resultFont = nil;
    do
    {
        if(fontName.length > 0)
        {
            resultFont = [UIFont fontWithName:fontName size:fontSize];
            if(resultFont != nil)
            {
                break;
            }
        }
        if([fontStyle isEqualToString:SG_FONT_STYLE_BOLD])
        {
            resultFont = [UIFont boldSystemFontOfSize:fontSize];
        }
        else
        {
            resultFont = [UIFont systemFontOfSize:fontSize];
        }
    }
    while (NO);
    return resultFont;
}

@end

NSString *const SG_FONT_A = @"sg_font_a";
NSString *const SG_FONT_B = @"sg_font_b";
NSString *const SG_FONT_C = @"sg_font_c";
NSString *const SG_FONT_D = @"sg_font_d";
NSString *const SG_FONT_E = @"sg_font_e";
NSString *const SG_FONT_F = @"sg_font_f";
NSString *const SG_FONT_G = @"sg_font_g";
NSString *const SG_FONT_H = @"sg_font_h";
NSString *const SG_FONT_I = @"sg_font_i";
NSString *const SG_FONT_J = @"sg_font_j";
NSString *const SG_FONT_K = @"sg_font_k";
NSString *const SG_FONT_L = @"sg_font_l";
NSString *const SG_FONT_M = @"sg_font_m";
NSString *const SG_FONT_N = @"sg_font_n";
NSString *const SG_FONT_O = @"sg_font_o";
NSString *const SG_FONT_P = @"sg_font_p";
