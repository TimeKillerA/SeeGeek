//
//  SGTextField.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SGTextFieldReturnKeyBlock)();

typedef NS_OPTIONS(NSInteger, FieldBorderSide) {
    FieldBorderSidesNone      = 0,
    FieldBorderSidesRight     = 1 <<  0,
    FieldBorderSidesLeft      = 1 <<  1,
    FieldBorderSidesTop       = 1 <<  2,
    FieldBorderSidesBottom    = 1 <<  3,
};

@interface SGTextField : UIView

/**
 *  左侧标题区域图像，如果标题图像和标题文字同时存在，标题图像在文字左侧
 */
@property (nonatomic, strong) UIImage                   *titleImage;

/**
 *  文本框标题
 */
@property (nonatomic, copy  ) NSString                  *title;

/**
 *  文本框内容
 */
@property (nonatomic, copy  ) NSString                  *content;

/**
 *  文本框提示文本
 */
@property (nonatomic, copy  ) NSString                  *placeHolder;

/**
 *  右侧图像
 */
@property (nonatomic, strong) UIImage                   *rightImage;

/**
 *  是否可编辑，默认不可编辑
 */
@property (nonatomic, assign) BOOL                      editEnable;

/**
 *  标题部分文字字体，默认字体，24px
 */
@property (nonatomic, strong) UIFont                    *titleFont;

/**
 *  标题部分文字颜色，默认颜色#666
 */
@property (nonatomic, strong) UIColor                   *titleColor;

/**
 *  内容部分文字字体，默认字体，30px
 */
@property (nonatomic, strong) UIFont                    *contentFont;

/**
 *  内容部分文字颜色，默认颜色#333
 */
@property (nonatomic, strong) UIColor                   *contentColor;

/**
 *  内容部分对齐方式，默认居左
 */
@property (nonatomic, assign) NSTextAlignment           contentTextAlignment;

/**
 *  键盘类型，默认UIKeyboardTypeDefault
 */
@property (nonatomic, assign) UIKeyboardType            keyboardType;

/**
 *  边框类型，默认无边框FieldBorderSidesNone
 */
@property (nonatomic, assign) FieldBorderSide           borderSide;

/**
 *  圆角半径
 */
@property (nonatomic, assign) CGFloat                   cornerRadius;

/**
 *  边框颜色，默认0xfff
 */
@property (nonatomic, strong) UIColor                   *borderColor;

/**
 *  边框宽度，默认1px
 */
@property (nonatomic, assign) CGFloat                   borderWidth;

/**
 *  返回按钮类型，默认UIReturnKeyDefault
 */
@property (nonatomic, assign) UIReturnKeyType           returnKeyType;

/**
 *  是否是密码输入，默认NO
 */
@property (nonatomic, assign) BOOL                      securityEdting;

/**
 *  文本清除类型，默认UITextFieldViewModeWhileEditing
 */
@property (nonatomic, assign) UITextFieldViewMode       clearMode;

/**
 *  内边距，默认(0, 10, 0, -10)
 */
@property (nonatomic, assign) UIEdgeInsets              insets;
@property (nonatomic, strong) NSAttributedString        *placeHolderAttributedString;
@property (nonatomic, copy  ) SGTextFieldReturnKeyBlock returnKeyBlock;

/**
 *  填充色
 */
@property (nonnull, strong  ) UIColor                   *fillColor;

- (void)resignFirstResponder;
- (void)becomeFirstResponder;

@end
