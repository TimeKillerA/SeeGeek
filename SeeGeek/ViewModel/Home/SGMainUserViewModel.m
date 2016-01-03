//
//  SGMainUserViewModel.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/23.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainUserViewModel.h"
#import <ReactiveCocoa.h>
#import "SGUserSummaryModel.h"
#import "SGStreamSummaryWithCommentModel.h"
#import "SGCommentModel.h"
#import "SGPersonnalSettingsViewModel.h"
#import "SGViewControllerDispatcher.h"

@interface SGMainUserViewModel ()

@property (nonatomic, assign)NSInteger publishCount;
@property (nonatomic, assign)NSInteger focusCount;
@property (nonatomic, assign)NSInteger fansCount;

@property (nonatomic, strong)SGUserSummaryModel *userModel;
@property (nonatomic, strong)NSArray *streamArray;

@end

@implementation SGMainUserViewModel

#pragma mark - SGMainUserViewModelProtocol
/**
 *  发布视频的数量
 *
 *  @return
 */
- (NSInteger)countForPublish {
    return self.publishCount;
}

/**
 *  关注的数量
 *
 *  @return
 */
- (NSInteger)countForFocus {
    return self.focusCount;
}

/**
 *  粉丝数量
 *
 *  @return
 */
- (NSInteger)countForFans {
    return self.fansCount;
}

/**
 *  用户签名
 *
 *  @return
 */
- (NSString *)userSign {
    return self.userModel.userSign;
}

/**
 *  用户头像
 *
 *  @return
 */
- (NSString *)userHeadImage {
    return self.userModel.userImageUrl;
}

/**
 *  用户名称
 *
 *  @return
 */
- (NSString *)userName {
    return self.userModel.userName;
}

/**
 *  请求到的视频流列表
 *
 *  @return
 */
- (NSArray *)streams {
    return self.streamArray;
}

/**
 *  加载数据数量，发布数、关注数、粉丝数
 *
 *  @return
 */
- (RACSignal *)signalForLoadCountData {
    WS(weakSelf);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf buildCountData];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

/**
 *  加载用户数据，头像、名称、个性签名等
 *
 *  @return
 */
- (RACSignal *)signalForLoadUserData {
    WS(weakSelf);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [weakSelf buildUserData];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

/**
 *  加载发布的流信息
 *
 *  @param more 是否加载更多
 *
 *  @return
 */
- (RACSignal *)signalForLoadStreamData:(BOOL)more {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self buildStreamData];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
    }];
}

/**
 *  进入系统设置
 */
- (void)dispatchToSystemSettings {

}

/**
 *  进入个人设置
 */
- (void)dispatchToPersonnalSettings {
    SGPersonnalSettingsViewModel *viewModel = [[SGPersonnalSettingsViewModel alloc] init];
    [SGViewControllerDispatcher dispatchToViewControllerWithViewControllerDispatcherDataSource:viewModel];
}

#pragma mark - test
- (void)buildCountData {
    self.publishCount = 10;
    self.focusCount = 100;
    self.fansCount = 0;
}

- (void)buildUserData {
    self.userModel = [[SGUserSummaryModel alloc] init];
    self.userModel.userSign = @"签名签名签名签名签名签名签名签名签名签名签名签名签名签名签名";
    self.userModel.userName = @"名称";
    self.userModel.userImageUrl = @"";
}

- (void)buildStreamData {
    SGStreamSummaryWithCommentModel *summaryModel = [[SGStreamSummaryWithCommentModel alloc] init];
    summaryModel.commentNumber = 100;
    summaryModel.likeNumber = 100;
    summaryModel.streamTag = @"#标签#";
    summaryModel.location = @"地点";
    summaryModel.streamTitle = @"标题";
    summaryModel.snapshotUrl = @"";

    SGUserSummaryModel *fromUser = [[SGUserSummaryModel alloc] init];
    fromUser.userName = @"啊啊啊啊";

    SGUserSummaryModel *toUser = [[SGUserSummaryModel alloc] init];
    toUser.userName = @"各位各位";

    SGCommentModel *commentModel1 = [[SGCommentModel alloc] init];
    commentModel1.fromUser = fromUser;
    commentModel1.content = @"评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111评论内容评论内容评论内容评论内容1111";

    SGCommentModel *commentModel2 = [[SGCommentModel alloc] init];
    commentModel2.fromUser = fromUser;
    commentModel2.content = @"评论内容评论内容评论内容评论内容22222";

    SGCommentModel *commentModel3 = [[SGCommentModel alloc] init];
    commentModel3.fromUser = fromUser;
    commentModel3.content = @"评论内容评论内容评论内容评论内容3333333";

    summaryModel.commentList = @[commentModel1, commentModel2, commentModel3];



    SGStreamSummaryWithCommentModel *summaryModel1 = [[SGStreamSummaryWithCommentModel alloc] init];
    summaryModel1.commentNumber = 100;
    summaryModel1.likeNumber = 100;
    summaryModel1.streamTag = @"#标签#";
    summaryModel1.location = @"地点";
    summaryModel1.streamTitle = @"标题";
    summaryModel1.snapshotUrl = @"";

    SGUserSummaryModel *fromUser1 = [[SGUserSummaryModel alloc] init];
    fromUser1.userName = @"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊";

    SGUserSummaryModel *toUser1 = [[SGUserSummaryModel alloc] init];
    toUser1.userName = @"各位各位";

    SGCommentModel *commentModel4 = [[SGCommentModel alloc] init];
    commentModel4.fromUser = fromUser1;
    commentModel4.content = @"评论内容评论内容评论内容评论内容1111";

    SGCommentModel *commentModel5 = [[SGCommentModel alloc] init];
    commentModel5.fromUser = fromUser1;
    commentModel5.content = @"评论内容评论内容评论内容评论内容22222";

    SGCommentModel *commentModel6 = [[SGCommentModel alloc] init];
    commentModel6.fromUser = fromUser1;
    commentModel6.content = @"评论内容评论内容评论内容评论内容3333333";

    summaryModel1.commentList = @[commentModel4, commentModel5, commentModel6];

    self.streamArray = @[summaryModel, summaryModel1];
}




@end
