//
//  SGTextField.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGTextField.h"
#import <ReactiveCocoa.h>
#import <Masonry.h>
#import <TKRoundedView.h>
#import "UIFont+Resource.h"
#import "UIColor+Resource.h"

#define TITLE_FONT_SIZE    12
#define TITLE_TEXT_COLOR   @"0x666"
#define CONTENT_FONT_SIZE  15
#define CONTENT_TEXT_COLOR @"0x333"
#define BORDER_COLOR       @"0xfff"

@interface SGTextField ()<UITextFieldDelegate>

@property (nonatomic, strong)UIImageView *rightImageView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UITextField *textField;
@property (nonatomic, strong)UIImageView *titleImageView;
@property (nonatomic, strong)TKRoundedView *tkRoundView;

@end

@implementation SGTextField

#pragma mark - life cycle

- (void)dealloc {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self addViews];
        [self addListeners];
        [self setupDefaultProperties];
    }
    return self;
}

#pragma mark - public method
- (void)resignFirstResponder {
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.textField resignFirstResponder];
    });
}

- (void)becomeFirstResponder {
    if(!self.editEnable)
    {
        return;
    }
    WS(weakSelf);
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.textField becomeFirstResponder];
    });
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(self.returnKeyBlock)
    {
        self.returnKeyBlock();
    }
    return YES;
}

#pragma mark - setup
- (void)addViews {
    [self addSubview:self.tkRoundView];
    [self addSubview:self.titleImageView];
    [self addSubview:self.rightImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.rightImageView];
}

