//
//  UserSummaryModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SGUserSummaryModel : NSObject

/**
 *  用户ID
 */
@property (nonatomic, assign)SGIDInteger userId;

/**
 *  用户名称
 */
@property (nonatomic, copy)NSString *userName;

/**
 *  用户头像
 */
@property (nonatomic, copy)NSString *userImageUrl;

/**
 *  用户签名
 */
@property (nonatomic, copy)NSString *userSign;

@end
