//
//  SGMainLocationViewController.m
//  SeeGeek
//
//  Created by 余晨正Alex on 15/12/12.
//  Copyright © 2015年 SeeGeek. All rights reserved.
//

#import "SGMainLocationViewController.h"
#import "LocationManager.h"
#import "SGTextField.h"
#import "SGTableDataSource.h"
#import "SGViewControllerHeader.h"
#import "SGViewControllerDelegate.h"
#import "../../Protocol/ViewModelProtocol/SGMainLocationViewModelProtocol.h"
#import "SGVideoLocationModel.h"
#import "SGStreamSummaryLittleSnapCell.h"

static CGFloat const CELL_HEADER_HEIGHT = 40;
static CLLocationDegrees const CENTER_LATITUDE = 21.227640585739891;
static CLLocationDegrees const CENTER_LONGITUDE = 104.72084703215481;
static double const MAP_ZOOM_LEVEL = 3.1;

#pragma mark - simple annotation

@interface SimpleAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy  ) NSString               *title;
@property (nonatomic, copy  ) NSString               *subtitle;
@property (nonatomic, strong) UIImage                *image;
@property (nonatomic, strong) SGVideoLocationModel   *model;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@implementation SimpleAnnotation

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init]){
        self.coordinate = coordinate;
    }
    return self;
}

@end

#pragma mark - simple annotation view

@interface SimpleAnnotationView : MAAnnotationView

@property (nonatomic, copy)NSString *countTitle;
@property (nonatomic, strong)UIImage *backgroundImage;
@property (nonatomic, strong)UIButton *button;

@end

@implementation SimpleAnnotationView

- (instancetype)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if(self) {
        [self addSubview:self.button];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setCountTitle:(NSString *)countTitle {
    _countTitle = countTitle;
    [self.button setTitle:countTitle forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    [self.button setBackgroundImage:backgroundImage forState:UIControlStateNormal];
}

- (UIButton *)button {
    if(!_button) {
        _button = [[UIButton alloc] init];
        _button.enabled = NO;
        _button.adjustsImageWhenDisabled = NO;
        [_button setTitleColor:[UIColor colorForFontKey:SG_FONT_C] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont fontForKey:SG_FONT_C];
    }
    return _button;
}

@end

#pragma mark SGMainLocationViewController

@interface SGMainLocationViewController ()<SGViewControllerDelegate, MAMapViewDelegate, UITableViewDelegate>

@property (nonatomic, strong)MAMapView *mapView;
@property (nonatomic, strong)SGTextField *textField;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)id<SGMainLocationViewModelProtocol> viewModel;
@property (nonatomic, strong)SGTableDataSource *tableDataSource;
@property (nonatomic, strong)SGVideoLocationModel *selectLocationModel;

@end

@implementation SGMainLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.tableView];
    [self updateConstraints];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mapView setZoomLevel:MAP_ZOOM_LEVEL];
    [self loadLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - setup
- (void)updateConstraints {
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(self.view).insets(UIEdgeInsetsMake(10, 12, 0, 12));
        make.height.mas_equalTo(28);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, TAB_BAR_HEIGHT, 0));
        make.height.mas_equalTo(CELL_HEADER_HEIGHT + (180 * SCREEN_SCALE));
    }];
}

