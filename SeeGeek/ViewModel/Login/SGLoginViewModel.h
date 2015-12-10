//
//  SGLoginViewModel.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/6.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGLoginViewModelProtocol.h"
#import "SGViewControllerDispatcherDataSource.h"

@interface SGLoginViewModel : NSObject<SGLoginViewModelProtocol, SGViewControllerDispatcherDataSource>

@end
