//
//  SGLoginViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGLoginViewController.h"
#import "SGViewControllerHeader.h"
#import "../../Protocol/SGViewControllerDelegate.h"
#import "SGLoginViewModelProtocol.h"
#import "SGTextField.h"
#import "../../Resource/SGResource.h"
#import "UIViewController+HUD.h"

CGFloat const WECHAT_BUTTON_MARGIN_BOTTOM        = 70;
CGFloat const LOGO_IMAGE_MARGIN_TOP              = 80;
CGFloat const LOGO_IMAGE_WIDTH                   = 100;
CGFloat const LOGO_IMAGE_HEIGHT                  = 100;
CGFloat const ACCOUNT_MARGIN_TOP                 = 85;
CGFloat const TEXTFIELD_HEIGHT                   = 40;
CGFloat const TEXTFIELD_MARGIN_LEFT_AND_RIGHT    = 35;
CGFloat const LOGIN_BUTTON_MARGIN_TOP            = 45;
CGFloat const LOGIN_BUTTON_MARGIN_LEFT_AND_RIGHT = 90;
CGFloat const LOGIN_BUTTON_HEIGHT                = 40;
CGFloat const REGISTER_BUTTON_MARGIN_TOP         = 15;
CGFloat const QQ_BUTTON_MARGIN_LEFT              = 65;
CGFloat const SINA_BUTTON_MARGIN_RIGHT           = 65;
CGFloat const QQ_BUTTON_MARGIN_TOP               = 25;

@interface SGLoginViewController ()<SGViewControllerDelegate>

@property (nonatomic, strong) id<SGLoginViewModelProtocol> viewModel;
@property (nonatomic, strong) UIScrollView             *scrollView;
@property (nonatomic, strong) UIView                   *containerView;
@property (nonatomic, strong) UIImageView              *backgroundView;
@property (nonatomic, strong) UIImageView              *logoImageView;
@property (nonatomic, strong) SGTextField              *accountField;
@property (nonatomic, strong) SGTextField              *passwordField;
@property (nonatomic, strong) UIButton                 *loginButton;
@property (nonatomic, strong) UIButton                 *forgetPasswordButton;
@property (nonatomic, strong) UIButton                 *registerButton;
@property (nonatomic, strong) UIButton                 *qqButton;
@property (nonatomic, strong) UIButton                 *wechatButton;
@property (nonatomic, strong) UIButton                 *sinaButton;

@end

@implementation SGLoginViewController

#pragma mark - life cycle
- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.backgroundView];
    [self.containerView addSubview:self.logoImageView];
    [self.containerView addSubview:self.accountField];
    [self.containerView addSubview:self.passwordField];
    [self.containerView addSubview:self.loginButton];
    [self.containerView addSubview:self.forgetPasswordButton];
    [self.containerView addSubview:self.registerButton];
    [self.containerView addSubview:self.qqButton];
    [self.containerView addSubview:self.wechatButton];
    [self.containerView addSubview:self.sinaButton];
    [self updateConstraints];
    [self updateData];
}

#pragma mark - update UI
- (void)updateConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(self.scrollView);
        make.bottom.mas_equalTo(self.wechatButton).offset(WECHAT_BUTTON_MARGIN_BOTTOM);
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
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(ACCOUNT_MARGIN_TOP);
        make.left.right.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(0, TEXTFIELD_MARGIN_LEFT_AND_RIGHT, 0, TEXTFIELD_MARGIN_LEFT_AND_RIGHT));
        make.height.mas_equalTo(TEXTFIELD_HEIGHT);
    }];
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.accountField);
        make.top.mas_equalTo(self.accountField.mas_bottom);
    }];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordField.mas_bottom).offset(LOGIN_BUTTON_MARGIN_TOP);
        make.height.mas_equalTo(LOGIN_BUTTON_HEIGHT);
        make.left.right.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(0, LOGIN_BUTTON_MARGIN_LEFT_AND_RIGHT, 0, LOGIN_BUTTON_MARGIN_LEFT_AND_RIGHT));
    }];
    [self.forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(REGISTER_BUTTON_MARGIN_TOP);
        make.left.mas_equalTo(self.loginButton);
    }];
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginButton.mas_bottom).offset(REGISTER_BUTTON_MARGIN_TOP);
        make.right.mas_equalTo(self.loginButton);
    }];
    [self.qqButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerButton.mas_bottom).offset(QQ_BUTTON_MARGIN_TOP);
        make.left.mas_equalTo(self.containerView).offset(QQ_BUTTON_MARGIN_LEFT);
    }];
    [self.sinaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerButton.mas_bottom).offset(QQ_BUTTON_MARGIN_TOP);
        make.right.mas_equalTo(self.containerView).offset(-SINA_BUTTON_MARGIN_RIGHT);
    }];
    [self.wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.registerButton.mas_bottom).offset(QQ_BUTTON_MARGIN_TOP);
        make.centerX.mas_equalTo(self.containerView);
    }];
}

