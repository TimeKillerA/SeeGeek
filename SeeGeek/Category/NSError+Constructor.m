//
//  NSError+Constructor.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "NSError+Constructor.h"

@implementation NSError (Constructor)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:message, NSLocalizedDescriptionKey, nil];
    return [NSError errorWithDomain:@"SG" code:code userInfo:userInfo];
}

@end
