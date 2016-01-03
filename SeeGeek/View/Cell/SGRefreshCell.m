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

@property (nonatomic, strong)UIButton *button;

@end

@implementation SGRefreshCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addSubview:self.button];
        self.backgroundColor = [UIColor colorForKey:SG_COLOR_REFRESH_CELL_BG];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
}

+ (CGFloat)cellHeight {
    return 30;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.button setTitle:title forState:UIControlStateNormal];
}

- (UIButton *)button {
    if(!_button) {
        _button = [[UIButton alloc] init];
        _button.enabled = NO;
        _button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 7);
        _button.titleEdgeInsets = UIEdgeInsetsMake(0, 7, 0, 0);
    }
    return _button;
}

- (void)setHasMore:(BOOL)hasMore {
    _hasMore = hasMore;
    if(hasMore) {
        self.button.titleLabel.font = [UIFont fontForKey:SG_FONT_I];
        [self.button setTitleColor:[UIColor colorForFontKey:SG_FONT_I] forState:UIControlStateNormal];
        [self.button setTitle:self.title?self.title:[NSString stringForKey:SG_TEXT_EXCHANGE] forState:UIControlStateNormal];
        [self.button setImage:[UIImage imageForKey:SG_IMAGE_EXCHANGE] forState:UIControlStateNormal];
    } else {
        self.button.titleLabel.font = [UIFont fontForKey:SG_FONT_N];
        [self.button setTitleColor:[UIColor colorForFontKey:SG_FONT_N] forState:UIControlStateNormal];
        [self.button setTitle:self.title?self.title:[NSString stringForKey:SG_TEXT_NO_NEW_CONTENT] forState:UIControlStateNormal];
        [self.button setImage:nil forState:UIControlStateNormal];
    }
}

@end
