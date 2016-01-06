//
//  SGMapLocationCell.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/6.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SGMapLocationCell : UITableViewCell

- (void)updateWithTitle:(NSString *)title content:(NSString *)content index:(NSInteger)index;

+ (CGFloat)cellHeight;

@end
