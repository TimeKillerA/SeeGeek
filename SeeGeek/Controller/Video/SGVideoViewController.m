//
//  SGVideoViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGVideoViewController.h"
#import "SGViewControllerHeader.h"
#import "SGViewControllerDelegate.h"
#import "ChatMessageDisplayView.h"

static CGFloat const TITLE_CONTAINER_MARGIN_TOP = 10;
static CGFloat const TITLE_HEAD_IMAGE_WIDTH = 30;
static CGFloat const TITLE_CONTAINER_MARGIN_LEFT = 12;


@interface SGVideoViewController ()<SGViewControllerDelegate, UITextViewDelegate>

/**
 *  视频在此视图中展示
 */
@property (nonatomic, strong)UIView *previewView;

/**
 *  所有操作视图的背景视图
 */
@property (nonatomic, strong)UIScrollView *actionBackgroundView;

/**
 *  所有操作的容器视图，主要为了添加约束时方便
 */
@property (nonatomic, strong)UIView *actionContainerView;

#pragma mark - 标题栏相关视图

/**
 *  标题栏容器
 */
@property (nonatomic, strong)UIView *titleContainerView;

/**
 *  头像
 */
@property (nonatomic, strong)UIImageView *headImageView;

/**
 *  直播（标题+红点）
 */
@property (nonatomic, strong)UIButton *liveButton;

/**
 *  直播时间
 */
@property (nonatomic, strong)UIButton *liveTimeButton;

/**
 *  点播
 */
@property (nonatomic, strong)UIButton *clipButton;

/**
 *  点播时长
 */
@property (nonatomic, strong)UIButton *clipDurationButton;

/**
 *  举报按钮
 */
@property (nonatomic, strong)UIButton *reportButton;

/**
 *  关闭按钮
 */
@property (nonatomic, strong)UIButton *closeButton;

#pragma mark - chat view
/**
 *  聊天信息展示视图
 */
@property (nonatomic, strong)UIView *chatContainer;

/**
 *  展示聊天消息
 */
@property (nonatomic, strong)ChatMessageDisplayView *messageDisplayView;

#pragma mark - visit view
/**
 *  访问者容器
 */
@property (nonatomic, strong)UIView *visitContainer;

/**
 *  访问者数量
 */
@property (nonatomic, strong)UILabel *visitCountLabel;

/**
 *  访问者头像列表
 */
@property (nonatomic, strong)UIView *visitHeadListView;

/**
 *  点赞数
 */
@property (nonatomic, strong)UILabel *likeCountLabel;

/**
 *  点赞按钮
 */
@property (nonatomic, strong)UIButton *likeButton;

#pragma mark - publisher
/**
 *  消息发布容器
 */
@property (nonatomic, strong)UIView *publisherContainer;

/**
 *  聊天按钮
 */
@property (nonatomic, strong)UIButton *chatButton;

/**
 *  输入框
 */
@property (nonatomic, strong)UITextView *chatTextView;

/**
 *  分享按钮
 */
@property (nonatomic, strong)UIButton *shareButton;

#pragma mark - property end

@end

@implementation SGVideoViewController

#pragma mark - life cycle
- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupListeners];
    [self.view addSubview:self.previewView];
    [self.view addSubview:self.actionBackgroundView];
    [self.actionBackgroundView addSubview:self.actionContainerView];
    [self setupTitleContainer];
    [self setupChatContainer];
    [self setupVisitContainer];
    [self setupPublisherContainer];
    [self updateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI setup
- (void)setupTitleContainer {
    [self.actionContainerView addSubview:self.titleContainerView];
    [self.titleContainerView addSubview:self.headImageView];
    [self.titleContainerView addSubview:self.liveButton];
    [self.titleContainerView addSubview:self.liveTimeButton];
    [self.titleContainerView addSubview:self.clipButton];
    [self.titleContainerView addSubview:self.clipDurationButton];
    [self.titleContainerView addSubview:self.reportButton];
    [self.titleContainerView addSubview:self.closeButton];
}

- (void)setupChatContainer {
    [self.actionContainerView addSubview:self.chatContainer];
    [self.chatContainer addSubview:self.messageDisplayView];
}

- (void)setupVisitContainer {
    [self.actionContainerView addSubview:self.visitContainer];
    [self.visitContainer addSubview:self.visitCountLabel];
    [self.visitContainer addSubview:self.visitHeadListView];
    [self.visitContainer addSubview:self.likeCountLabel];
    [self.visitContainer addSubview:self.likeButton];
}

- (void)setupPublisherContainer {
    [self.actionContainerView addSubview:self.publisherContainer];
    [self.publisherContainer addSubview:self.chatButton];
    [self.publisherContainer addSubview:self.chatTextView];
    [self.publisherContainer addSubview:self.shareButton];
}

- (void)updateConstraints {
    [self updateBackgroundConstraints];
    [self updateTitleContainerConstraints];
    [self updateChatContainerConstraints];
    [self updateVisitContainerConstraints];
    [self updatePublishContainerConstraints];
}

- (void)updateBackgroundConstraints {
    [self.previewView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.actionBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.actionContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.actionBackgroundView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(SCREEN_HEIGHT);
    }];
}

