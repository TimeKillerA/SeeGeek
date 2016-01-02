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
#import <ReactiveCocoa.h>

static CGFloat const TITLE_AREA_HEIGHT = 45;
static CGFloat const SHARE_AREA_HEIGHT = 60;
static CGFloat const TEXT_AREA_HEIGHT = 40;
static CGFloat const SUMMARY_AREA_HEIGHT = 101;

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

- (void)dealloc {

}

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
        [self setupListeners];
    }
    return self;
}

#pragma mark - public method
- (void)showInView:(UIView *)view {
    [view addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(view);
    }];
}

- (void)dismiss {
    [self removeFromSuperview];
}

#pragma mark - setup
- (void)updateConstraints {
    [super updateConstraints];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.backgroundView);
        make.bottom.mas_equalTo(self.backgroundView);
        make.height.mas_equalTo(TITLE_AREA_HEIGHT + SHARE_AREA_HEIGHT + TEXT_AREA_HEIGHT + SUMMARY_AREA_HEIGHT);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(TITLE_AREA_HEIGHT);
    }];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(TEXT_AREA_HEIGHT);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
    }];
    [self.summaryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom);
        make.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(SUMMARY_AREA_HEIGHT);
    }];
    [self.shareTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.summaryView.mas_bottom);
        make.height.mas_equalTo(SHARE_AREA_HEIGHT);
    }];
    [self.snapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.summaryView);
        make.width.height.mas_equalTo(80);
        make.left.mas_equalTo(self.summaryView).offset(12);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.snapImageView.mas_right).offset(10);
        make.top.mas_equalTo(self.snapImageView);
    }];
    [self.snapTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(4);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.top.mas_equalTo(self.snapTitleLabel.mas_bottom).offset(4);
    }];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel);
        make.bottom.mas_equalTo(self.summaryView).offset(-15);
    }];
    [self.sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.shareTypeView);
        make.top.bottom.mas_equalTo(self.shareTypeView);
        make.width.mas_equalTo(self.shareTypeView).multipliedBy(1.0/6.0);
    }];
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sinaButton.mas_right);
        make.top.bottom.mas_equalTo(self.shareTypeView);
        make.width.mas_equalTo(self.shareTypeView).multipliedBy(1.0/6.0);
    }];
    [self.qzoneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.qqButton.mas_right);
        make.top.bottom.mas_equalTo(self.shareTypeView);
        make.width.mas_equalTo(self.shareTypeView).multipliedBy(1.0/6.0);
    }];
    [self.wechatMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.qzoneButton.mas_right);
        make.top.bottom.mas_equalTo(self.shareTypeView);
        make.width.mas_equalTo(self.shareTypeView).multipliedBy(1.0/6.0);
    }];
    [self.wechatTimeLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wechatMessageButton.mas_right);
        make.top.bottom.mas_equalTo(self.shareTypeView);
        make.width.mas_equalTo(self.shareTypeView).multipliedBy(1.0/6.0);
    }];
    [self.streamCopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.wechatTimeLineButton.mas_right);
        make.top.bottom.mas_equalTo(self.shareTypeView);
        make.width.mas_equalTo(self.shareTypeView).multipliedBy(1.0/6.0);
    }];
}

- (void)setupListeners {
    WS(weakSelf);
    [[self.sinaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf notifyShareType:SGThirdPartTypeShareSina];
    }];
    [[self.qqButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf notifyShareType:SGThirdPartTypeShareQQMessage];
    }];
    [[self.qzoneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf notifyShareType:SGThirdPartTypeShareQZone];
    }];
    [[self.wechatMessageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf notifyShareType:SGThirdPartTypeShareWechatMessage];
    }];
    [[self.wechatTimeLineButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf notifyShareType:SGThirdPartTypeShareWechatTimeline];
    }];
    [[self.streamCopyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf notifyShareType:SGThirdPartTypeShareCopy];
    }];
}

#pragma mark - event response
- (void)notifyShareType:(SGThirdPartType)type {
    if([self.delegate respondsToSelector:@selector(streamShareView:didShareWithShareType:message:)]) {
        [self.delegate streamShareView:self didShareWithShareType:type message:self.textView.text];
    }
    [self dismiss];
}

#pragma mark - accessory
- (UIView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[UIView alloc] init];
        _backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        _backgroundView.userInteractionEnabled = YES;
        [_backgroundView addGestureRecognizer:tap];
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
        _textView.autocorrectionType = UITextAutocorrectionTypeNo;
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textView.spellCheckingType = UITextSpellCheckingTypeNo;
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
        _shareTypeView.drawnBordersSides = TKDrawnBorderSidesNone;
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
        UIImage *image = [UIImage imageForKey:SG_IMAGE_SHARE_SINA];
        NSString *title = [NSString stringForKey:SG_TEXT_WEIBO];
        _sinaButton.titleLabel.font = [UIFont fontForKey:SG_FONT_N];
        [_sinaButton setTitleColor:[UIColor colorForFontKey:SG_FONT_N] forState:UIControlStateNormal];
        [_sinaButton setImage:image forState:UIControlStateNormal];
        [_sinaButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_SINA_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_sinaButton setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontForKey:SG_FONT_N]}];
        _sinaButton.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -image.size.width, 0, 0);
        _sinaButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 10), titleSize.width/2, 0, 0);
    }
    return _sinaButton;
}

