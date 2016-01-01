//
//  SGAPIConfigration.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAPIConfigration : NSObject

+ (NSString *)baseURL;

@end

FOUNDATION_EXTERN NSInteger const SG_ERROR_CODE_UNKNOWN;

FOUNDATION_EXTERN NSString *const SG_API_METHOD_UPLOAD_VIDEO;

#pragma mark - stream list
FOUNDATION_EXTERN NSString *const SG_API_METHOD_FOCUS_LIST;