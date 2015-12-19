//
//  SGStreamSummaryLittleSnapCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/19.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SGStreamSummaryModel;

@interface SGStreamSummaryLittleSnapCell : UITableViewCell

@property (nonatomic, strong)SGStreamSummaryModel *summaryModel;

+ (CGFloat)cellHeight;

@end
