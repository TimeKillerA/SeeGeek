//
//  ResourceManager.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/1.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResourceManager : NSObject

+ (instancetype)sharedInstance;

- (NSDictionary *)fontValueForKey:(NSString *)key;
- (NSString *)colorValueForKey:(NSString *)key;
- (NSString *)imagePathForKey:(NSString *)key;

@end
