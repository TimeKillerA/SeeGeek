//
//  SGPersonLocationSettingViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGPersonLocationSettingViewModelProtocol.h"
#import "SGViewControllerDispatcherDataSource.h"

typedef NS_ENUM(NSInteger, SGPersonLocationType) {
    SGPersonLocationTypeHome,
    SGPersonLocationTypeWorkspace,
};

@interface SGPersonLocationSettingViewModel : NSObject<SGPersonLocationSettingViewModelProtocol, SGViewControllerDispatcherDataSource>

- (instancetype)initWithLocationType:(SGPersonLocationType)type;

@end