- (void)updateTitleContainerConstraints {
    [self.titleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.actionContainerView).offset(TITLE_CONTAINER_MARGIN_TOP + STATUS_BAR_HEIGHT);
        make.left.right.mas_equalTo(self.actionContainerView).insets(UIEdgeInsetsMake(0, TITLE_CONTAINER_MARGIN_LEFT, 0, TITLE_CONTAINER_MARGIN_LEFT));
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(TITLE_HEAD_IMAGE_WIDTH);
        make.top.mas_equalTo(self.titleContainerView);
        make.left.mas_equalTo(self.actionContainerView);
    }];
    [self.liveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView);
        make.left.mas_equalTo(self.headImageView.mas_centerX);
    }];
    [self.liveTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImageView);
        make.left.mas_equalTo(self.headImageView.mas_centerX);
    }];
    [self.clipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headImageView);
        make.left.mas_equalTo(self.headImageView.mas_centerX);
    }];
    [self.clipDurationButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImageView);
        make.left.mas_equalTo(self.headImageView.mas_centerX);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleContainerView);
        make.right.mas_equalTo(self.titleContainerView);
    }];
    [self.reportButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(self.titleContainerView);
        make.right.mas_equalTo(self.closeButton.mas_left).offset(-15);
    }];
    [self.titleContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.headImageView);
    }];
}

- (void)updateChatContainerConstraints {
    [self.chatContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleContainerView);
        make.bottom.mas_equalTo(self.visitContainer.mas_top).offset(6);
        make.width.mas_equalTo(self.actionContainerView).multipliedBy(0.6);
        make.height.mas_equalTo(self.actionContainerView).multipliedBy(0.3);
    }];
    [self.messageDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.chatContainer);
    }];
}

- (void)updateVisitContainerConstraints {
    [self.visitContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.publisherContainer.mas_top).offset(-10);
        make.left.right.mas_equalTo(self.titleContainerView);
        make.height.mas_equalTo(30);
    }];
}

- (void)updatePublishContainerConstraints {
    [self.publisherContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleContainerView);
        make.bottom.mas_equalTo(self.actionContainerView).offset(-1);
        make.top.mas_equalTo(self.chatTextView);
    }];
    [self.chatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.mas_equalTo(self.publisherContainer);
    }];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.mas_equalTo(self.publisherContainer);
        make.width.height.mas_equalTo(self.chatButton);
    }];
    [self.chatTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chatButton.mas_right).offset(5);
        make.bottom.mas_equalTo(self.publisherContainer);
        make.right.mas_equalTo(self.shareButton.mas_left).offset(-5);
        make.height.mas_equalTo(self.chatButton);
    }];
}

