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
#import "SGStreamSummaryModel.h"

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
    [self showNavigationBarWithTitle:[NSString stringForKey:SG_TEXT_HOME] right:nil rightAction:nil left:nil leftAction:nil];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, TAB_BAR_HEIGHT, 0));
    }];
}

- (void)updateUI {
    NSMutableArray *sectionItemList = [NSMutableArray array];
    NSInteger size = [[self.viewModel streamsArray] count];
    for (NSInteger i = 0; i < size; i++) {
        NSDictionary *dictionary = [[self.viewModel streamsArray] objectAtIndex:i];
        NSArray *array = [[dictionary allValues] objectAtIndex:0];
        NSInteger totalCount = [self.viewModel totalCountAtSection:i];
        SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[array count]+(totalCount > 3 ? ([self.viewModel expandAtSection:i] ? 1 : 0) : 0)];
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
    NSDictionary *dictionary = [[self.viewModel streamsArray] objectAtIndex:indexPath.section];
    NSArray *array = [[dictionary allValues] objectAtIndex:0];
    if(indexPath.row >= [array count]) {
        identifer = REFRESH_CELL_IDENTIFER;
    } else {
        identifer = STREAM_CELL_IDENTIFER;
    }
    if ([identifer isEqualToString:STREAM_CELL_IDENTIFER]) {
        SGStreamSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if(!cell || ![cell isKindOfClass:[SGStreamSummaryCell class]]) {
            cell = [[SGStreamSummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        SGStreamSummaryModel *model = [array objectAtIndex:indexPath.row];
        cell.summaryModel = model;
        return cell;
    } else {
        SGRefreshCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if(!cell || ![cell isKindOfClass:[SGRefreshCell class]]) {
            cell = [[SGRefreshCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        if([array count] >= [self.viewModel totalCountAtSection:indexPath.section]) {
            cell.hasMore = NO;
        } else {
            cell.hasMore = YES;
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    NSDictionary *dictionary = [[self.viewModel streamsArray] objectAtIndex:indexPath.section];
    NSArray *array = [[dictionary allValues] objectAtIndex:0];
    if(indexPath.row >= [array count]) {
        height = [SGRefreshCell cellHeight];
    } else {
        height = [SGStreamSummaryCell cellHeight];
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SECTION_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WS(weakSelf);
    NSDictionary *dictionary = [[self.viewModel streamsArray] objectAtIndex:section];
    NSString *title = [[dictionary allKeys] objectAtIndex:0];
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, SECTION_HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontForKey:SG_FONT_I];
    label.textColor = [UIColor colorForKey:SG_FONT_I];
    label.text = title;
    [sectionView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sectionView);
        make.left.mas_equalTo(sectionView).offset(12);
    }];
    BOOL expand = [weakSelf.viewModel expandAtSection:section];
    UIButton *expandButton = [[UIButton alloc] init];
    expandButton.enabled = [self.viewModel canExpandAtSection:section];
    [expandButton setTitleColor:[UIColor colorForFontKey:SG_FONT_I] forState:UIControlStateNormal];
    expandButton.titleLabel.font = [UIFont fontForKey:SG_FONT_I];
    [expandButton setImage:[UIImage imageForKey:expand?SG_IMAGE_UNEXPAND:SG_IMAGE_EXPAND] forState:UIControlStateNormal];
    [expandButton setTitle:[NSString stringForKey:expand?SG_TEXT_UNEXPAND:SG_TEXT_EXPAND] forState:UIControlStateNormal];
    [[expandButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.viewModel setExpand:!expand atSection:section];
        [weakSelf loadDataAtSection:section more:!expand];
    }];
    [sectionView addSubview:expandButton];
    [expandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(sectionView);
        make.right.mas_equalTo(sectionView).offset(-12);
    }];
    return sectionView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSDictionary *dictionary = [[self.viewModel streamsArray] objectAtIndex:indexPath.section];
    NSArray *array = [[dictionary allValues] objectAtIndex:0];
    if([array count] > indexPath.row) {
        [self.viewModel dispatchWithSection:indexPath.section index:indexPath.row];
    } else {
        [self loadDataAtSection:indexPath.section more:YES];
    }
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
        _tableView.mj_header = header;
        _tableView.sectionFooterHeight = 0;
        _tableView.backgroundColor = [UIColor whiteColor];
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