- (void)addListeners {
    WS(weakSelf);
    [[[RACObserve(self, titleImage) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.titleImageView.image = x;
    }];
    [[[RACObserve(self, title) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.titleLabel.text = x;
    }];
    [[[RACObserve(self, content) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        if([x isEqualToString:weakSelf.textField.text]) {
            return;
        }
        weakSelf.textField.text = x;
    }];
    [[[RACObserve(self, placeHolder) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.textField.placeholder = x;
    }];
    [[[RACObserve(self, rightImage) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.rightImageView.image = x;
    }];
    [[[RACObserve(self, editEnable) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.textField.enabled = [x boolValue];
    }];
    [[[[RACObserve(self, titleFont) deliverOnMainThread] distinctUntilChanged] filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        weakSelf.titleLabel.font = x;
    }];
    [[[[RACObserve(self, titleColor) deliverOnMainThread] distinctUntilChanged] filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        weakSelf.titleLabel.textColor = x;
    }];
    [[[[RACObserve(self, contentColor) deliverOnMainThread] distinctUntilChanged] filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        weakSelf.textField.textColor = x;
    }];
    [[[[RACObserve(self, contentFont) deliverOnMainThread] distinctUntilChanged] filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        weakSelf.textField.font = x;
    }];
    [[[RACObserve(self, contentTextAlignment) deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        weakSelf.textField.textAlignment = [x integerValue];
    }];
    [[[RACObserve(self, keyboardType) deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        weakSelf.textField.keyboardType = [x integerValue];
    }];
    [[[RACObserve(self, borderSide) deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        weakSelf.tkRoundView.drawnBordersSides = [x integerValue];
    }];
    [[[[RACObserve(self, borderColor) deliverOnMainThread] distinctUntilChanged] filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        weakSelf.tkRoundView.borderColor = x;
    }];
    [[[RACObserve(self, borderWidth) deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        weakSelf.tkRoundView.borderWidth = [x floatValue];
    }];
    [[[RACObserve(self, returnKeyType) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.textField.returnKeyType = [x integerValue];
    }];
    [[[RACObserve(self, securityEdting) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.textField.secureTextEntry = [x boolValue];
    }];
    [[[RACObserve(self, clearMode) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.textField.clearButtonMode = [x integerValue];
    }];
    [[[RACObserve(self, placeHolderAttributedString) deliverOnMainThread] distinctUntilChanged]  subscribeNext:^(id x) {
        weakSelf.textField.attributedPlaceholder = x;
    }];
    [[[[RACObserve(self, backgroundColor) deliverOnMainThread] distinctUntilChanged] filter:^BOOL(id value) {
        return value;
    }] subscribeNext:^(id x) {
        weakSelf.tkRoundView.fillColor = x;
    }];
    [[[[self.textField rac_textSignal] deliverOnMainThread] distinctUntilChanged] subscribeNext:^(id x) {
        if([x isEqualToString:weakSelf.content]) {
            return;
        }
        weakSelf.content = x;
    }];
}

- (void)setupDefaultProperties {
    self.editEnable           = NO;
    self.titleFont            = [UIFont systemFontOfSize:TITLE_FONT_SIZE];
    self.titleColor           = [UIColor colorForARGB:TITLE_TEXT_COLOR];
    self.contentFont          = [UIFont systemFontOfSize:CONTENT_FONT_SIZE];
    self.contentColor         = [UIColor colorForARGB:CONTENT_TEXT_COLOR];
    self.contentTextAlignment = NSTextAlignmentLeft;
    self.keyboardType         = UIKeyboardTypeDefault;
    self.borderSide           = FieldBorderSidesNone;
    self.borderColor          = [UIColor colorForARGB:BORDER_COLOR];
    self.borderWidth          = 1.0/[UIScreen mainScreen].scale;
    self.returnKeyType        = UIReturnKeyDefault;
    self.securityEdting       = NO;
    self.clearMode            = UITextFieldViewModeWhileEditing;
    self.insets               = UIEdgeInsetsMake(0, 10, 0, -10);
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.tkRoundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    CGSize size = [self.title sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    [self.titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = self.titleImage ? self.insets.left : 0;
        make.left.mas_equalTo(self.tkRoundView).offset(offset);
        make.centerY.mas_equalTo(self.tkRoundView);
        make.width.mas_equalTo(self.titleImage.size.width);
        make.height.mas_equalTo(self.titleImage.size.height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat left = self.titleImage ? 10 : self.insets.left;
        CGFloat offset = self.title.length > 0 ? left : 0;
        make.left.mas_equalTo(self.titleImageView.mas_right).offset(offset);
        make.centerY.mas_equalTo(self.tkRoundView);
        make.width.mas_equalTo(size.width + 0.5);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat leftOffset = self.insets.left;
        CGFloat rightOffset = self.rightImage ? -10 : self.insets.right;
        do {
            if(self.title.length > 0) {
                leftOffset = 10;
                break;
            }
            if(self.titleImage) {
                leftOffset = 10;
                break;
            }
        } while (NO);
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(leftOffset);
        make.top.bottom.mas_equalTo(self);
        make.right.mas_equalTo(self.rightImageView.mas_left).offset(rightOffset);
    }];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat offset = self.rightImage ? self.insets.right : 0;
        make.right.mas_equalTo(self.tkRoundView).offset(offset);
        make.centerY.mas_equalTo(self.tkRoundView);
        make.width.mas_equalTo(self.rightImage.size.width);
        make.height.mas_equalTo(self.rightImage.size.height);
    }];
}

#pragma mark - accessory
- (TKRoundedView *)tkRoundView
{
    if(!_tkRoundView)
    {
        _tkRoundView = [[TKRoundedView alloc] init];
        _tkRoundView.roundedCorners = TKRoundedCornerNone;
    }
    return _tkRoundView;
}

- (UIImageView *)titleImageView
{
    if(!_titleImageView)
    {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.backgroundColor = [UIColor clearColor];
    }
    return _titleImageView;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UITextField *)textField
{
    if(!_textField)
    {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor clearColor];
    }
    return _textField;
}

- (UIImageView *)rightImageView
{
    if(!_rightImageView)
    {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.backgroundColor = [UIColor clearColor];
    }
    return _rightImageView;
}

@end
