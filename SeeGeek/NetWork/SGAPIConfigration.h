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

extern NSInteger const SG_ERROR_CODE_UNKNOWN;

extern NSString *const SG_API_METHOD_UPLOAD_VIDEO;