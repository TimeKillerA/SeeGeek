//
//  ChatMessageDisplayView.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageDisplayView : UIView

@property (nonatomic, strong)UIColor *nameColor;
@property (nonatomic, strong)UIFont *nameFont;
@property (nonatomic, strong)UIColor *messageColor;
@property (nonatomic, strong)UIFont *messageFont;
@property (nonatomic, assign)BOOL scrollEnable;

- (void)addMessage:(NSString *)message userName:(NSString *)userName;

@end
