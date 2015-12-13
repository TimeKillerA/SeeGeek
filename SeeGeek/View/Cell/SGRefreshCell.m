//
//  SGRefreshCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGRefreshCell.h"

@interface SGRefreshCell ()

@property (nonatomic, strong)UIActivityIndicatorView *activityView;

@end

@implementation SGRefreshCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

+ (CGFloat)cellHeight {
    return 30;
}

@end
