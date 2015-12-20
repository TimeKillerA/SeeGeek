//
//  SGMainFindViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/20.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainFindViewModel.h"
#import "SGStreamSummaryModel.h"
#import <ReactiveCocoa.h>
#import "SGViewControllerDispatcher.h"

@interface SGMainFindViewModel ()

@property (nonatomic, strong)NSArray *itemList;
@property (nonatomic, assign)NSInteger timeInterval;

@end

@implementation SGMainFindViewModel

#pragma mark - SGMainFindViewModelProtocol
- (NSArray *)currentDataArray {
    return _itemList;
}

- (NSInteger)timeIntervalFromLastAction {
    return _timeInterval;
}

- (void)dispatchToNextAtIndex:(NSInteger)index {

}

#pragma mark - SGNetworkRequestProtocol
- (RACSignal *)signalForLoadMoreData:(BOOL)more {
    WS(weakSelf);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf buildTestData];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

#pragma mark - test
- (void)buildTestData {
    static NSInteger tag = 1;
    if(tag % 2) {
        _timeInterval = 10 * tag;
    } else {
        NSMutableArray *array = [NSMutableArray array];
        for(int i = 0; i < 10; i++) {
            SGStreamSummaryModel *model = [self modelWithTitle:[NSString stringWithFormat:@"标题%d", i] type:i%2?SGStreamTypeClip:SGStreamTypeLive duration:i*10 image:nil recommendString:nil];
            model.likeNumber = 1000;
            model.commentNumber = 2000;
            model.streamTag = [NSString stringWithFormat:@"#标签%d#", i];
            model.location = [NSString stringWithFormat:@"#地址%d#", i];
            [array addObject:model];
        }
        _itemList = array;
    }
    tag++;
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
