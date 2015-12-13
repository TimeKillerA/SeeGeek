//
//  SGStreamSummaryCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGStreamSummaryModel.h"

@interface SGStreamSummaryCell : UITableViewCell

@property (nonatomic, strong)SGStreamSummaryModel *summaryModel;

+ (CGFloat)cellHeight;

@end
