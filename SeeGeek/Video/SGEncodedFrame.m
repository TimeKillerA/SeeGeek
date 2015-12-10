//
//  SGEncodedFrame.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGEncodedFrame.h"

@implementation SGEncodedFrame

+ (instancetype)frameWithData:(NSData *)data type:(SGEncodedFrameType)type {
    SGEncodedFrame *frame = [[SGEncodedFrame alloc] init];
    if(frame) {
        frame.data = data;
        frame.type = type;
    }
    return frame;
}



@end
