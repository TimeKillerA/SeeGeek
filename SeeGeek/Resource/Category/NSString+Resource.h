//
//  NSString+Resource.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  主要用来返回工程中的文本资源，采用调用方法的形式来获取文本，方便以后做国际化的时候能直接进行扩展
 */
@interface NSString (Resource)

/**
 *  根据key来返回文本数据，目前只是直接将key返回
 *
 *  @param key
 *
 *  @return
 */
+ (NSString *)stringForKey:(NSString *)key;

@end

FOUNDATION_EXTERN NSString *const SG_TEXT_HOME;
FOUNDATION_EXTERN NSString *const SG_TEXT_LOCATION;
FOUNDATION_EXTERN NSString *const SG_TEXT_RECORD;
FOUNDATION_EXTERN NSString *const SG_TEXT_FIND;
FOUNDATION_EXTERN NSString *const SG_TEXT_ME;
FOUNDATION_EXTERN NSString *const SG_TEXT_LIVE_EN;
FOUNDATION_EXTERN NSString *const SG_TEXT_PLAYBACK;
FOUNDATION_EXTERN NSString *const SG_TEXT_EXPAND;
FOUNDATION_EXTERN NSString *const SG_TEXT_UNEXPAND;
FOUNDATION_EXTERN NSString *const SG_TEXT_EXCHANGE;
FOUNDATION_EXTERN NSString *const SG_TEXT_NO_NEW_CONTENT;
FOUNDATION_EXTERN NSString *const SG_TEXT_FOCUS_LOCATION;




