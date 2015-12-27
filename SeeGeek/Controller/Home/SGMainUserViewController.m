//
//  SGMainUserViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainUserViewController.h"
#import "SGViewControllerHeader.h"
#import <TKRoundedView.h>
#import "SGCollectionViewDataSource.h"
#import "SGMainUserViewModelProtocol.h"
#import <MJRefresh.h>
#import "UIImageView+URL.h"
#import "SGStreamSnapCell.h"
#import "SGStreamSummaryWithCommentCell.h"
#import "SGStreamSummaryWithCommentModel.h"
#import "UICollectionView+CellHeight.h"

static NSString *const snapCellIdentifer = @"snapCellIdentifer";
static NSString *const commentCellIdentifer = @"commentCellIdentifer";

static CGFloat const HEAD_IMAGE_WIDTH = 70;

@interface SGMainUserViewController ()<UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIScrollView               *scrollView;
@property (nonatomic, strong) UIView                     *containerView;
@property (nonatomic, strong) UIImageView                *headImageView;
@property (nonatomic, strong) UILabel                    *publishCountLabel;
@property (nonatomic, strong) UILabel                    *focusCountLabel;
@property (nonatomic, strong) UILabel                    *fansCountLabel;
@property (nonatomic, strong) UIButton                   *personnalSettingsButton;
@property (nonatomic, strong) UILabel                    *personnalSignLabel;
@property (nonatomic, strong) UIButton                   *collectionStyleButton;
@property (nonatomic, strong) UIButton                   *tableStyleButton;
@property (nonatomic, strong) TKRoundedView              *actionView;
@property (nonatomic, strong) UIView                     *actionDeviderView;
@property (nonatomic, strong) UICollectionView           *collectionView;
@property (nonatomic, strong) UIView                     *emptyView;
@property (nonatomic, strong) UIImageView                *logoView;
@property (nonatomic, strong) UILabel                    *emptyLabel;
@property (nonatomic, strong) UIButton                   *recordButton;
@property (nonatomic, strong) SGCollectionViewDataSource *collectionDataSource;
@property (nonatomic, strong) id<SGMainUserViewModelProtocol> viewModel;
@property (nonatomic, assign) BOOL                       isTableStyle;

@end

@implementation SGMainUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupListeners];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.containerView];
    [self.containerView addSubview:self.headImageView];
    [self.containerView addSubview:self.publishCountLabel];
    [self.containerView addSubview:self.focusCountLabel];
    [self.containerView addSubview:self.fansCountLabel];
    [self.containerView addSubview:self.personnalSignLabel];
    [self.containerView addSubview:self.personnalSettingsButton];
    [self.containerView addSubview:self.actionView];
    [self.actionView addSubview:self.collectionStyleButton];
    [self.actionView addSubview:self.tableStyleButton];
    [self.actionView addSubview:self.actionDeviderView];
    [self.containerView addSubview:self.collectionView];
    [self.containerView addSubview:self.emptyView];
    [self.emptyView addSubview:self.logoView];
    [self.emptyView addSubview:self.emptyLabel];
    [self.emptyView addSubview:self.recordButton];
    [self updateConstraints];
    [self.scrollView.mj_header beginRefreshing];
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
    }];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.containerView).insets(UIEdgeInsetsMake(12, 12, 0, 0));
        make.width.height.mas_equalTo(HEAD_IMAGE_WIDTH);
    }];
    [self.personnalSettingsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView.mas_right).offset(41);
        make.right.mas_equalTo(self.containerView).offset(-12);
        make.top.mas_equalTo(self.containerView).offset(49);
        make.height.mas_equalTo(30);
    }];
    [self.publishCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.personnalSettingsButton.mas_top);
    }];
    [self.focusCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.personnalSettingsButton.mas_top);
    }];
    [self.fansCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.containerView);
        make.bottom.mas_equalTo(self.personnalSettingsButton.mas_top);
    }];
    [self.personnalSignLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.headImageView);
        make.right.mas_equalTo(self.personnalSettingsButton);
        make.top.mas_equalTo(self.headImageView.mas_bottom).offset(15);
    }];
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.containerView);
        make.top.mas_equalTo(self.personnalSignLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    [self.actionDeviderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.actionView);
        make.top.bottom.mas_equalTo(self.actionView);
        make.width.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    [self.collectionStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(self.actionView);
        make.right.mas_equalTo(self.actionDeviderView.mas_left);
    }];
    [self.tableStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(self.actionView);
        make.left.mas_equalTo(self.actionDeviderView.mas_right);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.actionView.mas_bottom);
        make.left.right.mas_equalTo(self.containerView);
    }];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.actionView.mas_bottom);
        make.left.right.mas_equalTo(self.containerView);
        make.height.mas_equalTo(286);
    }];
    [self.logoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.emptyView);
        make.top.mas_equalTo(self.emptyView).offset(22);
    }];
    [self.emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.emptyView).insets(UIEdgeInsetsMake(0, 40, 0, 40));
        make.top.mas_equalTo(self.logoView.mas_bottom).offset(30);
    }];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.emptyView);
        make.top.mas_equalTo(self.emptyLabel.mas_bottom).offset(25);
        make.width.mas_equalTo(113);
        make.height.mas_equalTo(25);
    }];
}

