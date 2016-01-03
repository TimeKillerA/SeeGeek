
//
//  SGFocusSettingViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGFocusSettingViewModel.h"
#import "NSString+Resource.h"
#import "SGFansModel.h"

@interface SGFocusSettingViewModel ()

@property (nonatomic, copy)NSString *pageTitle;
@property (nonatomic, assign)SGFocusSettingType focusType;
@property (nonatomic, strong)NSArray *itemList;

@end

@implementation SGFocusSettingViewModel

#pragma mark - life cycle
- (void)dealloc {
    
}

- (instancetype)initWithFocusType:(SGFocusSettingType)type {
    self = [super init];
    if(self) {
        self.focusType = type;
        switch (type) {
            case SGFocusSettingTypeLocation: {
                _pageTitle = [NSString stringForKey:SG_TEXT_FOCUS_LOCATION];
                break;
            }
            case SGFocusSettingTypeFans: {
                _pageTitle = [NSString stringForKey:SG_TEXT_MY_FANS];
                break;
            }
            case SGFocusSettingTypeMyFocus: {
                _pageTitle = [NSString stringForKey:SG_TEXT_MY_FOCUS];
                break;
            }
        }
    }
    return self;
}

#pragma mark - SGFocusSettingViewModelProtocol
/**
 *  页面标题
 *
 *  @return
 */
- (NSString *)pageTitle {
    return _pageTitle;
}

/**
 *  数据列表
 *
 *  @return
 */
- (NSArray *)dataArray {
    return self.itemList;
}

/**
 *  关注或取消关注指定位置的数据
 *
 *  @param focus 是否关注
 *  @param index 位置
 *
 *  @return
 */
- (RACSignal *)signalForFocus:(BOOL)focus atIndex:(NSInteger)index {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

/**
 *  删除粉丝
 *
 *  @param index 位置
 *
 *  @return
 */
- (RACSignal *)signalForRemoveFansAtIndex:(NSInteger)index {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

/**
 *  加入黑名单
 *
 *  @param index 位置
 *
 *  @return
 */
- (RACSignal *)signalForAddToBlackList:(NSInteger)index {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

#pragma mark - SGNetworkRequestProtocol
/**
 *  请求分页加载的列表数据
 *
 *  @param more 是否请求更多数据
 *
 *  @return
 */
- (RACSignal *)signalForLoadMoreData:(BOOL)more {
    WS(weakSelf);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf buildTestData];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGFocusSettingViewController";
}

- (id)viewModelForViewController {
    return self;
}

#pragma mark - test
- (void)buildTestData {
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < 10; i++) {
        SGFansModel *model = [self fanmodelWithName:[NSString stringWithFormat:@"名称%d", i] sign:[NSString stringWithFormat:@"签名%d", i] image:nil focus:i%2];
        [array addObject:model];
    }
    _itemList = array;
}

- (SGFansModel *)fanmodelWithName:(NSString *)name sign:(NSString *)sign image:(NSString *)image focus:(BOOL)focus{
    SGFansModel *model = [[SGFansModel alloc] init];
    model.name = name;
    model.sign = sign;
    model.focus = focus;
    model.headImageUrl = image;
    return model;
}

@end
