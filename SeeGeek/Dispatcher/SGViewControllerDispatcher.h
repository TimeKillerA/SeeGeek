//
//  SGViewControllerDispatcher.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SGViewControllerDispatcherDataSource.h"

@interface SGViewControllerDispatcher : NSObject

/**
 *  跳转到目的ViewController
 *
 *  @param dataSource
 */
+ (void)dispatchToViewControllerWithViewControllerDispatcherDataSource:(id<SGViewControllerDispatcherDataSource>)dataSource;

@end
