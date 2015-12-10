//
//  SGStreamConfigration.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGStreamConfigration.h"

@implementation SGStreamConfigration

- (instancetype)initWithHost:(NSString *)host
                      source:(NSString *)sourceName
                       title:(NSString *)title {
    self = [super init];
    if(self) {
        self.host = host;
        self.sourceName = sourceName;
        self.title = title;
    }
    return self;
}

- (NSString *)streamUrl {
    return [NSString stringWithFormat:@"%@/%@/%@", self.host, self.sourceName, self.title];
}

@end
