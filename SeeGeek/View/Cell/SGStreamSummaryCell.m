//
//  SGStreamSummaryCell.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGStreamSummaryCell.h"
#import "SGResource.h"
#import <Masonry.h>
#import "UIImageView+URL.h"

#define IMAGE_WIDTH SCREEN_WIDTH
#define IMAGE_HEIGHT 225*SCREEN_SCALE

#define LOGO_IMAGE_WIDTH 30
#define LOGO_IMAGE_MARGIN_LEFT 12
#define LOGO_IMAGE_MARGIN_TOP 5

@interface SGStreamSummaryCell ()

@property (nonatomic, strong) UIImageView *snapImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton    *liveButton;
@property (nonatomic, strong) UIButton    *clipButton;
@property (nonatomic, strong) UIButton    *durationButton;
@property (nonatomic, strong) UIImageView *locationImageView;
@property (nonatomic, strong) UILabel     *locationLabel;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *tagLabel;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UILabel     *commentLabel;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel     *likeLabel;
@property (nonatomic, strong) UIImageView *emptyImageView;
@property (nonatomic, strong) UILabel     *emptyLabel;

@end

@implementation SGStreamSummaryCell

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addSubview:self.snapImageView];
        [self addSubview:self.liveButton];
        [self addSubview:self.clipButton];
        [self addSubview:self.durationButton];
        [self addSubview:self.logoImageView];
        [self addSubview:self.locationImageView];
        [self addSubview:self.locationLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.tagLabel];
        [self addSubview:self.commentImageView];
        [self addSubview:self.commentLabel];
        [self addSubview:self.likeImageView];
        [self addSubview:self.likeLabel];
        [self addSubview:self.emptyImageView];
        [self addSubview:self.emptyLabel];
        [self updateConstraints];
        self.backgroundColor = [UIColor colorForKey:SG_COLOR_NORMAL_GRAY_BG];
    }
    return self;
}

+ (CGFloat)cellHeight {
    return IMAGE_HEIGHT;
}

#pragma mark - update
- (void)setSummaryModel:(SGStreamSummaryModel *)summaryModel {
    _summaryModel = summaryModel;
    [self fillData];
}

- (void)fillData {
    [self hideViews:self.summaryModel.streamType];
    switch (self.summaryModel.streamType) {
        case SGStreamTypeNone: {
            [self showEmpty];
            break;
        }
        case SGStreamTypeLive: {
            [self showLiveSteam];
            break;
        }
        case SGStreamTypeClip: {
            [self showClip];
            break;
        }
    }
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.snapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(LOGO_IMAGE_MARGIN_LEFT);
        make.top.mas_equalTo(self).offset(LOGO_IMAGE_MARGIN_TOP);
        make.width.height.mas_equalTo(LOGO_IMAGE_WIDTH);
    }];
    [self.liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.logoImageView.mas_centerX);
        make.centerY.mas_equalTo(self.logoImageView);
    }];
    [self.clipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView);
        make.left.mas_equalTo(self.logoImageView.mas_centerX);
    }];
    [self.durationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.logoImageView);
        make.left.mas_equalTo(self.clipButton);
    }];
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.snapImageView).offset(-3);
        make.left.mas_equalTo(self.snapImageView).offset(12);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tagLabel.mas_top).offset(-3);
        make.left.mas_equalTo(self.tagLabel);
    }];
    [self.locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagLabel);
        make.bottom.mas_equalTo(self.titleLabel.mas_top).offset(-3);
    }];
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.locationImageView);
        make.left.mas_equalTo(self.locationImageView.mas_right).offset(3);
    }];
    [self.likeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.snapImageView).offset(-12);
        make.centerY.mas_equalTo(self.likeImageView);
    }];
    [self.likeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.likeLabel.mas_left).offset(-3);
        make.bottom.mas_equalTo(self.tagLabel);
    }];
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.likeImageView.mas_left).offset(-20);
        make.centerY.mas_equalTo(self.likeImageView);
    }];
    [self.commentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.commentLabel.mas_left).offset(-3);
        make.bottom.mas_equalTo(self.tagLabel);
    }];
    [self.emptyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.emptyImageView.mas_bottom ).offset(25);
        make.centerX.mas_equalTo(self.emptyImageView);
    }];
}

