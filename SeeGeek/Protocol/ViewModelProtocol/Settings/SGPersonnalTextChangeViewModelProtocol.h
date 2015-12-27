//
//  SGPersonnalTextChangeViewModelProtocol.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;

@protocol SGPersonnalTextChangeViewModelProtocol <NSObject>

/**
 *  页面标题
 *
 *  @return
 */
- (NSString *)pageTitle;

/**
 *  当前的文本值
 *
 *  @return
 */
- (NSString *)currentText;

/**
 *  提交
 *
 *  @param text 修改后的值
 *
 *  @return
 */
- (RACSignal *)signalForSubmitWithText:(NSString *)text;

@end
