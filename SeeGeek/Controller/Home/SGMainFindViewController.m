//
//  SGMainFindViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainFindViewController.h"
#import "SGMainFindViewModelProtocol.h"
#import "SGStreamSummaryModel.h"
#import "SGStreamSummaryCell.h"
#import <MJRefresh.h>
#import "SGTableDataSource.h"
#import <MSWeakTimer.h>
#import "SGViewControllerHeader.h"
#import "NSString+Time.h"

@interface SGMainFindViewController ()<UITableViewDelegate>

@property (nonatomic, strong)id<SGMainFindViewModelProtocol> viewModel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UIView *containerView;
@property (nonatomic, strong)UIImageView *logoImageView;
@property (nonatomic, strong)UILabel *timeDescriptionLabel;
@property (nonatomic, strong)UILabel *timeIntervalLabel;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)SGTableDataSource *dataSource;
@property (nonatomic, strong)MSWeakTimer *weakTimer;
@property (nonatomic, assign)long long timerStartTime;

@end

@implementation SGMainFindViewController

- (void)dealloc {
    [self stopTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.logoImageView];
    [self.containerView addSubview:self.timeDescriptionLabel];
    [self.containerView addSubview:self.timeIntervalLabel];
    [self.view addSubview:self.tableView];
    [self showNavigationBarWithTitle:[NSString stringForKey:SG_TEXT_FIND] right:nil rightAction:nil left:nil leftAction:nil];
    [self updateConstraints];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.scrollView).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, TAB_BAR_HEIGHT, 0));
        make.width.mas_equalTo(self.scrollView);
        make.height.mas_equalTo(SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - TAB_BAR_HEIGHT + 1);
    }];
    [self.logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.containerView).offset(60);
    }];
    [self.timeDescriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.logoImageView.mas_bottom).offset(20);
    }];
    [self.timeIntervalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.timeDescriptionLabel.mas_bottom).offset(10);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, TAB_BAR_HEIGHT, 0));
    }];
}

- (void)updateContentViewVisibility {
    NSArray *dataArray = [self.viewModel currentDataArray];
    if([dataArray count] == 0 && [self.viewModel timeIntervalFromLastAction] > 0) {
        self.tableView.hidden = YES;
        self.scrollView.hidden = NO;
        [self startTimer];
    } else {
        self.tableView.hidden = NO;
        self.scrollView.hidden = YES;
        [self stopTimer];
        SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[dataArray count]];
        self.dataSource.sectionList = @[item];
        [self.tableView reloadData];
    }
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - config cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"find_summary_cell";
    SGStreamSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(!cell) {
        cell = [[SGStreamSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    SGStreamSummaryModel *model = [[self.viewModel currentDataArray] objectAtIndex:indexPath.row];
    cell.summaryModel = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.viewModel dispatchToNextAtIndex:indexPath.row];
}

#pragma mark - timer
- (void)startTimer {
    [self stopTimer];
    self.weakTimer = [MSWeakTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerUpdateMethod) userInfo:nil repeats:YES dispatchQueue:dispatch_get_global_queue(0, 0)];
    self.timerStartTime = [[NSDate date] timeIntervalSince1970] * 1000;
}

- (void)stopTimer {
    if(self.weakTimer) {
        [self.weakTimer invalidate];
        self.weakTimer = nil;
    }
}

- (void)timerUpdateMethod {
    WS(weakSelf);
    long long now = [[NSDate date] timeIntervalSince1970] * 1000;
    long long delta = (now - self.timerStartTime)/1000 + [self.viewModel timeIntervalFromLastAction];
    NSString *timeString = [NSString HMSStringFromSeconds:delta];
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.timeIntervalLabel.text = timeString;
    });
}

#pragma mark - load data
- (void)loadData:(BOOL)more {
    WS(weakSelf);
    [self showDefaultProgressHUD];
    [[[self.viewModel signalForLoadMoreData:more] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{
        [weakSelf updateContentViewVisibility];
    }];
}

#pragma mark - accessory
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        WS(weakSelf);
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor colorForKey:SG_COLOR_CONTROLLER_GRAY_BG];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        _scrollView.mj_header = header;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)logoImageView {
    if(!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageForKey:SG_IMAGE_STREAM_EMPTY_LOGO]];
    }
    return _logoImageView;
}

- (UILabel *)timeDescriptionLabel {
    if(!_timeDescriptionLabel) {
        _timeDescriptionLabel = [[UILabel alloc] init];
        _timeDescriptionLabel.font = [UIFont fontForKey:SG_FONT_N];
        _timeDescriptionLabel.textColor = [UIColor colorForFontKey:SG_FONT_N];
        _timeDescriptionLabel.text = [NSString stringForKey:SG_TEXT_NOTHING_HAPPEN];
    }
    return _timeDescriptionLabel;
}

- (UILabel *)timeIntervalLabel {
    if(!_timeIntervalLabel) {
        _timeIntervalLabel = [[UILabel alloc] init];
        _timeIntervalLabel.font = [UIFont fontForKey:SG_FONT_L];
        _timeIntervalLabel.textColor = [UIColor colorForFontKey:SG_FONT_L];
    }
    return _timeIntervalLabel;
}

- (UITableView *)tableView {
    if(!_tableView) {
        WS(weakSelf);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self.dataSource;
        _tableView.rowHeight = [SGStreamSummaryCell cellHeight];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadData:NO];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf loadData:YES];
        }];
        _tableView.mj_header = header;
        _tableView.mj_footer = footer;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (SGTableDataSource *)dataSource {
    if(!_dataSource) {
        WS(weakSelf);
        _dataSource = [[SGTableDataSource alloc] initWithTableViewCellGenerator:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            return [weakSelf tableView:tableView cellForRowAtIndexPath:indexPath];
        }];
    }
    return _dataSource;
}

@end
