//
//  SGMainPageViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainPageViewController.h"
#import "SGViewControllerHeader.h"
#import "SGTableDataSource.h"
#import "../../Protocol/ViewModelProtocol/SGMainPageViewModelProtocol.h"
#import <MJRefresh.h>
#import "SGStreamSummaryCell.h"
#import "SGRefreshCell.h"

static NSInteger const SECTION_NONE = -1;

static NSString *const STREAM_CELL_IDENTIFER = @"STREAM_CELL_IDENTIFER";
static NSString *const REFRESH_CELL_IDENTIFER = @"REFRESH_CELL_IDENTIFER";

static NSInteger const SECTION_HEADER_HEIGHT = 30;

@interface SGMainPageViewController ()<UITableViewDelegate>

@property (nonatomic, strong) UITableView                 *tableView;
@property (nonatomic, strong) SGTableDataSource           *dataSource;
@property (nonatomic, strong) id<SGMainPageViewModelProtocol> viewModel;

@end

@implementation SGMainPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self updateConstraints];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, -TAB_BAR_HEIGHT, 0));
    }];
}

- (void)updateUI {
    NSMutableArray *sectionItemList = [NSMutableArray array];
    for (NSDictionary *dictionary in [self.viewModel streamsArray]) {
        NSArray *array = [[dictionary allValues] objectAtIndex:0];
        SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[array count]];
        [sectionItemList addObject:item];
    }
    self.dataSource.sectionList = sectionItemList;
    [self.tableView reloadData];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - load data
- (void)loadDataAtSection:(NSInteger)section more:(BOOL)more {
    [self showDefaultProgressHUD];
    WS(weakSelf);
    [[[self.viewModel signalForLoadDataWithSection:section more:more] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{
        [weakSelf updateUI];
    }];
}

#pragma mark - TableViewCellGenerator
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSString *identifer = nil;
    if([self.viewModel expandAtSection:indexPath.section]) {
        NSDictionary *dictionary = [[self.viewModel streamsArray] objectAtIndex:indexPath.section];
        NSArray *array = [[dictionary allValues] objectAtIndex:0];
        if(indexPath.row == 0) {
            identifer = REFRESH_CELL_IDENTIFER;
        } else if(indexPath.row >= [array count] + 1) {
            identifer = REFRESH_CELL_IDENTIFER;
        } else {
            identifer = STREAM_CELL_IDENTIFER;
        }
    } else {
        identifer = STREAM_CELL_IDENTIFER;
    }
    if ([identifer isEqualToString:STREAM_CELL_IDENTIFER]) {
        SGStreamSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if(!cell || ![cell isKindOfClass:[SGStreamSummaryCell class]]) {
            cell = [[SGStreamSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        return cell;
    } else {
        SGRefreshCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if(!cell || ![cell isKindOfClass:[SGRefreshCell class]]) {
            cell = [[SGRefreshCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if([self.viewModel expandAtSection:indexPath.section]) {
        NSDictionary *dictionary = [[self.viewModel streamsArray] objectAtIndex:indexPath.section];
        NSArray *array = [[dictionary allValues] objectAtIndex:0];
        if(indexPath.row == 0) {
            height = [SGRefreshCell cellHeight];
        } else if(indexPath.row >= [array count] + 1) {
            height = [SGRefreshCell cellHeight];
        } else {
            height = [SGStreamSummaryCell cellHeight];
        }
    } else {
        height = [SGStreamSummaryCell cellHeight];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEADER_HEIGHT;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - accessory
- (UITableView *)tableView {
    if(!_tableView) {
        WS(weakSelf);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self.dataSource;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadDataAtSection:SECTION_NONE more:NO];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf loadDataAtSection:SECTION_NONE more:YES];
        }];
        _tableView.mj_header = header;
        _tableView.mj_footer = footer;
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
