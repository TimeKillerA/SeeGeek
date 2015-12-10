//
//  SGStreamConfigration.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGStreamConfigration : NSObject

@property (nonatomic, copy)NSString *host;
@property (nonatomic, copy)NSString *sourceName;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *securityToken;

- (instancetype)initWithHost:(NSString *)host
                      source:(NSString *)sourceName
                       title:(NSString *)title;

- (NSString *)streamUrl;

@end
