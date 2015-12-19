//
//  SGRefreshCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGRefreshCell.h"
#import "SGResource.h"
#import <Masonry.h>

@interface SGRefreshCell ()

@property (nonatomic, strong)UIActivityIndicatorView *activityView;
@property (nonatomic, strong)UILabel *titleLabel;

@end

@implementation SGRefreshCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor colorForKey:SG_COLOR_REFRESH_CELL_BG];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

+ (CGFloat)cellHeight {
    return 30;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontForKey:SG_FONT_F];
        _titleLabel.textColor = [UIColor colorForKey:SG_FONT_F];
    }
    return _titleLabel;
}

@end
