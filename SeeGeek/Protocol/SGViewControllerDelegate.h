//
//  SGViewControllerDelegate.h
//  SeeGeek
//
//  Created by 余晨正Alex on 15/11/30.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  视图控制器协议，主要是用来获取传递的viewmodel
 */
@protocol SGViewControllerDelegate <NSObject>

@required

- (void)onViewModelLoaded:(id)viewModel;

@end
