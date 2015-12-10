//
//  NSError+Constructor.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (Constructor)

+ (instancetype)errorWithCode:(NSInteger)code message:(NSString *)message;

@end