- (void)showStreamLocations {
    for(SGVideoLocationModel *model in [self.viewModel streamLocationArray]) {
        SimpleAnnotation *annotation = [[SimpleAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(model.lantitude, model.longitude)];
        annotation.title = [NSString stringWithFormat:@"%d", (int)model.count];
        switch (model.streamType) {
            case SGStreamTypeNone: {
                annotation.image = nil;
                break;
            }
            case SGStreamTypeLive: {
                annotation.image = [UIImage imageForKey:SG_IMAGE_ANNOTATION_LIVE];
                break;
            }
            case SGStreamTypeClip: {
                annotation.image = [UIImage imageForKey:SG_IMAGE_ANNOTATION_CLIP];
                break;
            }
        }
        annotation.model = model;
        [self.mapView addAnnotation:annotation];
    }
}

- (void)showStreamSummaryTable:(SGVideoLocationModel *)model {
    if(self.selectLocationModel == model) {
        return;
    }
    self.selectLocationModel = model;
    self.tableView.hidden = NO;
    NSArray *dataArray = [self.viewModel streamSummaryArrayForLocation:model];
    SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[dataArray count]];
    self.tableDataSource.sectionList = @[item];
    [self.tableView reloadData];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.selectLocationModel = nil;
    self.tableView.hidden = YES;
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if(![annotation isKindOfClass:[SimpleAnnotation class]]) {
        return nil;
    }
    static NSString *identifer = @"customReuseIndetifier";
    SimpleAnnotationView *annotationView = (SimpleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
    if(!annotationView) {
        annotationView = [[SimpleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer];
        annotationView.frame = CGRectMake(0, 0, 30, 30);
    }
    SimpleAnnotation *simpleAnnotation = annotation;
    annotationView.countTitle = simpleAnnotation.title;
    annotationView.backgroundImage = simpleAnnotation.image;
    return annotationView;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    SimpleAnnotation *annotation = view.annotation;
    SGVideoLocationModel *model = annotation.model;
    [self loadSummary:model more:NO];
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CELL_HEADER_HEIGHT)];

    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontForKey:SG_FONT_I];
    label.textColor = [UIColor colorForFontKey:SG_FONT_I];
    label.text = self.selectLocationModel.location;
    [view addSubview:label];

    WS(weakSelf);
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:[NSString stringWithFormat:@"+ %@", [NSString stringForKey:SG_TEXT_FOCUS_LOCATION]] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorForARGB:@"#ec9f24"];
    button.titleLabel.font = [UIFont fontForKey:SG_FONT_E];
    [button setTitleColor:[UIColor colorForFontKey:SG_FONT_E] forState:UIControlStateNormal];
    [view addSubview:button];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf focusLocationModel:weakSelf.selectLocationModel];
    }];

    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(view);
        make.width.mas_equalTo(100);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(view).insets(UIEdgeInsetsMake(0, 15, 0, 0));
        make.right.mas_equalTo(button.mas_left).offset(-3);
    }];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - config cell
- (UITableViewCell *)tableview:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"location_summary_cell";
    SGStreamSummaryLittleSnapCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(!cell) {
        cell = [[SGStreamSummaryLittleSnapCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    NSArray *dataArray = [self.viewModel streamSummaryArrayForLocation:self.selectLocationModel];
    SGStreamSummaryModel *model = [dataArray objectAtIndex:indexPath.row];
    cell.summaryModel = model;
    return cell;
}

#pragma mark - load data
- (void)loadLocations {
    WS(weakSelf);
    [self showDefaultProgressHUD];
    [[[self.viewModel signalForLoadLocationData] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{
        [weakSelf showStreamLocations];
    }];
}

- (void)loadSummary:(SGVideoLocationModel *)model more:(BOOL)more {
    WS(weakSelf);
    __weak typeof(model) weakModel = model;
    [self showDefaultProgressHUD];
    [[[self.viewModel signalForLoadStreamDataWithLocation:model more:more] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{
        [weakSelf showStreamSummaryTable:weakModel];
    }];
}

- (void)focusLocationModel:(SGVideoLocationModel *)model {
    WS(weakSelf);
    [self showDefaultProgressHUD];
    [[[self.viewModel signalForFocusLocation:model] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{

    }];
}

#pragma mark - accessory
- (MAMapView *)mapView {
    if(!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(CENTER_LATITUDE, CENTER_LONGITUDE)];
        _mapView.zoomEnabled = NO;
    }
    return _mapView;
}

- (SGTextField *)textField {
    if(!_textField) {
        _textField = [[SGTextField alloc] init];
    }
    return _textField;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self.tableDataSource;
        _tableView.hidden = YES;
        _tableView.rowHeight = [SGStreamSummaryLittleSnapCell cellHeight];
        _tableView.sectionHeaderHeight = CELL_HEADER_HEIGHT;
    }
    return _tableView;
}

- (SGTableDataSource *)tableDataSource {
    if(!_tableDataSource) {
        WS(weakSelf);
        _tableDataSource = [[SGTableDataSource alloc] initWithTableViewCellGenerator:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            return [weakSelf tableview:tableView cellForRowAtIndexPath:indexPath];
        }];
    }
    return _tableDataSource;
}

@end
