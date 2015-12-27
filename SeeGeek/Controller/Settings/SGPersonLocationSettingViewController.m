//
//  SGPersonLocationSettingViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGPersonLocationSettingViewController.h"
#import "SGViewControllerDelegate.h"
#import "SGViewControllerHeader.h"
#import "SGViewControllerDelegate.h"
#import "SGPersonLocationSettingViewModelProtocol.h"

@interface SGPersonLocationSettingViewController ()<SGViewControllerDelegate>

@property (nonatomic, strong)id<SGPersonLocationSettingViewModelProtocol> viewModel;

@end

@implementation SGPersonLocationSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}


@end
