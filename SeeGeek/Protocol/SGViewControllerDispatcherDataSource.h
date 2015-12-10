//
//  SGViewControllerDispatcherDataSource.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SGViewControllerType) {
    SGViewControllerTypeNavigationChild = 0,
    SGViewControllerTypeNavigationRoot,
    SGViewControllerTypeWindowRoot,
    SGViewControllerTypeModel,
};

/**
 *  页面跳转协议数据源,需要使用SGViewControllerDispatcher来管理跳转的viewmodel需要实现此协议
 */
@protocol SGViewControllerDispatcherDataSource <NSObject>

@required
/**
 *  返回页面的类名，通过反射的方式实例化视图
 *
 *  @return 视图控制器的类名
 */
- (NSString *)classNameForViewController;

/**
 *  交给viewcontroller的viewmodel
 *
 *  @return 
 */
- (id)viewModelForViewController;

@optional
/**
 *  设置初始的参数
 *
 *  @param params 初始参数
 */
- (void)setInitParams:(NSDictionary *)params;

/**
 *  是否需要展示动画
 *
 *  @return
 */
- (BOOL)shouldShowAnimation;

/**
 *  是否是RootViewController
 *
 *  @return
 */
- (SGViewControllerType)viewControllerType;

@end
