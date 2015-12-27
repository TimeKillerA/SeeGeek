//
//  SGCommentModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGUserSummaryModel.h"

@interface SGCommentModel : NSObject

/**
 *  评论ID
 */
@property (nonatomic, assign)SGIDInteger commentId;

/**
 *  发起者
 */
@property (nonatomic, strong)SGUserSummaryModel *fromUser;

/**
 *  接收者，为空时表示直接评论，否则表示回复对应的用户
 */
@property (nonatomic, strong)SGUserSummaryModel *toUser;

/**
 *  评论内容
 */
@property (nonatomic, copy)NSString *content;

/**
 *  顺序号
 */
@property (nonatomic, assign)SGIDInteger sequenceNumber;

/**
 *  序号
 */
@property (nonatomic, assign)SGIDInteger sortNumber;

@end
