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

#pragma mark - tab
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

#pragma mark - stream cell
NSString *const SG_IMAGE_RED_DOT = @"icon_red_dot";
NSString *const SG_IMAGE_LIVE_SLIDE_BG = @"icon_live_stream_slide_bg";
NSString *const SG_IMAGE_LIKE = @"icon_like_bg";
NSString *const SG_IMAGE_COMMENT = @"icon_comment_bg";
NSString *const SG_IMAGE_CLIP_SLIDE_BG = @"icon_clip_slide_bg";
NSString *const SG_IMAGE_CLIP_DURATION_BG = @"icon_clip_duration_bg";
NSString *const SG_IMAGE_STREAM_EMPTY_LOGO = @"icon_stream_snap_empty";
NSString *const SG_IMAGE_WHITE_PLAY = @"icon_white_play";
NSString *const SG_IMAGE_LOCATION = @"icon_location";
NSString *const SG_IMAGE_EXPAND = @"icon_expand";
NSString *const SG_IMAGE_UNEXPAND = @"icon_unexpand";
NSString *const SG_IMAGE_ANNOTATION_CLIP = @"annotation_clip_bg";
NSString *const SG_IMAGE_ANNOTATION_LIVE = @"annotation_live_bg";
NSString *const SG_IMAGE_SEARCH = @"icon_search";

#pragma mark - personnal
NSString *const SG_IMAGE_COLLECTION_STYLE = @"icon_grid_style";
NSString *const SG_IMAGE_COLLECTION_STYLE_HIGHLIGHT = @"icon_grid_style_highlight";
NSString *const SG_IMAGE_TABLE_STYLE = @"icon_table_style";
NSString *const SG_IMAGE_TABLE_STYLE_HIGHLIGHT = @"icon_table_style_highlight";
NSString *const SG_IMAGE_SETTINGS = @"icon_settings";
NSString *const SG_IMAGE_FIELD_NEXT = @"icon_field_next";










