//
//  SGStreamSummaryWithCommentCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGStreamSummaryWithCommentModel;

@interface SGStreamSummaryWithCommentCell : UICollectionViewCell

@property (nonatomic, strong)SGStreamSummaryWithCommentModel *model;

+ (CGFloat)cellHeightWithModel:(SGStreamSummaryWithCommentModel *)model;

@end
