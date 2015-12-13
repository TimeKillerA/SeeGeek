//
//  SGRefreshCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SGRefreshCellBlock)();

@interface SGRefreshCell : UITableViewCell

@property (nonatomic, copy)NSString *title;
@property (nonatomic, assign)BOOL refreshing;

+ (CGFloat)cellHeight;

@end
