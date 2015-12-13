//
//  NSString+Resource.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "NSString+Resource.h"

@implementation NSString (Resource)

+ (NSString *)stringForKey:(NSString *)key {
    return key;
}

@end


NSString *const SG_TEXT_HOME = @"首页";
NSString *const SG_TEXT_LOCATION = @"位置";
NSString *const SG_TEXT_RECORD = @"录制";
NSString *const SG_TEXT_FIND = @"发现";
NSString *const SG_TEXT_ME = @"我";