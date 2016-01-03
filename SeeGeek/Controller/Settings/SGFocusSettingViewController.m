
//
//  SGFocusSettingViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 16/1/3.
//  Copyright © 2016年 SeeGeek. All rights reserved.
//

#import "SGFocusSettingViewController.h"
#import <MJRefresh.h>
#import "SGViewControllerHeader.h"
#import "SGViewControllerDelegate.h"
#import "SGTableDataSource.h"
#import "SGFocusSettingViewModelProtocol.h"
#import "SGFansModel.h"
#import "SGFocusCell.h"

@interface SGFocusSettingViewController ()<SGViewControllerDelegate, UITableViewDelegate, SGFocusCellDelegate>

@property (nonatomic, strong)id<SGFocusSettingViewModelProtocol> viewModel;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)SGTableDataSource *dataSource;
@property (nonatomic, strong)NSArray *dataArray;

@end

@implementation SGFocusSettingViewController

- (void)dealloc {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self showDefaultNavigationBarWithTitle:[self.viewModel pageTitle]];
    [self updateConstraints];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setup
- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
    }];
}

#pragma mark - load data
- (void)loadMoreData:(BOOL)more {
    [self showDefaultProgressHUD];
    WS(weakSelf);
    [[[self.viewModel signalForLoadMoreData:more] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{
        [weakSelf resetDataArray];
        [weakSelf updateTableView];
    }];
}

#pragma mark - UI
- (void)updateTableView {
    SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[[self dataArray] count]];
    self.dataSource.sectionList = @[item];
    [self.tableView reloadData];
}

#pragma mark - bridge
- (void)resetDataArray {
    NSMutableArray *array = [NSMutableArray array];
    for(id data in [self.viewModel dataArray]) {
        if([data isKindOfClass:[SGFansModel class]]) {
            SGFocusCellItem *item = [self cellItemWithFan:data];
            [array addObject:item];
        }
    }
    self.dataArray = array;
}

- (SGFocusCellItem *)cellItemWithFan:(SGFansModel *)fan {
    SGFocusCellItem *item = [[SGFocusCellItem alloc] init];
    item.title = fan.name;
    item.imageUrl = fan.headImageUrl;
    item.content = fan.sign;
    item.focus = fan.focus;
    item.showMoreAction = YES;
    return item;
}

#pragma mark - UITableViewDelegate

#pragma mark - config cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"focus_cell_identifer";
    SGFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(!cell) {
        cell = [[SGFocusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.delegate = self;
    }
    SGFocusCellItem *item = [self.dataArray objectAtIndex:indexPath.row];
    cell.focusItem = item;
    return cell;
}

#pragma mark - SGFocusCellDelegate
- (void)didClickFocusButtonInFocusCell:(SGFocusCell *)focusCell {

}

- (void)didClickMoreActionButtonInFocusCell:(SGFocusCell *)focusCell {

}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - accessory
- (UITableView *)tableView {
    if(!_tableView) {
        WS(weakSelf);
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self.dataSource;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 60;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadMoreData:NO];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf loadMoreData:YES];
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
