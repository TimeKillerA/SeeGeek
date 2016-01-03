//
//  SGPersonnalSettingsViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/27.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGPersonnalSettingsViewController.h"
#import "SGViewControllerHeader.h"
#import "SGTableDataSource.h"
#import "SGViewControllerDelegate.h"
#import "SGPersonnalSettingsViewModelProtocol.h"
#import "SGPersonnalSettingsModel.h"
#import "SGPersonnalSettingsCell.h"

@interface SGPersonnalSettingsViewController ()<SGViewControllerDelegate, UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)SGTableDataSource *dataSource;
@property (nonatomic, strong)id<SGPersonnalSettingsViewModelProtocol> viewModel;

@end

@implementation SGPersonnalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self showDefaultNavigationBarWithTitle:[NSString stringForKey:SG_TEXT_PERSONNAL_SETTINGS]];
    [self updateConstraints];
    [self updateTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).insets(UIEdgeInsetsMake(NAVIGATION_BAR_HEIGHT, 0, 0, 0));
    }];
}

- (void)updateTable {
    SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[[self.viewModel personnalSettingsItemList] count]];
    self.dataSource.sectionList = @[item];
    [self.tableView reloadData];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - config table cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *array = [self.viewModel personnalSettingsItemList];
    static NSString *imageCell = @"image_cell_identifer";
    static NSString *textCell = @"text_cell_identifer";
    NSString *cellIdentifer = nil;
    SGPersonnalSettingsModel *model = [array objectAtIndex:indexPath.row];
    SGPersonnalSettingsCell *cell = nil;
    if([model isKindOfClass:[SGPersonnalSettingsTextModel class]]) {
        cellIdentifer = textCell;
    } else {
        cellIdentifer = imageCell;
    }
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(!cell) {
        cell = [[SGPersonnalSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    cell.model = model;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSArray *array = [self.viewModel personnalSettingsItemList];
    if(indexPath.row >= [array count]) {
        return;
    }
    SGPersonnalSettingsModel *model = [array objectAtIndex:indexPath.row];
    [self.viewModel dispatchToPersonnalSettingsItem:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [self.viewModel personnalSettingsItemList];
    if(indexPath.row >= [array count]) {
        return 0;
    }
    SGPersonnalSettingsModel *model = [array objectAtIndex:indexPath.row];
    return [model isKindOfClass:[SGPersonnalSettingsTextModel class]] ? 40 : 100;
}

#pragma mark - accessory
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self.dataSource;
        _tableView.tableFooterView = [[UIView alloc] init];
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
