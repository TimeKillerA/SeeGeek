//
//  UIImage+Resource.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resource)

/**
 *  首先会从xcassets中加载图片，如未找到对应图片，则尝试从bundle中加载
 *  对于常用、占用内存小的图片，应该放入xcassets中，对于不常用，较大的图片
 *  则应该放入到bundle中
 *
 *  @param key
 *
 *  @return 
 */
+ (instancetype)imageForKey:(NSString *)key;

+ (instancetype)imageWithColor:(UIColor *)color;

@end

#pragma mark - tab
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_HOME;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_HOME_SELECT;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_LOCATION;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_LOCATION_SELECT;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_RECORD;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_RECORD_SELECT;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_FIND;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_FIND_SELECT;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_ME;
FOUNDATION_EXTERN NSString *const SG_IMAGE_TAB_ME_SELECT;

#pragma mark - stream cell
FOUNDATION_EXTERN NSString *const SG_IMAGE_RED_DOT;
FOUNDATION_EXTERN NSString *const SG_IMAGE_LIVE_SLIDE_BG;
FOUNDATION_EXTERN NSString *const SG_IMAGE_LIKE;
FOUNDATION_EXTERN NSString *const SG_IMAGE_COMMENT;
FOUNDATION_EXTERN NSString *const SG_IMAGE_CLIP_SLIDE_BG;
FOUNDATION_EXTERN NSString *const SG_IMAGE_CLIP_DURATION_BG;
FOUNDATION_EXTERN NSString *const SG_IMAGE_STREAM_EMPTY_LOGO;
FOUNDATION_EXTERN NSString *const SG_IMAGE_WHITE_PLAY;
FOUNDATION_EXTERN NSString *const SG_IMAGE_LOCATION;
FOUNDATION_EXTERN NSString *const SG_IMAGE_EXPAND;
FOUNDATION_EXTERN NSString *const SG_IMAGE_UNEXPAND;

#pragma mark - location
FOUNDATION_EXTERN NSString *const SG_IMAGE_ANNOTATION_CLIP;
FOUNDATION_EXTERN NSString *const SG_IMAGE_ANNOTATION_LIVE;
FOUNDATION_EXTERN NSString *const SG_IMAGE_SEARCH;




