//
//  ParameterUtil.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParameterUtil : NSObject

#pragma mark - device
+ (NSString *)deviceOS;
+ (NSString *)deviceOSVersion;
+ (NSString *)deviceLanguage;
+ (NSString *)deviceName;
+ (NSString *)deviceIDFA;
+ (NSString *)deviceToken;
+ (NSString *)deviceModel;
+ (NSString *)deviceUUID;
+ (void)saveDeviceUUID:(NSString *)uuid;

#pragma mark - app
+ (NSString *)appVersion;

#pragma mark - user
+ (NSString *)userToken;
+ (NSString *)userAccount;

#pragma mark - location
+ (double)longitude;
+ (double)lantitude;

@end
