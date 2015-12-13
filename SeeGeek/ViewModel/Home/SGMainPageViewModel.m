//
//  SGMainPageViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/13.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainPageViewModel.h"
#import <ReactiveCocoa.h>
#import "SGStreamSummaryModel.h"

@interface SGMainPageViewModel ()

@property (nonatomic, strong)NSMutableArray *streamsArray;
@property (nonatomic, strong)NSMutableDictionary *expandDictionary;

@end

@implementation SGMainPageViewModel

#pragma mark - SGMainPageViewModelProtocol
- (NSArray *)streamsArray {
    return _streamsArray;
}

- (RACSignal *)signalForLoadDataWithSection:(NSInteger)section more:(BOOL)more {
    WS(weakSelf);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf buildTestData];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (void)dispatchWithSection:(NSInteger)section index:(NSInteger)index {
    if(section < 0 || section >= [[self streamsArray] count]) {
        return;
    }
    NSDictionary *dictionary = [self.streamsArray objectAtIndex:section];
    NSArray *valus = [[dictionary allValues] objectAtIndex:0];
    if([valus count] <= index) {
        return;
    }
}

- (void)setExpand:(BOOL)expand atSection:(NSInteger)section {
    [self.expandDictionary setValue:[NSNumber numberWithBool:expand] forKey:[NSString stringWithFormat:@"%d", (int)section]];
}

- (BOOL)expandAtSection:(NSInteger)section {
    return [[self.expandDictionary objectForKey:[NSString stringWithFormat:@"%d", (int)section]] boolValue];
}

#pragma mark - private method

#pragma mark - accessory
- (NSMutableDictionary *)expandDictionary {
    if(!_expandDictionary) {
        _expandDictionary = [NSMutableDictionary dictionary];
    }
    return _expandDictionary;
}

#pragma mark - test
- (void)buildTestData {
    NSArray *LIST = @[@"热门", @"关注的人", @"关注的位置", @"关注的兴趣"];
    NSMutableArray *dataArray = [NSMutableArray array];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (int i = 0; i < 20; i++) {
        SGStreamSummaryModel *model = [self modelWithTitle:[NSString stringWithFormat:@"标题%d", i] type:i%2?SGStreamTypeClip:SGStreamTypeLive duration:i%2?i*10:0 image:@"" recommendString:[LIST objectAtIndex:i%4]];
        NSMutableArray *array = [dictionary objectForKey:model.recommendTypeString];
        if(array) {
            [array addObject:model];
        } else {
            array = [NSMutableArray array];
            [array addObject:model];
            [dictionary setValue:array forKey:model.recommendTypeString];
        }
    }
    NSArray *keys = [dictionary allKeys];
    for(NSString *key in keys) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[dictionary objectForKey:key], key, nil];
        [dataArray addObject:dic];
    }
    _streamsArray = dataArray;
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
