//
//  SGFocusSettingViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGFocusSettingViewModelProtocol.h"
#import "SGViewControllerDispatcherDataSource.h"

typedef NS_ENUM(NSInteger, SGFocusSettingType) {
    SGFocusSettingTypeLocation,         // 关注的位置
    SGFocusSettingTypeFans,             // 粉丝
    SGFocusSettingTypeMyFocus,          // 我的关注
};

@interface SGFocusSettingViewModel : NSObject<SGFocusSettingViewModelProtocol, SGViewControllerDispatcherDataSource>

- (instancetype)initWithFocusType:(SGFocusSettingType)type;

@end
