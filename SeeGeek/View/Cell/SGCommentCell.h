//
//  SGCommentCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGCommentModel;
@class SGCommentCell;
@class SGUserSummaryModel;

@protocol SGCommentCellDelegate <NSObject>

@optional
- (void)commentCell:(SGCommentCell *)cell didClickUser:(SGUserSummaryModel *)user;
- (void)commentCell:(SGCommentCell *)cell didClickComment:(SGCommentModel *)comment;

@end

@interface SGCommentCell : UITableViewCell

@property (nonatomic, weak)id<SGCommentCellDelegate> delegate;

@property (nonatomic, strong)SGCommentModel *model;

@end