- (void)updateCollections {
    if([[self.viewModel streams] count] > 0) {
        self.collectionView.hidden = NO;
        self.emptyView.hidden = YES;
        SGCollectionViewDataSourceSectionItem *item = [[SGCollectionViewDataSourceSectionItem alloc] initWithItemCount:[[self.viewModel streams] count]];
        self.collectionDataSource.sectionList = @[item];
        [self.collectionView reloadData];
        WS(weakSelf);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(weakSelf.actionView.mas_bottom);
                make.left.right.mas_equalTo(weakSelf.containerView);
                make.height.mas_equalTo(weakSelf.collectionView.contentSize.height);
            }];
            [weakSelf.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(weakSelf.collectionView).priorityHigh();
            }];
            [UIView animateWithDuration:0.1 animations:^{
                [weakSelf.collectionView layoutIfNeeded];
            }];
        });
    } else {
        self.collectionView.hidden = YES;
        self.emptyView.hidden = NO;
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.emptyView).priorityHigh();
        }];
    }
}

- (void)setupListeners {
    WS(weakSelf);
    [[self.personnalSettingsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf.viewModel dispatchToPersonnalSettings];
    }];
    [[[self.collectionStyleButton rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(id value) {
        return weakSelf.isTableStyle;
    }] subscribeNext:^(id x) {
        weakSelf.isTableStyle = NO;
        [weakSelf updateCollections];
    }];
    [[[self.tableStyleButton rac_signalForControlEvents:UIControlEventTouchUpInside] filter:^BOOL(id value) {
        return !weakSelf.isTableStyle;
    }] subscribeNext:^(id x) {
        weakSelf.isTableStyle = YES;
        [weakSelf updateCollections];
    }];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - config cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(self.isTableStyle) {
        SGStreamSummaryWithCommentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:commentCellIdentifer forIndexPath:indexPath];
        [self configCommentCell:cell atIndexPath:indexPath];
        return cell;
    }
    SGStreamSummaryWithCommentModel *model = [[self.viewModel streams] objectAtIndex:indexPath.item];
    SGStreamSnapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:snapCellIdentifer forIndexPath:indexPath];
    cell.model = model;
    return cell;
}

- (void)configCommentCell:(SGStreamSummaryWithCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SGStreamSummaryWithCommentModel *model = [[self.viewModel streams] objectAtIndex:indexPath.item];
    cell.model = model;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.isTableStyle) {
        WS(weakSelf);
        CGSize size = CGSizeMake(collectionView.bounds.size.width, [collectionView cellHeightWithClass:[SGStreamSummaryWithCommentCell class] configraion:^(id cell) {
            [weakSelf configCommentCell:cell atIndexPath:indexPath];
        }]);
        return size;
    }
    return [SGStreamSnapCell cellSize];
}

#pragma mark - load data
- (void)refreshAllData {
    [self loadUserData];
    [self loadCountData];
    [self loadStreamData:NO];
}

- (void)loadStreamData:(BOOL)more {
    WS(weakSelf);
    [self showDefaultProgressHUD];
    [[[self.viewModel signalForLoadStreamData:more] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf.scrollView.mj_footer endRefreshing];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{
        [weakSelf updateCollections];
    }];
}

- (void)loadUserData {
    WS(weakSelf);
    [[[self.viewModel signalForLoadUserData] deliverOnMainThread] subscribeNext:^(id x) {

    } error:^(NSError *error) {

    } completed:^{
        [weakSelf updateUserName:[weakSelf.viewModel userName]];
        [weakSelf updateUserImage:[weakSelf.viewModel userHeadImage]];
        [weakSelf updateUserSign:[weakSelf.viewModel userSign]];
    }];
}

