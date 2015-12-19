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

@property (nonatomic, strong)NSArray *streamsArray;
@property (nonatomic, strong)NSMutableDictionary *expandDictionary;
@property (nonatomic, strong)NSMutableArray *originStreamArray;

@end

@implementation SGMainPageViewModel

#pragma mark - SGMainPageViewModelProtocol
- (NSArray *)streamsArray {
    return _streamsArray;
}

- (RACSignal *)signalForLoadDataWithSection:(NSInteger)section more:(BOOL)more {
    WS(weakSelf);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf buildTestDataAtSection:section more:more];
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

- (BOOL)canExpandAtSection:(NSInteger)section {
    if(section >= [self.originStreamArray count]) {
        return NO;
    }
    NSDictionary *dictionary = [self.originStreamArray objectAtIndex:section];
    int total = [[dictionary objectForKey:@"total"] intValue];
    return total > 1;
}

- (NSInteger)totalCountAtSection:(NSInteger)section; {
    if(section >= [self.originStreamArray count]) {
        return 0;
    }
    NSDictionary *dictionary = [self.originStreamArray objectAtIndex:section];
    int total = [[dictionary objectForKey:@"total"] intValue];
    return total;
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
- (void)buildTestDataAtSection:(NSInteger)section more:(BOOL)more {
    if(section < 0) {
        [self initTestData];
    } else if(section < [self.originStreamArray count]){
        NSDictionary *dictionary = [self.originStreamArray objectAtIndex:section];
        NSArray *originData = [dictionary objectForKey:@"data"];
        if(more) {
            NSMutableDictionary *streamDictionary = [self.streamsArray objectAtIndex:section];
            NSArray *data = [[streamDictionary allValues] objectAtIndex:0];
            NSArray *tempData = nil;
            if([originData count] > [data count] + 3) {
                tempData = [originData subarrayWithRange:NSMakeRange(0, [data count] + 3)];
            } else {
                tempData = [NSArray arrayWithArray:originData];
            }
            [streamDictionary setValue:tempData forKey:[[streamDictionary allKeys] objectAtIndex:0]];
        } else {
            [self initTestStreamArray];
        }
    }
}

- (void)initTestData {
    NSArray *LIST = @[@"热门", @"关注的人", @"关注的位置", @"关注的兴趣"];

    // 空
    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
    NSMutableArray *array1 = [NSMutableArray array];
    [dictionary1 setValue:[NSNumber numberWithInt:0] forKey:@"total"];
    [dictionary1 setValue:[LIST objectAtIndex:0] forKey:@"title"];
    [dictionary1 setValue:array1 forKey:@"data"];

    // 只有一条数据，不能展开
    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionary];
    NSMutableArray *array2 = [NSMutableArray array];
    [dictionary2 setValue:[NSNumber numberWithInt:1] forKey:@"total"];
    [dictionary2 setValue:[LIST objectAtIndex:1] forKey:@"title"];
    [dictionary2 setValue:array2 forKey:@"data"];

    // 有多条数据，可以展开，但不能加载更多
    NSMutableDictionary *dictionary3 = [NSMutableDictionary dictionary];
    NSMutableArray *array3 = [NSMutableArray array];
    [dictionary3 setValue:[NSNumber numberWithInt:3] forKey:@"total"];
    [dictionary3 setValue:[LIST objectAtIndex:2] forKey:@"title"];
    [dictionary3 setValue:array3 forKey:@"data"];

    // 有多条数据，可以展开，可以加载更多
    NSMutableDictionary *dictionary4 = [NSMutableDictionary dictionary];
    NSMutableArray *array4 = [NSMutableArray array];
    [dictionary4 setValue:[NSNumber numberWithInt:10] forKey:@"total"];
    [dictionary4 setValue:[LIST objectAtIndex:3] forKey:@"title"];
    [dictionary4 setValue:array4 forKey:@"data"];

    [self buildArray:array1 total:0];
    [self buildArray:array2 total:1];
    [self buildArray:array3 total:3];
    [self buildArray:array4 total:10];

    self.originStreamArray = [NSMutableArray array];
    [self.originStreamArray addObject:dictionary1];
    [self.originStreamArray addObject:dictionary2];
    [self.originStreamArray addObject:dictionary3];
    [self.originStreamArray addObject:dictionary4];

    [self initTestStreamArray];
}

- (void)initTestStreamArray {
    NSMutableArray *array = [NSMutableArray array];
    for(NSDictionary *dictionary in self.originStreamArray) {
        NSArray *dataArray = [dictionary objectForKey:@"data"];
        NSString *title = [dictionary objectForKey:@"title"];
        NSMutableDictionary *streamDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dataArray subarrayWithRange:NSMakeRange(0, 1)], title, nil];
        [array addObject:streamDictionary];
    }
    self.streamsArray = array;
}

- (void)buildArray:(NSMutableArray *)array total:(NSInteger)total {
    if(total <= 0) {
        SGStreamSummaryModel *model = [self modelWithTitle:nil type:SGStreamTypeNone duration:0 image:nil recommendString:nil];
        [array addObject:model];
        return;
    }
    for(int i = 0; i < total; i++) {
        SGStreamSummaryModel *model = [self modelWithTitle:[NSString stringWithFormat:@"标题%d", i] type:i%2?SGStreamTypeClip:SGStreamTypeLive duration:i*10 image:nil recommendString:nil];
        model.likeNumber = 1000;
        model.commentNumber = 2000;
        model.streamTag = [NSString stringWithFormat:@"#标签%d#", i];
        model.location = [NSString stringWithFormat:@"#地址%d#", i];
        [array addObject:model];
    }
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
