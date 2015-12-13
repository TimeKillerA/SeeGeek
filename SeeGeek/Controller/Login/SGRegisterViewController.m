//
//  SGRegisterViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/7.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGRegisterViewController.h"
#import "SGViewControllerHeader.h"
#import "SGViewControllerDelegate.h"
#import "SGTextField.h"
#import "SGRegisterViewModelDelegate.h"

static CGFloat const REGISTER_BUTTON_MARGIN_BOTTOM         = 128;
static CGFloat const LOGO_IMAGE_MARGIN_TOP                 = 80;
static CGFloat const LOGO_IMAGE_WIDTH                      = 100;
static CGFloat const LOGO_IMAGE_HEIGHT                     = 100;
static CGFloat const ACCOUNT_MARGIN_TOP                    = 85;
static CGFloat const TEXTFIELD_HEIGHT                      = 40;
static CGFloat const TEXTFIELD_MARGIN_LEFT_AND_RIGHT       = 35;
static CGFloat const REGISTER_BUTTON_MARGIN_TOP            = 45;
static CGFloat const REGISTER_BUTTON_MARGIN_LEFT_AND_RIGHT = 90;
static CGFloat const REGISTER_BUTTON_HEIGHT                = 40;
static CGFloat const VERIFY_CODE_FILED_WIDTH               = 100;
static CGFloat const SEND_VERIFY_CODE_BUTTON_WIDTH         = 130;
static CGFloat const SEND_VERIFY_CODE_BUTTON_HEIGHT        = 30;

@interface SGRegisterViewController ()<SGViewControllerDelegate>

@property (nonatomic, strong) id<SGRegisterViewModelDelegate> viewModel;
@property (nonatomic, strong) UIScrollView                *scrollView;
@property (nonatomic, strong) UIView                      *containerView;
@property (nonatomic, strong) UIImageView                 *backgroundView;
@property (nonatomic, strong) UIImageView                 *logoImageView;
@property (nonatomic, strong) SGTextField                 *phoneNumberField;
@property (nonatomic, strong) SGTextField                 *verifyCodeField;
@property (nonatomic, strong) SGTextField                 *passwordField;
@property (nonatomic, strong) UIButton                    *sendVerifyCodeButton;
@property (nonatomic, strong) UIButton                    *registerButton;

@end

@implementation SGRegisterViewController

#pragma mark - life cycle

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.backgroundView];
    [self.containerView addSubview:self.logoImageView];
    [self.containerView addSubview:self.phoneNumberField];
    [self.containerView addSubview:self.verifyCodeField];
    [self.containerView addSubview:self.sendVerifyCodeButton];
    [self.containerView addSubview:self.passwordField];
    [self.containerView addSubview:self.registerButton];
    [self updateConstraints];
    [self updateListener];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.bottom.mas_equalTo(self.registerButton).offset(REGISTER_BUTTON_MARGIN_BOTTOM);
    }];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.containerView).offset(LOGO_IMAGE_MARGIN_TOP);
        make.width.mas_equalTo(LOGO_IMAGE_WIDTH);
        make.height.mas_equalTo(LOGO_IMAGE_HEIGHT);
    }];
    [self.phoneNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(ACCOUNT_MARGIN_TOP);
        make.left.right.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(0, TEXTFIELD_MARGIN_LEFT_AND_RIGHT, 0, TEXTFIELD_MARGIN_LEFT_AND_RIGHT));
        make.height.mas_equalTo(TEXTFIELD_HEIGHT);
    }];
    [self.verifyCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.height.mas_equalTo(self.phoneNumberField.mas_bottom);
        make.width.mas_equalTo(VERIFY_CODE_FILED_WIDTH);
    }];
    [self.sendVerifyCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.phoneNumberField.mas_bottom);
        make.width.mas_equalTo(SEND_VERIFY_CODE_BUTTON_WIDTH);
        make.height.mas_equalTo(SEND_VERIFY_CODE_BUTTON_HEIGHT);
        make.bottom.mas_equalTo(self.verifyCodeField);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.phoneNumberField);
        make.top.mas_equalTo(self.phoneNumberField.mas_bottom);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordField.mas_bottom).offset(REGISTER_BUTTON_MARGIN_TOP);
        make.height.mas_equalTo(REGISTER_BUTTON_HEIGHT);
        make.left.right.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(0, REGISTER_BUTTON_MARGIN_LEFT_AND_RIGHT, 0, REGISTER_BUTTON_MARGIN_LEFT_AND_RIGHT));
    }];
}

- (void)updateListener {
    WS(weakSelf);
    [[[RACObserve(self.phoneNumberField, content) deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        weakSelf.viewModel.phoneNumber = x;
    }];
    [[[RACObserve(self.verifyCodeField, content) deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        weakSelf.viewModel.verifyCode = x;
    }];
    [[[RACObserve(self.passwordField, content) deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        weakSelf.viewModel.password = x;
    }];
    [[self.sendVerifyCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf sendVerifyCode];
    }];
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf sendRegister];
    }];
    [[[[self.viewModel signalForLeftTimeSendCodeChanged] distinctUntilChanged] deliverOnMainThread] subscribeNext:^(id x) {
        NSInteger time = [x integerValue];
        if(time <= 0) {
            weakSelf.sendVerifyCodeButton.enabled = YES;
        } else {
            weakSelf.sendVerifyCodeButton.enabled = NO;
        }
    }];
}

#pragma mark - event response
- (void)sendVerifyCode {

}

- (void)sendRegister {

}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {

}

#pragma mark - accessory
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)backgroundView {
    if(!_backgroundView) {
        _backgroundView = [[UIImageView alloc] init];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}

- (UIImageView *)logoImageView {
    if(!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
    }
    return _logoImageView;
}

- (SGTextField *)phoneNumberField {
    if(!_phoneNumberField) {
        _phoneNumberField = [[SGTextField alloc] init];
    }
    return _phoneNumberField;
}

- (SGTextField *)verifyCodeField {
    if(!_verifyCodeField) {
        _verifyCodeField = [[SGTextField alloc] init];
    }
    return _verifyCodeField;
}

- (SGTextField *)passwordField {
    if(!_passwordField) {
        _passwordField = [[SGTextField alloc] init];
    }
    return _passwordField;
}

- (UIButton *)sendVerifyCodeButton {
    if(!_sendVerifyCodeButton) {
        _sendVerifyCodeButton = [[UIButton alloc] init];
    }
    return _sendVerifyCodeButton;
}

- (UIButton *)registerButton {
    if(!_registerButton) {
        _registerButton = [[UIButton alloc] init];
    }
    return _registerButton;
}

@end
