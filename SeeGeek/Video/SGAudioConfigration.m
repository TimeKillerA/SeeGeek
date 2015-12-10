//
//  SGAudioConfigration.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGAudioConfigration.h"

@implementation SGAudioConfigration

- (instancetype)init {
    self = [super init];
    if(self) {
        self.sampleRate = 44100;
        self.channels = 2;
        self.bitPerChannel = 16;
    }
    return self;
}

- (void)setSampleRate:(NSInteger)sampleRate {
    _sampleRate = 44100;
}

- (void)setChannels:(NSInteger)channels {
    _channels = 2;
}

- (void)setBitPerChannel:(NSInteger)bitPerChannel {
    _bitPerChannel = 16;
}

@end