- (void)updateData {
    WS(weakSelf);
    self.accountField.content = [self.viewModel accountForLastLogin];
    RAC(self.viewModel, account) = RACObserve(self.accountField, content);
    RAC(self.viewModel, password) = RACObserve(self.passwordField, content);
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf login];
    }];
    [[self.forgetPasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf forgetPassword];
    }];
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf registe];
    }];
    [[self.qqButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf loginWithThirdpart:SGThirdPartTypeLoginQQ];
    }];
    [[self.wechatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf loginWithThirdpart:SGThirdPartTypeLoginWechat];
    }];
    [[self.sinaButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf loginWithThirdpart:SGThirdPartTypeLoginSina];
    }];
}

#pragma mark - event response
- (void)login {
    WS(weakSelf);
    [self enableButtons:NO];
    [self showDefaultProgressHUD];
    [[[self.viewModel signalForLogin] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
        [weakSelf enableButtons:YES];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{

    }];
}

- (void)loginWithThirdpart:(SGThirdPartType)type {

}

- (void)forgetPassword {

}

- (void)registe {

}

#pragma mark - help method
- (void)enableButtons:(BOOL)enable {
    self.loginButton.enabled          = enable;
    self.forgetPasswordButton.enabled = enable;
    self.registerButton.enabled       = enable;
    self.qqButton.enabled             = enable;
    self.wechatButton.enabled         = enable;
    self.sinaButton.enabled           = enable;
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - accessory
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorForKey:COLOR_VIEW_CONTROLLER_BACKGROUND];
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
        _backgroundView.image = [UIImage imageForKey:IMAGE_LOGIN_BACKGROUND];
        _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backgroundView;
}

- (UIImageView *)logoImageView {
    if(!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = [UIImage imageForKey:IMAGE_LOGO];
    }
    return _logoImageView;
}

- (SGTextField *)accountField {
    if(!_accountField) {
        _accountField = [[SGTextField alloc] init];
    }
    return _accountField;
}

- (SGTextField *)passwordField {
    if(!_passwordField) {
        _passwordField = [[SGTextField alloc] init];
    }
    return _passwordField;
}

- (UIButton *)qqButton {
    if(!_qqButton) {
        _qqButton = [[UIButton alloc] init];
        [_qqButton setImage:[UIImage imageForKey:IMAGE_QQ] forState:UIControlStateNormal];
        [_qqButton setTitle:[NSString stringForKey:TEXT_LOGIN_WITH_QQ] forState:UIControlStateNormal];
    }
    return _qqButton;
}

- (UIButton *)wechatButton {
    if(_wechatButton) {
        _wechatButton = [[UIButton alloc] init];
        [_wechatButton setImage:[UIImage imageForKey:IMAGE_WECHAT] forState:UIControlStateNormal];
        [_wechatButton setTitle:[NSString stringForKey:TEXT_LOGIN_WITH_WECHAT] forState:UIControlStateNormal];
    }
    return _wechatButton;
}

- (UIButton *)sinaButton {
    if(_sinaButton) {
        _sinaButton = [[UIButton alloc] init];
        [_sinaButton setImage:[UIImage imageForKey:IMAGE_SINA] forState:UIControlStateNormal];
        [_sinaButton setTitle:[NSString stringForKey:TEXT_LOGIN_WIDTH_SINA] forState:UIControlStateNormal];
    }
    return _sinaButton;
}

@end
