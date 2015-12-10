//
//  SGVideoConfigration.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGVideoConfigration.h"

@implementation SGVideoConfigration

- (instancetype)init {
    self = [super init];
    if(self) {
        self.presetType = SGVideoPresetType352X288;
        self.frameRate = 25;
        self.keyFrameInterval = 2;
        self.bitRate = 400 * 1000;
    }
    return self;
}

- (void)setPresetType:(SGVideoPresetType)presetType {
    _presetType = presetType;
    switch (presetType) {
        case SGVideoPresetType352X288:
            _width = 352;
            _height = 288;
            break;
        case SGVideoPresetType640X480:
            _width = 640;
            _height = 480;
        default:
            break;
    }
}

@end