- (UIButton *)qqButton {
    if(!_qqButton) {
        _qqButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageForKey:SG_IMAGE_SHARE_QQ];
        NSString *title = [NSString stringForKey:SG_TEXT_QQ];
        _qqButton.titleLabel.font = [UIFont fontForKey:SG_FONT_N];
        [_qqButton setTitleColor:[UIColor colorForFontKey:SG_FONT_N] forState:UIControlStateNormal];
        [_qqButton setImage:image forState:UIControlStateNormal];
        [_qqButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_QQ_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_qqButton setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontForKey:SG_FONT_N]}];
        _qqButton.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -image.size.width, 0, 0);
        _qqButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 10), titleSize.width/2, 0, 0);
    }
    return _qqButton;
}

- (UIButton *)qzoneButton {
    if(!_qzoneButton) {
        _qzoneButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageForKey:SG_IMAGE_SHARE_QZONE];
        NSString *title = [NSString stringForKey:SG_TEXT_QZONE];
        _qzoneButton.titleLabel.font = [UIFont fontForKey:SG_FONT_N];
        [_qzoneButton setTitleColor:[UIColor colorForFontKey:SG_FONT_N] forState:UIControlStateNormal];
        [_qzoneButton setImage:image forState:UIControlStateNormal];
        [_qzoneButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_QZONE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_qzoneButton setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontForKey:SG_FONT_N]}];
        _qzoneButton.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -image.size.width, 0, 0);
        _qzoneButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 10), titleSize.width/2, 0, 0);
    }
    return _qzoneButton;
}

- (UIButton *)wechatMessageButton {
    if(!_wechatMessageButton) {
        _wechatMessageButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageForKey:SG_IMAGE_SHARE_WECHAT];
        NSString *title = [NSString stringForKey:SG_TEXT_WECHAT_MESSAGE];
        _wechatMessageButton.titleLabel.font = [UIFont fontForKey:SG_FONT_N];
        [_wechatMessageButton setTitleColor:[UIColor colorForFontKey:SG_FONT_N] forState:UIControlStateNormal];
        [_wechatMessageButton setImage:image forState:UIControlStateNormal];
        [_wechatMessageButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_WECHAT_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_wechatMessageButton setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontForKey:SG_FONT_N]}];
        _wechatMessageButton.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -image.size.width, 0, 0);
        _wechatMessageButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 10), titleSize.width/2, 0, 0);
    }
    return _wechatMessageButton;
}

- (UIButton *)wechatTimeLineButton {
    if(!_wechatTimeLineButton) {
        _wechatTimeLineButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageForKey:SG_IMAGE_SHARE_WECHAT_TIMELINE];
        NSString *title = [NSString stringForKey:SG_TEXT_WECHAT_TIMELINE];
        _wechatTimeLineButton.titleLabel.font = [UIFont fontForKey:SG_FONT_N];
        [_wechatTimeLineButton setTitleColor:[UIColor colorForFontKey:SG_FONT_N] forState:UIControlStateNormal];
        [_wechatTimeLineButton setImage:image forState:UIControlStateNormal];
        [_wechatTimeLineButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_WECHAT_TIMELINE_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_wechatTimeLineButton setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontForKey:SG_FONT_N]}];
        _wechatTimeLineButton.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -image.size.width+6, 0, 0);
        _wechatTimeLineButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 10), titleSize.width/2, 0, 0);
    }
    return _wechatTimeLineButton;
}

- (UIButton *)streamCopyButton {
    if(!_streamCopyButton) {
        _streamCopyButton = [[UIButton alloc] init];
        UIImage *image = [UIImage imageForKey:SG_IMAGE_SHARE_COPY];
        NSString *title = [NSString stringForKey:SG_TEXT_COPY];
        _streamCopyButton.titleLabel.font = [UIFont fontForKey:SG_FONT_N];
        [_streamCopyButton setTitleColor:[UIColor colorForFontKey:SG_FONT_N] forState:UIControlStateNormal];
        [_streamCopyButton setImage:image forState:UIControlStateNormal];
        [_streamCopyButton setImage:[UIImage imageForKey:SG_IMAGE_SHARE_COPY_HIGHLIGHT] forState:UIControlStateHighlighted];
        [_streamCopyButton setTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont fontForKey:SG_FONT_N]}];
        _streamCopyButton.titleEdgeInsets = UIEdgeInsetsMake(image.size.height + 10, -image.size.width, 0, 0);
        _streamCopyButton.imageEdgeInsets = UIEdgeInsetsMake(- (titleSize.height + 10), titleSize.width/2, 0, 0);
    }
    return _streamCopyButton;
}


@end