#pragma mark - listener setup
- (void)setupListeners {
    WS(weakSelf);
    [[self.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - event response
- (void)sendText:(NSString *)text {
    if(text.length == 0) {
        return;
    }
    self.chatTextView.text = nil;
    [self.messageDisplayView addMessage:text userName:text];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {

}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        NSString *sendText = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self sendText:sendText];
        return NO;
    }
    return YES;
}

#pragma mark - accessory
- (UIView *)previewView {
    if(!_previewView) {
        _previewView = [[UIView alloc] init];
        _previewView.backgroundColor = [UIColor purpleColor];
    }
    return _previewView;
}

- (UIScrollView *)actionBackgroundView {
    if(!_actionBackgroundView) {
        _actionBackgroundView = [[UIScrollView alloc] init];
    }
    return _actionBackgroundView;
}

- (UIView *)actionContainerView {
    if(!_actionContainerView) {
        _actionContainerView = [[UIView alloc] init];
    }
    return _actionContainerView;
}

- (UIView *)titleContainerView {
    if(!_titleContainerView) {
        _titleContainerView = [[UIView alloc] init];
    }
    return _titleContainerView;
}

- (UIImageView *)headImageView {
    if(!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
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

- (UIButton *)liveTimeButton {
    if(!_liveTimeButton) {
        _liveTimeButton = [[UIButton alloc] init];
        [_liveTimeButton setBackgroundImage:[UIImage imageForKey:SG_IMAGE_LIVE_TIME_BG] forState:UIControlStateNormal];
        [_liveTimeButton setTitleColor:[UIColor colorForFontKey:SG_FONT_K] forState:UIControlStateNormal];
        _liveTimeButton.titleLabel.font = [UIFont fontForKey:SG_FONT_K];
        _liveTimeButton.enabled = NO;
        _liveTimeButton.adjustsImageWhenDisabled = NO;
    }
    return _clipDurationButton;
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

- (UIButton *)clipDurationButton {
    if(!_clipDurationButton) {
        _clipDurationButton = [[UIButton alloc] init];
        [_clipDurationButton setBackgroundImage:[UIImage imageForKey:SG_IMAGE_CLIP_DURATION_BG] forState:UIControlStateNormal];
        [_clipDurationButton setTitleColor:[UIColor colorForFontKey:SG_FONT_K] forState:UIControlStateNormal];
        _clipDurationButton.titleLabel.font = [UIFont fontForKey:SG_FONT_K];
        _clipDurationButton.enabled = NO;
        _clipDurationButton.adjustsImageWhenDisabled = NO;
    }
    return _clipDurationButton;
}

- (UIButton *)reportButton {
    if(!_reportButton) {
        _reportButton = [[UIButton alloc] init];
        [_reportButton setTitle:[NSString stringForKey:SG_TEXT_REPORT] forState:UIControlStateNormal];
        [_reportButton setTitleColor:[UIColor colorForFontKey:SG_FONT_I] forState:UIControlStateNormal];
        _reportButton.titleLabel.font = [UIFont fontForKey:SG_FONT_I];
        _reportButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        _reportButton.layer.cornerRadius = 4;
    }
    return _reportButton;
}

- (UIButton *)closeButton {
    if(!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage imageForKey:SG_IMAGE_CLOSE] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (UIView *)chatContainer {
    if(!_chatContainer) {
        _chatContainer = [[UIView alloc] init];
    }
    return _chatContainer;
}

- (UIView *)visitContainer {
    if(!_visitContainer) {
        _visitContainer = [[UIView alloc] init];
    }
    return _visitContainer;
}

- (UILabel *)visitCountLabel {
    if(!_visitCountLabel) {
        _visitCountLabel = [[UILabel alloc] init];
        _visitCountLabel.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        _visitCountLabel.textColor = [UIColor colorForFontKey:SG_FONT_C];
        _visitCountLabel.font = [UIFont fontForKey:SG_FONT_C];
        _visitCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _visitCountLabel;
}

- (UIView *)visitHeadListView {
    if(!_visitHeadListView) {
        _visitHeadListView = [[UIView alloc] init];
    }
    return _visitHeadListView;
}

- (UIButton *)likeButton {
    if(!_likeButton) {
        _likeButton = [[UIButton alloc] init];
        [_likeButton setImage:[UIImage imageForKey:SG_IMAGE_VIDEO_LIKE] forState:UIControlStateNormal];
    }
    return _likeButton;
}

- (UILabel *)likeCountLabel {
    if(!_likeCountLabel) {
        _likeCountLabel = [[UILabel alloc] init];
        _likeCountLabel.font = [UIFont fontForKey:SG_FONT_C];
        _likeCountLabel.textColor = [UIColor colorForFontKey:SG_FONT_C];
    }
    return _likeCountLabel;
}

- (UIView *)publisherContainer {
    if(!_publisherContainer) {
        _publisherContainer = [[UIView alloc] init];
    }
    return _publisherContainer;
}

- (UIButton *)chatButton {
    if(!_chatButton) {
        _chatButton = [[UIButton alloc] init];
        [_chatButton setImage:[UIImage imageForKey:SG_IMAGE_VIDEO_CHAT_BUTTON] forState:UIControlStateNormal];
    }
    return _chatButton;
}

- (UITextView *)chatTextView {
    if(!_chatTextView) {
        _chatTextView = [[UITextView alloc] init];
        _chatTextView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        _chatTextView.layer.cornerRadius = 4;
        _chatTextView.font = [UIFont fontForKey:SG_FONT_D];
        _chatTextView.textColor = [UIColor colorForFontKey:SG_FONT_D];
        _chatTextView.dataDetectorTypes = UIDataDetectorTypeNone;
        _chatTextView.autocorrectionType = UITextAutocorrectionTypeNo;
        _chatTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _chatTextView.spellCheckingType = UITextSpellCheckingTypeNo;
        _chatTextView.returnKeyType = UIReturnKeySend;
        _chatTextView.delegate = self;
    }
    return _chatTextView;
}

- (UIButton *)shareButton {
    if(!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setImage:[UIImage imageForKey:SG_IMAGE_VIDEO_SHARE_BUTTON] forState:UIControlStateNormal];
        _shareButton.layer.cornerRadius = 4;
        _shareButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    }
    return _shareButton;
}

- (ChatMessageDisplayView *)messageDisplayView {
    if(!_messageDisplayView) {
        _messageDisplayView = [[ChatMessageDisplayView alloc] init];
        _messageDisplayView.scrollEnable = NO;
    }
    return _messageDisplayView;
}



@end
