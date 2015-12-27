//
//  SGPersonnalTextChangeViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGPersonnalTextChangeViewController.h"
#import "SGViewControllerHeader.h"
#import "SGViewControllerDelegate.h"
#import "SGPersonnalTextChangeViewModelProtocol.h"
#import "SGTextField.h"

@interface SGPersonnalTextChangeViewController ()<SGViewControllerDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)SGTextField *textField;
@property (nonatomic, strong)id<SGPersonnalTextChangeViewModelProtocol> viewModel;

@end

@implementation SGPersonnalTextChangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.textField];
    [self updateConstraints];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT + 1);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.containerView);
        make.height.mas_equalTo(40);
    }];
}

- (void)setupNavigation {

}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - accessory
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorForKey:SG_COLOR_NORMAL_GRAY_BG];
    }
    return _scrollView;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (SGTextField *)textField {
    if(!_textField) {
        _textField = [[SGTextField alloc] init];
        _textField.contentFont = [UIFont fontForKey:SG_FONT_J];
        _textField.contentColor = [UIColor colorForFontKey:SG_FONT_J];
        _textField.insets = UIEdgeInsetsMake(0, 10, 0, 10);
        _textField.clearMode = UITextFieldViewModeWhileEditing;
        _textField.editEnable = YES;
    }
    return _textField;
}

@end
