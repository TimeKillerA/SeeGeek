//
//  ResourceManager.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject

+ (instancetype)sharedInstance;

- (NSDictionary *)fontValueForKey:(NSString *)key;
- (NSString *)colorValueForKey:(NSString *)key;
- (NSString *)imagePathForKey:(NSString *)key;

@end

FOUNDATION_EXTERN NSString *const SG_FONT_SIZE_KEY;
FOUNDATION_EXTERN NSString *const SG_FONT_NAME_KEY;
FOUNDATION_EXTERN NSString *const SG_FONT_STYLE_KEY;
FOUNDATION_EXTERN NSString *const SG_FONT_COLOR_KEY;
FOUNDATION_EXTERN NSString *const SG_COLOR_KEY;

FOUNDATION_EXTERN NSString *const SG_FONT_STYLE_BOLD;
