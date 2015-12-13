//
//  UIImage+Resource.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "UIImage+Resource.h"
#import "ResourceManager.h"

@implementation UIImage (Resource)

+ (instancetype)imageForKey:(NSString *)key {
    UIImage *image = [UIImage imageNamed:key];
    if(!image) {
        NSString *path = [[ResourceManager sharedInstance] imagePathForKey:key];
        image = [UIImage imageWithContentsOfFile:path];
    }
    return image;
}

+ (instancetype)imageWithColor:(UIColor *)color {
    CGSize imageSize = CGSizeMake(1, 1);
    UIGraphicsBeginImageContextWithOptions(imageSize, 0, [UIScreen mainScreen].scale);
    [color set];
    UIRectFill(CGRectMake(0, 0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pressedColorImg;
}

@end

NSString *const SG_IMAGE_TAB_HOME = @"tab_home";
NSString *const SG_IMAGE_TAB_HOME_SELECT = @"tab_home_select";
NSString *const SG_IMAGE_TAB_LOCATION = @"tab_location";
NSString *const SG_IMAGE_TAB_LOCATION_SELECT = @"tab_location_select";
NSString *const SG_IMAGE_TAB_RECORD = @"tab_record";
NSString *const SG_IMAGE_TAB_RECORD_SELECT = @"tab_record";
NSString *const SG_IMAGE_TAB_FIND = @"tab_find";
NSString *const SG_IMAGE_TAB_FIND_SELECT = @"tab_find_select";
NSString *const SG_IMAGE_TAB_ME = @"tab_me";
NSString *const SG_IMAGE_TAB_ME_SELECT = @"tab_me_select";