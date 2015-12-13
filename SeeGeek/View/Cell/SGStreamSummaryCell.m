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
        self.backgroundColor = [UIColor greenColor];
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
    [self updateConstraints];
}

- (void)fillData {

}

- (void)updateConstraints {
    [super updateConstraints];
    [self.snapImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
        make.width.mas_equalTo(IMAGE_WIDTH);
        make.height.mas_equalTo(IMAGE_HEIGHT);
    }];
    [self.logoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(LOGO_IMAGE_MARGIN_LEFT);
        make.top.mas_equalTo(self).offset(LOGO_IMAGE_MARGIN_TOP);
        make.width.height.mas_equalTo(LOGO_IMAGE_WIDTH);
    }];

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
    }
    return _logoImageView;
}

- (UIButton *)liveButton {
    if(!_liveButton) {
        _liveButton = [[UIButton alloc] init];
    }
    return _liveButton;
}

- (UIButton *)clipButton {
    if(!_clipButton) {
        _clipButton = [[UIButton alloc] init];
    }
    return _clipButton;
}

- (UIButton *)durationButton {
    if(!_durationButton) {
        _durationButton = [[UIButton alloc] init];
    }
    return _durationButton;
}

- (UIImageView *)locationImageView {
    if(!_locationImageView) {
        _locationImageView = [[UIImageView alloc] init];
    }
    return _locationImageView;
}

- (UILabel *)locationLabel {
    if(!_locationLabel) {
        _locationLabel = [[UILabel alloc] init];
    }
    return _locationLabel;
}

- (UILabel *)tagLabel {
    if(!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
    }
    return _tagLabel;
}

- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (UIImageView *)commentImageView {
    if(!_commentImageView) {
        _commentImageView = [[UIImageView alloc] init];
    }
    return _commentImageView;
}

- (UILabel *)commentLabel {
    if(!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
    }
    return _commentLabel;
}

- (UIImageView *)likeImageView {
    if(!_likeImageView) {
        _likeImageView = [[UIImageView alloc] init];
    }
    return _likeImageView;
}

- (UILabel *)likeLabel {
    if(!_likeLabel) {
        _likeLabel = [[UILabel alloc] init];
    }
    return _likeLabel;
}

@end
