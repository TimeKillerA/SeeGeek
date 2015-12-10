//
//  SGVerifyCodeViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/7.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGVerifyCodeViewModel.h"

@implementation SGVerifyCodeViewModel

- (instancetype)initWithMinInterval:(NSTimeInterval)time {
    self = [super init];
    if(self) {
        self.timeInterval = time;
    }
    return self;
}

- (RACSignal *)signalForSendCode {
    return nil;
}

@end
