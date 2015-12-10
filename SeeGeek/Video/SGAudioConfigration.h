//
//  SGAudioConfigration.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/2.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGAudioConfigration : NSObject

/**
 *  采样率，默认44100，暂不提供修改
 */
@property (nonatomic, assign)NSInteger sampleRate;

/**
 *  声道，双声道，暂不提供修改
 */
@property (nonatomic, assign)NSInteger channels;

/**
 *  16位，暂不提供修改
 */
@property (nonatomic, assign)NSInteger bitPerChannel;

@end
