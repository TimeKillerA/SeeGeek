//
//  SGMainUserViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainUserViewController.h"
#import "SGViewControllerHeader.h"
#import <TKRoundedView.h>
#import "SGCollectionViewDataSource.h"

static CGFloat const HEAD_IMAGE_WIDTH = 70;

@interface SGMainUserViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIScrollView               *scrollView;
@property (nonatomic, strong) UIView                     *containerView;
@property (nonatomic, strong) UIImageView                *headImageView;
@property (nonatomic, strong) UILabel                    *publishCountLabel;
@property (nonatomic, strong) UILabel                    *focusCountLabel;
@property (nonatomic, strong) UILabel                    *fansCountLabel;
@property (nonatomic, strong) UIButton                   *personnalSettingsButton;
@property (nonatomic, strong) UILabel                    *personnalSignLabel;
@property (nonatomic, strong) UIButton                   *collectionStyleButton;
@property (nonatomic, strong) UIButton                   *tableStyleButton;
@property (nonatomic, strong) TKRoundedView              *actionView;
@property (nonatomic, strong) UIView                     *actionDeviderView;
@property (nonatomic, strong) UICollectionView           *collectionView;
@property (nonatomic, strong) SGCollectionViewDataSource *collectionDataSource;

@end

@implementation SGMainUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.headImageView];
    [self.containerView addSubview:self.publishCountLabel];
    [self.containerView addSubview:self.focusCountLabel];
    [self.containerView addSubview:self.fansCountLabel];
    [self.containerView addSubview:self.personnalSignLabel];
    [self.containerView addSubview:self.personnalSettingsButton];
    [self.containerView addSubview:self.actionView];
    [self.actionView addSubview:self.collectionStyleButton];
    [self.actionView addSubview:self.tableStyleButton];
    [self.actionView addSubview:self.actionDeviderView];
    [self.containerView addSubview:self.collectionView];
    [self updateConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, TAB_BAR_HEIGHT, 0));
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT + 1);
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(12, 12, 0, 0));
        make.width.height.mas_equalTo(HEAD_IMAGE_WIDTH);
    }];
    [self.personnalSettingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(41);
        make.right.mas_equalTo(self.containerView).offset(12);
        make.top.mas_equalTo(self.containerView).offset(49);
        make.height.mas_equalTo(30);
    }];
    [self.publishCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.personnalSettingsButton.mas_top);
    }];
    [self.focusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.personnalSettingsButton.mas_top);
    }];
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.personnalSettingsButton.mas_top);
    }];
    [self.personnalSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView);
        make.right.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(15);
    }];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.personnalSignLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    [self.actionDeviderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.actionView);
        make.top.bottom.mas_equalTo(self.actionView);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [self.collectionStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.actionView);
        make.right.mas_equalTo(self.actionDeviderView.mas_left);
    }];
    [self.tableStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.actionView);
        make.left.mas_equalTo(self.actionDeviderView.mas_right);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.actionView.mas_bottom);
        make.left.right.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.containerView);
    }];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {

}

#pragma mark - UICollectionViewDelegateFlowLayout

#pragma mark - accessory
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorForKey:SG_COLOR_CONTROLLER_GRAY_BG];
    }
    return _scrollView;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)headImageView {
    if(!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

- (UILabel *)publishCountLabel {
    if(!_publishCountLabel) {
        _publishCountLabel = [[UILabel alloc] init];
        _publishCountLabel.numberOfLines = 0;
    }
    return _publishCountLabel;
}

- (UILabel *)focusCountLabel {
    if(!_focusCountLabel) {
        _focusCountLabel = [[UILabel alloc] init];
        _focusCountLabel.numberOfLines = 0;
    }
    return _focusCountLabel;
}

- (UILabel *)fansCountLabel {
    if(!_fansCountLabel) {
        _fansCountLabel = [[UILabel alloc] init];
        _fansCountLabel.numberOfLines = 0;
    }
    return _fansCountLabel;
}

- (UIButton *)personnalSettingsButton {
    if(!_personnalSettingsButton) {
        _personnalSettingsButton = [[UIButton alloc] init];
        [_personnalSettingsButton setTitle:[NSString stringForKey:SG_TEXT_PERSONNAL_SETTINGS] forState:UIControlStateNormal];
        [_personnalSettingsButton setTitleColor:[UIColor colorForFontKey:SG_FONT_I] forState:UIControlStateNormal];
        _personnalSettingsButton.titleLabel.font = [UIFont fontForKey:SG_FONT_I];
        _personnalSettingsButton.backgroundColor = [UIColor colorForKey:SG_COLOR_NORMAL_GRAY_BG];
        _personnalSettingsButton.layer.cornerRadius = 5;
    }
    return _personnalSettingsButton;
}

- (UILabel *)personnalSignLabel {
    if(!_personnalSignLabel) {
        _personnalSignLabel = [[UILabel alloc] init];
        _personnalSignLabel.textColor = [UIColor colorForFontKey:SG_FONT_J];
        _personnalSignLabel.font = [UIFont fontForKey:SG_FONT_J];
        _personnalSignLabel.numberOfLines = 0;
        _personnalSignLabel.text = [NSString stringForKey:SG_TEXT_INIT_PERSONNAL_SIGN];
    }
    return _personnalSignLabel;
}

- (TKRoundedView *)actionView {
    if(!_actionView) {
        _actionView = [[TKRoundedView alloc] init];
        _actionView.borderColor = [UIColor lineColor];
        _actionView.borderWidth = 1/[UIScreen mainScreen].scale;
        _actionView.drawnBordersSides = TKDrawnBorderSidesTop | TKDrawnBorderSidesBottom;
        _actionView.roundedCorners = TKRoundedCornerNone;
        _actionView.fillColor = [UIColor whiteColor];
    }
    return _actionView;
}

- (UIView *)actionDeviderView {
    if(!_actionDeviderView) {
        _actionDeviderView = [[UIView alloc] init];
        _actionDeviderView.backgroundColor = [UIColor lineColor];
    }
    return _actionDeviderView;
}

- (UIButton *)collectionStyleButton {
    if(!_collectionStyleButton) {
        _collectionStyleButton = [[UIButton alloc] init];
        [_collectionStyleButton setImage:[UIImage imageForKey:SG_IMAGE_COLLECTION_STYLE] forState:UIControlStateNormal];
    }
    return _collectionStyleButton;
}

- (UIButton *)tableStyleButton {
    if(!_tableStyleButton) {
        _tableStyleButton = [[UIButton alloc] init];
        [_tableStyleButton setImage:[UIImage imageForKey:SG_IMAGE_TABLE_STYLE] forState:UIControlStateNormal];
    }
    return _tableStyleButton;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {

    }
    return _collectionView;
}

- (SGCollectionViewDataSource *)collectionDataSource {
    if(!_collectionDataSource) {

    }
    return _collectionDataSource;
}

@end
