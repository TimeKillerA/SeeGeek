//
//  SGFocusCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGFocusCell.h"
#import "SGResource.h"
#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "UIImageView+URL.h"

static CGFloat const IMAGE_WIDTH = 54;
static CGFloat const BUTTON_WIDTH = 60;
static CGFloat const BUTTON_HEIGHT = 20;

@interface SGFocusCell ()

@property (nonatomic, strong)UIImageView *snapImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UILabel *contentLabel;
@property (nonatomic, strong)UIButton *focusButton;
@property (nonatomic, strong)UIButton *moreActionButton;

@end

@implementation SGFocusCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addSubview:self.snapImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.focusButton];
        [self addSubview:self.moreActionButton];
        [self updateConstraints];
        [self setupListeners];
    }
    return self;
}

#pragma mark - setup
- (void)updateConstraints {
    [super updateConstraints];
    [self.snapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).offset(3);
        make.width.height.mas_equalTo(IMAGE_WIDTH);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.snapImageView.mas_right).offset(5);
        make.top.mas_equalTo(self.snapImageView);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(self).offset(-17);
    }];
}

- (void)setFocusItem:(SGFocusCellItem *)focusItem {
    _focusItem = focusItem;
    [self.snapImageView showImageWithURL:focusItem.imageUrl section:NSStringFromClass([self class]) defaultImage:nil];
    self.titleLabel.text = focusItem.title;
    self.contentLabel.text = focusItem.content;
    if(focusItem.focus) {
        [self.focusButton setTitle:[NSString stringForKey:SG_TEXT_FOCUSED] forState:UIControlStateNormal];
//        [self.focusButton setImage:[UIImage imageForKey:SG_IMAGE_WHITE_SELECT] forState:UIControlStateNormal];
    } else {
        [self.focusButton setTitle:[NSString stringWithFormat:@"+  %@",[NSString stringForKey:SG_TEXT_FOCUS]] forState:UIControlStateNormal];
        [self.focusButton setImage:nil forState:UIControlStateNormal];
    }
    if(focusItem.showMoreAction) {
        self.moreActionButton.hidden = NO;
        [self.moreActionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-12);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(BUTTON_WIDTH);
            make.height.mas_equalTo(BUTTON_HEIGHT);
        }];
        [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.moreActionButton.mas_left).offset(-5);
            make.centerY.width.height.mas_equalTo(self.moreActionButton);
        }];
    } else {
        self.moreActionButton.hidden = YES;
        [self.focusButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-12);
            make.centerY.mas_equalTo(self);
            make.width.mas_equalTo(BUTTON_WIDTH);
            make.height.mas_equalTo(BUTTON_HEIGHT);
        }];
    }
}

- (void)setupListeners {
    WS(weakSelf);
    [[self.focusButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([weakSelf.delegate respondsToSelector:@selector(didClickFocusButtonInFocusCell:)]) {
            [weakSelf.delegate didClickFocusButtonInFocusCell:weakSelf];
        }
    }];
    [[self.moreActionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([weakSelf.delegate respondsToSelector:@selector(didClickMoreActionButtonInFocusCell:)]) {
            [weakSelf.delegate didClickMoreActionButtonInFocusCell:weakSelf];
        }
    }];
}

#pragma mark - accessory
- (UIImageView *)snapImageView {
    if(!_snapImageView) {
        _snapImageView = [[UIImageView alloc] init];
    }
    return _snapImageView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorForFontKey:SG_FONT_I];
        _titleLabel.font = [UIFont fontForKey:SG_FONT_I];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if(!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorForFontKey:SG_FONT_N];
        _contentLabel.font = [UIFont fontForKey:SG_FONT_N];
    }
    return _contentLabel;
}

- (UIButton *)focusButton {
    if(!_focusButton) {
        _focusButton = [[UIButton alloc] init];
        _focusButton.backgroundColor = [UIColor colorForKey:SG_COLOR_BLUE_BUTTON_BG];
        _focusButton.layer.cornerRadius = 5;
        _focusButton.titleLabel.font = [UIFont fontForKey:SG_FONT_C];
        [_focusButton setTitleColor:[UIColor colorForFontKey:SG_FONT_C] forState:UIControlStateNormal];
    }
    return _focusButton;
}

- (UIButton *)moreActionButton {
    if(!_moreActionButton) {
        _moreActionButton = [[UIButton alloc] init];
        _moreActionButton.backgroundColor = [UIColor colorForKey:SG_COLOR_BLUE_BUTTON_BG];
        _moreActionButton.layer.cornerRadius = 5;
        _moreActionButton.titleLabel.font = [UIFont fontForKey:SG_FONT_C];
        [_moreActionButton setTitleColor:[UIColor colorForFontKey:SG_FONT_C] forState:UIControlStateNormal];
        [_moreActionButton setTitle:[NSString stringForKey:SG_TEXT_MORE] forState:UIControlStateNormal];
    }
    return _moreActionButton;
}

@end

@implementation SGFocusCellItem

@end