#pragma mark - private method
- (void)showLiveSteam {
    [self showCommonData];

}

- (void)showClip {
    [self showCommonData];
    [self.durationButton setTitle:@"" forState:UIControlStateNormal];
}

- (void)showCommonData {
    [self.snapImageView showImageWithURL:self.summaryModel.snapshotUrl section:NSStringFromClass([self class]) defaultImage:nil];
    self.locationLabel.text = self.summaryModel.location;
    self.titleLabel.text = self.summaryModel.streamTitle;
    self.tagLabel.text = self.summaryModel.streamTag;
    self.likeLabel.text = [NSString stringWithFormat:@"%d", (int)self.summaryModel.likeNumber];
    self.commentLabel.text = [NSString stringWithFormat:@"%d", (int)self.summaryModel.commentNumber];
}

- (void)showEmpty {
    self.emptyLabel.text = [NSString stringForKey:SG_TEXT_NO_SHARE];
}

- (void)hideViews:(SGStreamType)type {
    BOOL hideLive, hideClip, hideEmpty;
    switch (type) {
        case SGStreamTypeNone: {
            hideLive = YES;
            hideClip = YES;
            hideEmpty = NO;
            break;
        }
        case SGStreamTypeLive: {
            hideLive = NO;
            hideClip = YES;
            hideEmpty = YES;
            break;
        }
        case SGStreamTypeClip: {
            hideLive = YES;
            hideClip = NO;
            hideEmpty = YES;
            break;
        }
    }
    self.snapImageView.hidden = hideLive && hideClip;
    self.logoImageView.hidden = hideLive && hideClip;
    self.liveButton.hidden = hideLive;
    self.clipButton.hidden = hideClip;
    self.durationButton.hidden = hideClip;
    self.locationImageView.hidden = hideLive && hideClip;
    self.locationLabel.hidden = hideLive && hideClip;
    self.titleLabel.hidden = hideLive && hideClip;
    self.tagLabel.hidden = hideLive && hideClip;
    self.commentImageView.hidden = hideLive && hideClip;
    self.commentLabel.hidden = hideLive && hideClip;
    self.likeImageView.hidden = hideLive && hideClip;
    self.likeLabel.hidden = hideLive && hideClip;
    self.emptyImageView.hidden = hideEmpty;
    self.emptyLabel.hidden = hideEmpty;
}

#pragma mark - accessory
- (UIImageView *)snapImageView {
    if(!_snapImageView) {
        _snapImageView = [[UIImageView alloc] init];
    }
    return _snapImageView;
}

- (UIImageView *)logoImageView {
    if(!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.layer.cornerRadius = LOGO_IMAGE_WIDTH/2;
        _logoImageView.clipsToBounds = YES;
        _logoImageView.backgroundColor = [UIColor redColor];
    }
    return _logoImageView;
}

- (UIButton *)liveButton {
    if(!_liveButton) {
        _liveButton = [[UIButton alloc] init];
        [_liveButton setBackgroundImage:[UIImage imageForKey:SG_IMAGE_LIVE_SLIDE_BG] forState:UIControlStateNormal];
        [_liveButton setImage:[UIImage imageForKey:SG_IMAGE_RED_DOT] forState:UIControlStateNormal];
        [_liveButton setTitle:[NSString stringForKey:SG_TEXT_LIVE_EN] forState:UIControlStateNormal];
        [_liveButton setTitleColor:[UIColor colorForFontKey:SG_FONT_K] forState:UIControlStateNormal];
        _liveButton.titleLabel.font = [UIFont fontForKey:SG_FONT_K];
        _liveButton.enabled = NO;
        _liveButton.adjustsImageWhenDisabled = NO;
    }
    return _liveButton;
}

