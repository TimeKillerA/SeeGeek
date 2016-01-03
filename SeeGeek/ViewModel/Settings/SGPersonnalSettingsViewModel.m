//
//  SGPersonnalSettingsViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGPersonnalSettingsViewModel.h"
#import "SGPersonnalSettingsModel.h"
#import "NSString+Resource.h"
#import "SGViewControllerDispatcher.h"
#import "SGPersonnalTextChangeViewModel.h"
#import "SGPersonLocationSettingViewModel.h"
#import "SGFocusSettingViewModel.h"

@interface SGPersonnalSettingsViewModel ()

@property (nonatomic, strong)NSArray *itemList;

@end

@implementation SGPersonnalSettingsViewModel

- (instancetype)init {
    self = [super init];
    if(self) {
        [self setupData];
    }
    return self;
}

#pragma mark - SGPersonnalSettingsViewModelProtocol
- (NSArray *)personnalSettingsItemList {
    return self.itemList;
}

- (void)dispatchToPersonnalSettingsItem:(SGPersonnalSettingsModel *)item {
    NSInteger index = [self.itemList indexOfObject:item];
    switch (index) {
        case 0:{
            // 修改头像
            break;
        }
        case 1: {
            // 修改昵称
            SGPersonnalTextChangeViewModel *viewModel = [[SGPersonnalTextChangeViewModel alloc] initWithTextType:SGPersonnalTextTypeName];
            [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
            break;
        }
        case 2: {
            // 修改兴趣
            break;
        }
        case 3: {
            // 修改关注地理位置
            SGFocusSettingViewModel *viewModel = [[SGFocusSettingViewModel alloc] initWithFocusType:SGFocusSettingTypeLocation];
            [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
            break;
        }
        case 4: {
            // 修改性别
            break;
        }
        case 5: {
            // 修改签名
            SGPersonnalTextChangeViewModel *viewModel = [[SGPersonnalTextChangeViewModel alloc] initWithTextType:SGPersonnalTextTypeSign];
            [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
            break;
        }
        case 6: {
            // 修改家庭地址
            SGPersonLocationSettingViewModel *viewModel = [[SGPersonLocationSettingViewModel alloc] initWithLocationType:SGPersonLocationTypeHome];
            [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
            break;
        }
        case 7: {
            // 修改工作地址
            SGPersonLocationSettingViewModel *viewModel = [[SGPersonLocationSettingViewModel alloc] initWithLocationType:SGPersonLocationTypeWorkspace];
            [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
            break;
        }
        default:
            break;
    }
}

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGPersonnalSettingsViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeNavigationChild;
}

#pragma mark - private method
- (void)setupData {
    // 头像
    SGPersonnalSettingsImageModel *imageModel = [self imageModelWithTitle:nil imageUrl:nil image:nil];

    // 昵称
    SGPersonnalSettingsTextModel *nickModel = [self textModelWithTitle:[NSString stringForKey:SG_TEXT_NICK_NAME] content:nil];

    // 兴趣
    SGPersonnalSettingsTextModel *hobbyModel = [self textModelWithTitle:[NSString stringForKey:SG_TEXT_HOBBIES] content:nil];

    // 关注位置
    SGPersonnalSettingsTextModel *locationModel = [self textModelWithTitle:[NSString stringForKey:SG_TEXT_FOCUS_LOCATION] content:nil];

    // 性别
    SGPersonnalSettingsTextModel *genderModel = [self textModelWithTitle:[NSString stringForKey:SG_TEXT_GENDER] content:nil];

    // 个性签名
    SGPersonnalSettingsTextModel *signModel = [self textModelWithTitle:[NSString stringForKey:SG_TEXT_PERSONNAL_SIGN] content:nil];

    // 家庭地址
    SGPersonnalSettingsTextModel *homeModel = [self textModelWithTitle:[NSString stringForKey:SG_TEXT_HOME_ADDRESS] content:nil];

    // 工作地址
    SGPersonnalSettingsTextModel *workModel = [self textModelWithTitle:[NSString stringForKey:SG_TEXT_WORK_ADDRESS] content:nil];

    self.itemList = @[imageModel, nickModel, hobbyModel, locationModel, genderModel, signModel, homeModel, workModel];
}

- (SGPersonnalSettingsImageModel *)imageModelWithTitle:(NSString *)title imageUrl:(NSString *)imageUrl image:(UIImage *)image {
    SGPersonnalSettingsImageModel *model = [[SGPersonnalSettingsImageModel alloc] init];
    model.title = title;
    model.imageUrl = imageUrl;
    model.image = image;
    return model;
}

- (SGPersonnalSettingsTextModel *)textModelWithTitle:(NSString *)title content:(NSString *)content {
    SGPersonnalSettingsTextModel *model = [[SGPersonnalSettingsTextModel alloc] init];
    model.title = title;
    model.content = content;
    return model;
}

@end
