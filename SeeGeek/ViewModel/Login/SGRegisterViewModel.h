//
//  SGRegisterViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/7.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGViewControllerDispatcherDataSource.h"
#import "SGRegisterViewModelDelegate.h"

@interface SGRegisterViewModel : NSObject<SGViewControllerDispatcherDataSource, SGRegisterViewModelDelegate>

@end
