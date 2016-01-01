
//
//  SGVideoViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/1.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGVideoViewModel.h"
#import "SGStreamSummaryModel.h"
#import <ReactiveCocoa.h>

@interface SGVideoViewModel ()

@property (nonatomic, strong)SGStreamSummaryModel *streamSummaryModel;
@property (nonatomic, copy)NSString *videoPlayUrl;
@property (nonatomic, copy)NSString *videoPublishUrl;
@property (nonatomic, assign)NSInteger playTimeInSeconds;

@end

@implementation SGVideoViewModel

#pragma mark - life cycle
- (void)dealloc {
    
}

- (instancetype)initWithStreamSummaryModel:(SGStreamSummaryModel *)streamSummary {
    self = [self init];
    if(self) {
        self.streamSummaryModel = streamSummary;
    }
    return self;
}

#pragma mark - SGVideoViewModelProtocol
- (SGStreamType)streamType {
    return self.streamSummaryModel.streamType;
}

- (BOOL)isVideoPublisher {
    return self.streamSummaryModel == nil;
}

- (NSString *)playUrl {
    return self.videoPlayUrl;
}

- (NSString *)publishUrl {
    return self.videoPublishUrl;
}

- (RACSignal *)signalForPlayTimeChanged {
    return RACObserve(self, playTimeInSeconds);
}

- (RACSignal *)signalForReport {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (RACSignal *)signalForLike {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (RACSignal *)signalForSendComment:(NSString *)comment {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (RACSignal *)signalForShareWithType:(SGThirdPartType)shareType {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (RACSignal *)signalForLoadUserDataWithId:(SGIDInteger)userId {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (RACSignal *)signalForFocusUserWithId:(SGIDInteger)userId focus:(BOOL)focus {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (RACSignal *)signalForFocusPlaceLongitude:(double)longitude lantitude:(double)lantitude focus:(BOOL)focus {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

- (RACSignal *)signalForUploadVideoFile:(NSString *)videoFilePath {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        return nil;
    }];
}

#pragma mark - SGViewControllerDispatcherDataSource
- (NSString *)classNameForViewController {
    return @"SGVideoViewController";
}

- (id)viewModelForViewController {
    return self;
}

- (SGViewControllerType)viewControllerType {
    return SGViewControllerTypeModel;
}

@end
