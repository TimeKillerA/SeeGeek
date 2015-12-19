//
//  LocationManager.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/19.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "LocationManager.h"

static NSString *const MAMAP_API_KEY = @"983caf9b84f471bf5d30eb48b0306bb4";

@implementation LocationManager

+ (void)load {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MAMapServices sharedServices].apiKey = MAMAP_API_KEY;
        [MAMapServices sharedServices].crashReportEnabled = NO;
    });
}

@end
