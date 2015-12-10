//
//  SGLanchViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLaunchViewModelProtocol.h"
#import "SGViewControllerDispatcherDataSource.h"

@interface SGLanchViewModel : NSObject<SGLaunchViewModelProtocol, SGViewControllerDispatcherDataSource>

@end
