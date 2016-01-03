//
//  SGShareManager.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SGShareComplete)(NSError *error);

@interface SGShareManager : NSObject

+ (void)shareWithTitle:(NSString *)title
               content:(NSString *)content
              imageUrl:(NSString *)imageUrl
           redirectUrl:(NSString *)redirectUrl
         thirdpartType:(SGThirdPartType)type
              callback:(SGShareComplete)callback;

@end
