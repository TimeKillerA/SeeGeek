

//
//  SGStreamPersonnalPageView.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/2.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGStreamPersonnalPageView.h"
#import <MAMapKit/MAMapKit.h>
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import "SGResource.h"

static CGFloat const TITLE_AREA_HEIGHT = 45;
static CGFloat const HEAD_IMAGE_WIDTH = 60;

@interface SGStreamPersonnalPageView ()

@property (nonatomic, strong)UIView *backgroundView;
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)UIView *statusView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UIButton *closeButton;
@property (nonatomic, strong)UIView *infoContainer;
@property (nonatomic, strong)UIImageView *headImageView;
@property (nonatomic, strong)UILabel *signLabel;
@property (nonatomic, strong)UILabel *focusLabel;
@property (nonatomic, strong)UILabel *fansLabel;
@property (nonatomic, strong)UIButton *focusPersonButton;
@property (nonatomic, strong)UIView *mapContainer;
@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)UIButton *locationButton;
@property (nonatomic, strong)UIButton *focusLocationButton;

@end

@implementation SGStreamPersonnalPageView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.containerView];
        [self.containerView addSubview:self.statusView];
        [self.containerView addSubview:self.nameLabel];
        [self.containerView addSubview:self.closeButton];
        [self.containerView addSubview:self.infoContainer];
        [self.containerView addSubview:self.mapContainer];
        [self.infoContainer addSubview:self.headImageView];
        [self.infoContainer addSubview:self.signLabel];
        [self.infoContainer addSubview:self.focusLabel];
        [self.infoContainer addSubview:self.fansLabel];
        [self.infoContainer addSubview:self.focusPersonButton];
        [self.mapContainer addSubview:self.mapView];
        [self.mapContainer addSubview:self.locationButton];
        [self.mapContainer addSubview:self.focusLocationButton];
        [self updateConstraints];
        [self setupListeners];
    }
    return self;
}

#pragma mark - setup
- (void)updateConstraints {
    [super updateConstraints];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.backgroundView);
        make.bottom.mas_equalTo(self.mapContainer);
    }];
    [self.statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(STATUS_BAR_HEIGHT);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(TITLE_AREA_HEIGHT);
        make.top.mas_equalTo(self.statusView.mas_bottom);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel);
        make.right.mas_equalTo(self.containerView).offset(-12);
    }];
    [self.infoContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom);
        make.left.right.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.focusPersonButton).offset(5);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.infoContainer);
        make.width.height.mas_equalTo(HEAD_IMAGE_WIDTH);
        make.top.mas_equalTo(self.infoContainer).offset(5);
    }];
    [self.signLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.infoContainer);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(8);
    }];
    [self.focusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.focusPersonButton);
        make.top.mas_equalTo(self.signLabel.mas_bottom).offset(5);
    }];
    [self.fansLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.focusPersonButton);
        make.top.mas_equalTo(self.signLabel.mas_bottom).offset(5);
    }];
    [self.focusPersonButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.focusLabel.mas_bottom).offset(5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(120);
        make.centerX.mas_equalTo(self.infoContainer);
    }];
    [self.mapContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoContainer.mas_bottom);
        make.left.right.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.focusLocationButton).offset(5);
    }];
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.mapContainer);
        make.height.mas_equalTo(140);
    }];
    [self.locationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mapContainer).offset(12);
        make.bottom.mas_equalTo(self.mapView).offset(-5);
    }];
    [self.focusLocationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mapView.mas_bottom).offset(5);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(120);
        make.centerX.mas_equalTo(self.mapContainer);
    }];
}

- (void)setupListeners {
    WS(weakSelf);
    [[self.focusPersonButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([weakSelf.delegate respondsToSelector:@selector(didFocusPerson)]) {
            [weakSelf.delegate didFocusPerson];
        }
    }];
    [[self.focusLocationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if([weakSelf.delegate respondsToSelector:@selector(didFocusLocation)]) {
            [weakSelf.delegate didFocusLocation];
        }
    }];
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf dismiss];
    }];
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

- (UIView *)statusView {
    if(!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = [UIColor colorForKey:SG_COLOR_SHARE_TITLE_BG];
    }
    return _statusView;
}

