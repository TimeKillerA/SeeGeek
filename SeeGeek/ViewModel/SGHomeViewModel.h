//
//  SGHomeViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGViewControllerDispatcherDataSource.h"
#import "SGHomeViewModelProtocol.h"

@interface SGHomeViewModel : NSObject<SGViewControllerDispatcherDataSource, SGHomeViewModelProtocol>

@end
