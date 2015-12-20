//
//  NSString+Time.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/20.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "NSString+Time.h"

static NSInteger const MINUTE = 60;
static NSInteger const HOUR = 60 * MINUTE;

@implementation NSString (Time)

+ (instancetype)HMSStringFromSeconds:(NSInteger)seconds {
    NSInteger hours = seconds / HOUR;
    NSInteger minutes = (seconds % HOUR)/MINUTE;
    NSInteger leftseconds = seconds % MINUTE;
    return [NSString stringWithFormat:@"%.2d：%.2d：%.2d", (int)hours, (int)minutes, (int)leftseconds];
}

@end
