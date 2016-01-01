//
//  SGStreamShareView.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGStreamShareView.h"
#import <Masonry.h>
#import "SGUserSummaryModel.h"
#import "SGResource.h"
#import <SZTextView.h>
#import <TKRoundedView.h>

@interface SGStreamShareView ()

@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)SZTextView *textView;
@property (nonatomic, strong)TKRoundedView *summaryView;
@property (nonatomic, strong)UIImageView *snapImageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *tagLabel;
@property (nonatomic, strong)UILabel *snapTitleLabel;
@property (nonatomic, strong)UIButton *locationButton;
@property (nonatomic, strong)TKRoundedView *shareTypeView;
@property (nonatomic, strong)UIButton *sinaButton;
@property (nonatomic, strong)UIButton *qqButton;
@property (nonatomic, strong)UIButton *qzoneButton;
@property (nonatomic, strong)UIButton *wechatMessageButton;
@property (nonatomic, strong)UIButton *wechatTimeLineButton;
@property (nonatomic, strong)UIButton *streamCopyButton;

@end

@implementation SGStreamShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.titleLabel];
        [self.containerView addSubview:self.textView];
        [self.containerView addSubview:self.summaryView];
        [self.summaryView addSubview:self.snapImageView];
        [self.summaryView addSubview:self.snapTitleLabel];
        [self.summaryView addSubview:self.nameLabel];
        [self.summaryView addSubview:self.tagLabel];
        [self.summaryView addSubview:self.locationButton];
        [self.containerView addSubview:self.shareTypeView];
        [self.shareTypeView addSubview:self.sinaButton];
        [self.shareTypeView addSubview:self.qqButton];
        [self.shareTypeView addSubview:self.qzoneButton];
        [self.shareTypeView addSubview:self.wechatMessageButton];
        [self.shareTypeView addSubview:self.wechatTimeLineButton];
        [self.shareTypeView addSubview:self.streamCopyButton];
        [self updateConstraints];
    }
    return self;
}

#pragma mark - setup
- (void)updateConstraints {
    [super updateConstraints];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - accessory
- (UIView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
    }
    return _backgroundView;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = [NSString stringForKey:SG_TEXT_SHARE];
        _titleLabel.textColor = [UIColor colorForFontKey:SG_FONT_H];
        _titleLabel.font = [UIFont fontForKey:SG_FONT_H];
        _titleLabel.backgroundColor = [UIColor colorForKey:SG_COLOR_SHARE_TITLE_BG];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (SZTextView *)textView {
    if(!_textView) {
        _textView = [[SZTextView alloc] init];
        _textView.font = [UIFont fontForKey:SG_FONT_J];
        _textView.textColor = [UIColor colorForFontKey:SG_FONT_J];
        _textView.placeholder = [NSString stringForKey:SG_TEXT_SHARE_PLACEHOLDER];
    }
    return _textView;
}

- (TKRoundedView *)summaryView {
    if(!_summaryView) {
        _summaryView = [[TKRoundedView alloc] init];
        _summaryView.drawnBordersSides = TKDrawnBorderSidesTop | TKDrawnBorderSidesBottom;
        _summaryView.roundedCorners = TKRoundedCornerNone;
        _summaryView.borderColor = [UIColor lineColor];
        _summaryView.borderWidth = 1/[UIScreen mainScreen].scale;
        _summaryView.fillColor = [UIColor whiteColor];
    }
    return _summaryView;
}

- (UIImageView *)snapImageView {
    if(!_snapImageView) {
        _snapImageView = [[UIImageView alloc] init];
    }
    return _snapImageView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont fontForKey:SG_FONT_I];
        _nameLabel.textColor = [UIColor colorForFontKey:SG_FONT_I];
    }
    return _nameLabel;
}

- (UILabel *)tagLabel {
    if(!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont fontForKey:SG_FONT_O];
        _tagLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
    }
    return _tagLabel;
}

- (UILabel *)snapTitleLabel {
    if(!_snapTitleLabel) {
        _snapTitleLabel = [[UILabel alloc] init];
        _snapTitleLabel.font = [UIFont fontForKey:SG_FONT_O];
        _snapTitleLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
    }
    return _snapTitleLabel;
}

- (UIButton *)locationButton {
    if(!_locationButton) {
        _locationButton = [[UIButton alloc] init];
        _locationButton.titleLabel.font = [UIFont fontForKey:SG_FONT_K];
        [_locationButton setTitleColor:[UIColor colorForFontKey:SG_FONT_K] forState:UIControlStateNormal];
        [_locationButton setImage:[UIImage imageForKey:SG_IMAGE_LOCATION] forState:UIControlStateNormal];
        [_locationButton setTitle:[NSString stringForKey:SG_TEXT_LOCATION] forState:UIControlStateNormal];
        _locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _locationButton.enabled = NO;
        _locationButton.adjustsImageWhenDisabled = NO;
    }
    return _locationButton;
}

- (TKRoundedView *)shareTypeView {
    if(!_shareTypeView) {
        _shareTypeView = [[TKRoundedView alloc] init];
        _shareTypeView.drawnBordersSides = TKDrawnBorderSidesTop | TKDrawnBorderSidesBottom;
        _shareTypeView.roundedCorners = TKRoundedCornerNone;
        _shareTypeView.borderColor = [UIColor lineColor];
        _shareTypeView.borderWidth = 1/[UIScreen mainScreen].scale;
        _shareTypeView.fillColor = [UIColor whiteColor];
    }
    return _shareTypeView;
}

- (UIButton *)sinaButton {
    if(!_sinaButton) {
        _sinaButton = [[UIButton alloc ] init];
        [_sinaButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_SINA] forState:UIControlStateNormal];
    }
    return _sinaButton;
}

- (UIButton *)qqButton {
    if(!_qqButton) {
        _qqButton = [[UIButton alloc] init];
        [_qqButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_QQ] forState:UIControlStateNormal];
    }
    return _qqButton;
}

- (UIButton *)qzoneButton {
    if(!_qzoneButton) {
        _qzoneButton = [[UIButton alloc] init];
        [_qzoneButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_QZONE] forState:UIControlStateNormal];
    }
    return _qzoneButton;
}

- (UIButton *)wechatMessageButton {
    if(!_wechatMessageButton) {
        _wechatMessageButton = [[UIButton alloc] init];
        [_wechatMessageButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_WECHAT] forState:UIControlStateNormal];
    }
    return _wechatMessageButton;
}

- (UIButton *)wechatTimeLineButton {
    if(!_wechatTimeLineButton) {
        _wechatTimeLineButton = [[UIButton alloc] init];
        [_wechatTimeLineButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_WECHAT_TIMELINE] forState:UIControlStateNormal];
    }
    return _wechatTimeLineButton;
}

- (UIButton *)streamCopyButton {
    if(!_streamCopyButton) {
        _streamCopyButton = [[UIButton alloc] init];
        [_streamCopyButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_COPY] forState:UIControlStateNormal];
    }
    return _streamCopyButton;
}


@end
