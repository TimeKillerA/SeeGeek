//
//  SGAPIConfigration.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGAPIConfigration.h"

NSString *const BASE_URL_FOR_TEST = @"http://124.126.126.19:8081/seegeek/rest/item";

@implementation SGAPIConfigration

+ (NSString *)baseURL {
    return BASE_URL_FOR_TEST;
}

@end

NSInteger const SG_ERROR_CODE_UNKNOWN = -1;

NSString *const SG_API_METHOD_UPLOAD_VIDEO = @"uploadVideo";