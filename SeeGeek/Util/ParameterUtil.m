//
//  ParameterUtil.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "ParameterUtil.h"

@implementation ParameterUtil

#pragma mark - device
+ (NSString *)deviceOS {
    return @"iOS";
}

+ (NSString *)deviceOSVersion {
    return nil;
}

+ (NSString *)deviceLanguage {
    return nil;
}

+ (NSString *)deviceName {
    return nil;
}

+ (NSString *)deviceIDFA {
    return nil;
}

+ (NSString *)deviceToken {
    return nil;
}

+ (NSString *)deviceModel {
    return nil;
}

+ (NSString *)deviceUUID {
    return nil;
}

+ (void)saveDeviceUUID:(NSString *)uuid {
    
}

#pragma mark - app
+ (NSString *)appVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - user
+ (NSString *)userToken {
    return nil;
}

+ (NSString *)userAccount {
    return nil;
}

#pragma mark - location
+ (double)longitude {
    return 0;
}

+ (double)lantitude {
    return 0;
}

@end