- (void)loadCountData {
    WS(weakSelf);
    [[[self.viewModel signalForLoadCountData] deliverOnMainThread] subscribeNext:^(id x) {

    } error:^(NSError *error) {

    } completed:^{
        [weakSelf updatePublishCount:[weakSelf.viewModel countForPublish]];
        [weakSelf updateFocusCount:[weakSelf.viewModel countForFocus]];
        [weakSelf updateFansCount:[weakSelf.viewModel countForFans]];
    }];
}

#pragma mark - update UI
- (void)updatePublishCount:(NSInteger)count {
    [self updateCountLabel:self.publishCountLabel count:count constString:[NSString stringForKey:SG_TEXT_PUBLISH]];
}

- (void)updateFocusCount:(NSInteger)count {
    [self updateCountLabel:self.focusCountLabel count:count constString:[NSString stringForKey:SG_TEXT_FOCUS]];
}

- (void)updateFansCount:(NSInteger)count {
    [self updateCountLabel:self.fansCountLabel count:count constString:[NSString stringForKey:SG_TEXT_FANS]];
}

- (void)updateCountLabel:(UILabel *)label count:(NSInteger)count constString:(NSString *)constString {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d\n%@", (int)count, constString]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontForKey:SG_FONT_J] range:NSMakeRange(0, attributedString.length - constString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorForFontKey:SG_FONT_J] range:NSMakeRange(0, attributedString.length - constString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontForKey:SG_FONT_N] range:NSMakeRange(attributedString.length - constString.length, constString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorForFontKey:SG_FONT_N] range:NSMakeRange(attributedString.length - constString.length, constString.length)];
    label.attributedText = attributedString;
}

- (void)updateUserImage:(NSString *)imageUrl {
    [self.headImageView showImageWithURL:imageUrl section:NSStringFromClass([self class]) defaultImage:nil];
}

- (void)updateUserName:(NSString *)userName {

}

- (void)updateUserSign:(NSString *)userSign {
    self.personnalSignLabel.text = userSign;
}

#pragma mark - accessory
- (UIScrollView *)scrollView {
    if(!_scrollView) {
        WS(weakSelf);
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshAllData];
        }];
        header.lastUpdatedTimeLabel.hidden = YES;
        MJRefreshAutoFooter *footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            [weakSelf loadStreamData:YES];
        }];
        _scrollView.mj_header = header;
        _scrollView.mj_footer = footer;
    }
    return _scrollView;
}