- (UILabel *)nameLabel {
    if(!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = [NSString stringForKey:SG_TEXT_SHARE];
        _nameLabel.textColor = [UIColor colorForFontKey:SG_FONT_H];
        _nameLabel.font = [UIFont fontForKey:SG_FONT_H];
        _nameLabel.backgroundColor = [UIColor colorForKey:SG_COLOR_SHARE_TITLE_BG];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIButton *)closeButton {
    if(!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageForKey:SG_IMAGE_CLOSE] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIView *)infoContainer {
    if(!_infoContainer) {
        _infoContainer = [[UIView alloc] init];
        _infoContainer.backgroundColor = [UIColor whiteColor];
    }
    return _infoContainer;
}

- (UIImageView *)headImageView {
    if(!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.cornerRadius = HEAD_IMAGE_WIDTH/2;
        _headImageView.clipsToBounds = YES;
    }
    return _headImageView;
}

- (UILabel *)signLabel {
    if(!_signLabel) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.textAlignment = NSTextAlignmentCenter;
        _signLabel.textColor = [UIColor colorForFontKey:SG_FONT_J];
        _signLabel.font = [UIFont fontForKey:SG_FONT_J];
        _signLabel.numberOfLines = 0;
    }
    return _signLabel;
}

- (UILabel *)focusLabel {
    if(!_focusLabel) {
        _focusLabel = [[UILabel alloc] init];
        _focusLabel.font = [UIFont fontForKey:SG_FONT_N];
        _focusLabel.textColor = [UIColor colorForFontKey:SG_FONT_N];
    }
    return _focusLabel;
}

- (UILabel *)fansLabel {
    if(!_fansLabel) {
        _fansLabel = [[UILabel alloc] init];
        _fansLabel.font = [UIFont fontForKey:SG_FONT_N];
        _fansLabel.textColor = [UIColor colorForFontKey:SG_FONT_N];
    }
    return _fansLabel;
}

- (UIButton *)focusPersonButton {
    if(!_focusPersonButton) {
        _focusPersonButton = [[UIButton alloc] init];
        _focusPersonButton.titleLabel.font = [UIFont fontForKey:SG_FONT_E];
        [_focusPersonButton setTitle:[NSString stringWithFormat:@"+ %@", [NSString stringForKey:SG_TEXT_FOCUS_PERSON]] forState:UIControlStateNormal];
        _focusPersonButton.layer.cornerRadius = 10;
        _focusPersonButton.backgroundColor = [UIColor colorForKey:SG_COLOR_RED_BG];
    }
    return _focusPersonButton;
}

- (UIView *)mapContainer {
    if(!_mapContainer) {
        _mapContainer = [[UIView alloc] init];
        _mapContainer.backgroundColor = [UIColor whiteColor];
    }
    return _mapContainer;
}

- (MAMapView *)mapView {
    if(!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.zoomEnabled = NO;
    }
    return _mapView;
}

- (UIButton *)locationButton {
    if(!_locationButton) {
        _locationButton = [[UIButton alloc] init];
        [_locationButton setImage:[UIImage imageForKey:SG_IMAGE_LOCATION] forState:UIControlStateNormal];
        [_locationButton setTitle:[NSString stringForKey:SG_TEXT_LOCATION] forState:UIControlStateNormal];
        [_locationButton setTitleColor:[UIColor colorForFontKey:SG_FONT_J] forState:UIControlStateNormal];
        _locationButton.titleLabel.font = [UIFont fontForKey:SG_FONT_J];
        _locationButton.enabled = NO;
        _locationButton.adjustsImageWhenDisabled = NO;
    }
    return _locationButton;
}

- (UIButton *)focusLocationButton {
    if(!_focusLocationButton) {
        _focusLocationButton = [[UIButton alloc] init];
        _focusLocationButton.titleLabel.font = [UIFont fontForKey:SG_FONT_E];
        [_focusLocationButton setTitle:[NSString stringWithFormat:@"+ %@", [NSString stringForKey:SG_TEXT_FOCUS_LOCATION]] forState:UIControlStateNormal];
        _focusLocationButton.layer.cornerRadius = 10;
        _focusLocationButton.backgroundColor = [UIColor colorForKey:SG_COLOR_RED_BG];
    }
    return _focusLocationButton;
}

@end
