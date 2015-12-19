//
//  SGMainLocationViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/19.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainLocationViewModel.h"
#import <ReactiveCocoa.h>
#import "SGVideoLocationModel.h"
#import "SGStreamSummaryModel.h"

@interface SGMainLocationViewModel ()

@property (nonatomic, strong)NSArray *originLocationArray;
@property (nonatomic, strong)NSMutableDictionary *summaryCache;

@end

@implementation SGMainLocationViewModel

#pragma mark - SGMainLocationViewModelProtocol
- (NSArray *)streamLocationArray {
    return self.originLocationArray;
}

- (NSArray *)streamSummaryArrayForLocation:(SGVideoLocationModel *)model {
    return [self.summaryCache objectForKey:[self cacheKeyForLocationModel:model]];
}

- (RACSignal *)signalForLoadLocationData {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self buildLocationTestData];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)signalForLoadStreamDataWithLocation:(SGVideoLocationModel *)model
                                              more:(BOOL)more {
    __weak typeof(model) weakModel = model;
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self buildSummaryData:weakModel];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)signalForSearchWithKeyWorld:(NSString *)keyworld {
    return nil;
}

- (RACSignal *)signalForFocusLocation:(SGVideoLocationModel *)model {
    return nil;
}

#pragma mark - private method
- (NSString *)cacheKeyForLocationModel:(SGVideoLocationModel *)model {
    NSString *key = [NSString stringWithFormat:@"%f_%f", model.lantitude, model.longitude];
    return key;
}

#pragma mark - accessory
- (NSMutableDictionary *)summaryCache {
    if(!_summaryCache) {
        _summaryCache = [NSMutableDictionary dictionary];
    }
    return _summaryCache;
}

#pragma mark - test
- (void)buildLocationTestData {
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < 10; i++) {
        SGVideoLocationModel *model = [self locationModelWithLantitude:0+i*4 longitude:90+i*4 type:i%2?SGStreamTypeClip:SGStreamTypeLive count:20 location:[NSString stringWithFormat:@"地址%d", i]];
        [array addObject:model];
    }
    self.originLocationArray = array;
}

- (SGVideoLocationModel *)locationModelWithLantitude:(double)lantitude longitude:(double)longitude type:(SGStreamType)type count:(NSInteger)count location:(NSString *)location {
    SGVideoLocationModel *model = [[SGVideoLocationModel alloc] init];
    model.lantitude = lantitude;
    model.longitude = longitude;
    model.streamType = type;
    model.count = count;
    model.location = location;
    return model;
}

- (void)buildSummaryData:(SGVideoLocationModel *)model {
    NSMutableArray *array = [NSMutableArray array];
    for(int i = 0; i < 10; i++) {
        SGStreamSummaryModel *model = [self modelWithTitle:[NSString stringWithFormat:@"标题%d", i] type:i%2?SGStreamTypeClip:SGStreamTypeLive duration:i*10 image:nil recommendString:nil];
        model.likeNumber = 1000;
        model.commentNumber = 2000;
        model.streamTag = [NSString stringWithFormat:@"#标签%d#", i];
        model.location = [NSString stringWithFormat:@"#地址%d#", i];
        [array addObject:model];
    }
    NSString *key = [self cacheKeyForLocationModel:model];
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:array];
    [self.summaryCache setObject:dataArray forKey:key];
}

- (SGStreamSummaryModel *)modelWithTitle:(NSString *)title type:(SGStreamType)type duration:(NSInteger)duration image:(NSString *)image recommendString:(NSString *)recommend {
    SGStreamSummaryModel *model = [[SGStreamSummaryModel alloc] init];
    model.streamTitle = title;
    model.streamType = type;
    model.duration = duration;
    model.snapshotUrl = image;
    model.recommendTypeString = recommend;
    return model;
}

@end