- (UIView *)containerView {
    if(!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}

- (UIImageView *)headImageView {
    if(!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
    }
    return _headImageView;
}

- (UILabel *)publishCountLabel {
    if(!_publishCountLabel) {
        _publishCountLabel = [[UILabel alloc] init];
        _publishCountLabel.numberOfLines = 0;
        _publishCountLabel.numberOfLines = 0;
    }
    return _publishCountLabel;
}

- (UILabel *)focusCountLabel {
    if(!_focusCountLabel) {
        _focusCountLabel = [[UILabel alloc] init];
        _focusCountLabel.numberOfLines = 0;
        _focusCountLabel.numberOfLines = 0;
    }
    return _focusCountLabel;
}

- (UILabel *)fansCountLabel {
    if(!_fansCountLabel) {
        _fansCountLabel = [[UILabel alloc] init];
        _fansCountLabel.textAlignment = NSTextAlignmentCenter;
        _fansCountLabel.numberOfLines = 0;
    }
    return _fansCountLabel;
}

- (UIButton *)personnalSettingsButton {
    if(!_personnalSettingsButton) {
        _personnalSettingsButton = [[UIButton alloc] init];
        [_personnalSettingsButton setTitle:[NSString stringForKey:SG_TEXT_PERSONNAL_SETTINGS] forState:UIControlStateNormal];
        [_personnalSettingsButton setTitleColor:[UIColor colorForFontKey:SG_FONT_I] forState:UIControlStateNormal];
        _personnalSettingsButton.titleLabel.font = [UIFont fontForKey:SG_FONT_I];
        _personnalSettingsButton.backgroundColor = [UIColor colorForKey:SG_COLOR_NORMAL_GRAY_BG];
        _personnalSettingsButton.layer.cornerRadius = 5;
    }
    return _personnalSettingsButton;
}

- (UILabel *)personnalSignLabel {
    if(!_personnalSignLabel) {
        _personnalSignLabel = [[UILabel alloc] init];
        _personnalSignLabel.textColor = [UIColor colorForFontKey:SG_FONT_J];
        _personnalSignLabel.font = [UIFont fontForKey:SG_FONT_J];
        _personnalSignLabel.numberOfLines = 0;
        _personnalSignLabel.text = [NSString stringForKey:SG_TEXT_INIT_PERSONNAL_SIGN];
        _personnalSignLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 25;
    }
    return _personnalSignLabel;
}

- (TKRoundedView *)actionView {
    if(!_actionView) {
        _actionView = [[TKRoundedView alloc] init];
        _actionView.borderColor = [UIColor lineColor];
        _actionView.borderWidth = 1/[UIScreen mainScreen].scale;
        _actionView.drawnBordersSides = TKDrawnBorderSidesTop | TKDrawnBorderSidesBottom;
        _actionView.roundedCorners = TKRoundedCornerNone;
        _actionView.fillColor = [UIColor whiteColor];
    }
    return _actionView;
}

- (UIView *)actionDeviderView {
    if(!_actionDeviderView) {
        _actionDeviderView = [[UIView alloc] init];
        _actionDeviderView.backgroundColor = [UIColor lineColor];
    }
    return _actionDeviderView;
}

- (UIButton *)collectionStyleButton {
    if(!_collectionStyleButton) {
        _collectionStyleButton = [[UIButton alloc] init];
        [_collectionStyleButton setImage:[UIImage imageForKey:SG_IMAGE_COLLECTION_STYLE] forState:UIControlStateNormal];
    }
    return _collectionStyleButton;
}

- (UIButton *)tableStyleButton {
    if(!_tableStyleButton) {
        _tableStyleButton = [[UIButton alloc] init];
        [_tableStyleButton setImage:[UIImage imageForKey:SG_IMAGE_TABLE_STYLE] forState:UIControlStateNormal];
    }
    return _tableStyleButton;
}

- (UICollectionView *)collectionView {
    if(!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self.collectionDataSource;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[SGStreamSnapCell class] forCellWithReuseIdentifier:snapCellIdentifer];
        [_collectionView registerClass:[SGStreamSummaryWithCommentCell class] forCellWithReuseIdentifier:commentCellIdentifer];
        _collectionView.scrollsToTop = NO;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (UIView *)emptyView {
    if(!_emptyView) {
        _emptyView = [[UIView alloc] init];
        _emptyView.backgroundColor = [UIColor colorForKey:SG_COLOR_CONTROLLER_GRAY_BG];
    }
    return _emptyView;
}

- (UIImageView *)logoView {
    if(!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageForKey:SG_IMAGE_STREAM_EMPTY_LOGO]];
    }
    return _logoView;
}

- (UILabel *)emptyLabel {
    if(!_emptyLabel) {
        _emptyLabel = [[UILabel alloc] init];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.numberOfLines = 0;
        _emptyLabel.text = [NSString stringForKey:SG_TEXT_PERSONNAL_EMPTY_STREAM];
        _emptyLabel.textColor = [UIColor colorForFontKey:SG_FONT_N];
        _emptyLabel.font = [UIFont fontForKey:SG_FONT_N];
    }
    return _emptyLabel;
}

- (UIButton *)recordButton {
    if(!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        _recordButton.backgroundColor = [UIColor colorForKey:SG_COLOR_RED_BG];
        _recordButton.titleLabel.font = [UIFont fontForKey:SG_FONT_E];
        [_recordButton setTitle:[NSString stringForKey:SG_TEXT_LIVE_STREAM_NOW] forState:UIControlStateNormal];
        [_recordButton setTitleColor:[UIColor colorForFontKey:SG_FONT_E] forState:UIControlStateNormal];
        _recordButton.layer.cornerRadius = 8;
    }
    return _recordButton;
}

- (SGCollectionViewDataSource *)collectionDataSource {
    if(!_collectionDataSource) {
        WS(weakSelf);
        _collectionDataSource = [[SGCollectionViewDataSource alloc] initWithGenerator:^UICollectionViewCell *(UICollectionView *collectionView, NSIndexPath *indexPath) {
            return [weakSelf collectionView:collectionView cellForItemAtIndexPath:indexPath];
        }];
    }
    return _collectionDataSource;
}

@end