- (UIButton *)clipButton {
    if(!_clipButton) {
        _clipButton = [[UIButton alloc] init];
        [_clipButton setBackgroundImage:[UIImage imageForKey:SG_IMAGE_CLIP_SLIDE_BG] forState:UIControlStateNormal];
        [_clipButton setImage:[UIImage imageForKey:SG_IMAGE_WHITE_PLAY] forState:UIControlStateNormal];
        [_clipButton setTitle:[NSString stringForKey:SG_TEXT_PLAYBACK] forState:UIControlStateNormal];
        [_clipButton setTitleColor:[UIColor colorForFontKey:SG_FONT_K] forState:UIControlStateNormal];
        _clipButton.titleLabel.font = [UIFont fontForKey:SG_FONT_K];
        _clipButton.enabled = NO;
        _clipButton.adjustsImageWhenDisabled = NO;
    }
    return _clipButton;
}

- (UIButton *)durationButton {
    if(!_durationButton) {
        _durationButton = [[UIButton alloc] init];
        [_durationButton setBackgroundImage:[UIImage imageForKey:SG_IMAGE_CLIP_DURATION_BG] forState:UIControlStateNormal];
        [_durationButton setTitleColor:[UIColor colorForFontKey:SG_FONT_K] forState:UIControlStateNormal];
        _durationButton.titleLabel.font = [UIFont fontForKey:SG_FONT_K];
        _durationButton.enabled = NO;
        _durationButton.adjustsImageWhenDisabled = NO;
    }
    return _durationButton;
}

- (UIImageView *)locationImageView {
    if(!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
        _locationImageView.image = [UIImage imageForKey:SG_IMAGE_LOCATION];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if(!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
        _locationLabel.font = [UIFont fontForKey:SG_FONT_J];
        _locationLabel.textColor = [UIColor colorForFontKey:SG_FONT_J];
    }
    return _locationLabel;
}

- (UILabel *)tagLabel {
    if(!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont fontForKey:SG_FONT_O];
        _tagLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
    }
    return _tagLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontForKey:SG_FONT_O];
        _titleLabel.textColor = [UIColor colorForFontKey:SG_FONT_O];
    }
    return _titleLabel;
}

- (UIImageView *)commentImageView {
    if(!_commentImageView) {
        _commentImageView = [[UIImageView alloc] init];
        _commentImageView.image = [UIImage imageForKey:SG_IMAGE_COMMENT];
    }
    return _commentImageView;
}

- (UILabel *)commentLabel {
    if(!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.font = [UIFont fontForKey:SG_FONT_K];
        _commentLabel.textColor = [UIColor colorForFontKey:SG_FONT_K];
    }
    return _commentLabel;
}

- (UIImageView *)likeImageView {
    if(!_likeImageView) {
        _likeImageView = [[UIImageView alloc] init];
        _likeImageView.image = [UIImage imageForKey:SG_IMAGE_LIKE];
    }
    return _likeImageView;
}

- (UILabel *)likeLabel {
    if(!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
        _likeLabel.font = [UIFont fontForKey:SG_FONT_K];
        _likeLabel.textColor = [UIColor colorForFontKey:SG_FONT_K];
    }
    return _likeLabel;
}

- (UIImageView *)emptyImageView {
    if(!_emptyImageView) {
        _emptyImageView = [[UIImageView alloc] init];
        _emptyImageView.image = [UIImage imageForKey:SG_IMAGE_STREAM_EMPTY_LOGO];
    }
    return _emptyImageView;
}

- (UILabel *)emptyLabel {
    if(!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.font = [UIFont fontForKey:SG_FONT_N];
        _emptyLabel.textColor = [UIColor colorForFontKey:SG_FONT_N];
    }
    return _emptyLabel;
}

@end
