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
#import "SGMapLocationCell.h"

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

#pragma mark - simple location annotation

@interface SimpleLocationAnnotation : NSObject<MAAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy  ) NSString               *title;
@property (nonatomic, copy  ) NSString               *subtitle;
@property (nonatomic, strong) UIImage                *image;
@property (nonatomic, strong) AMapPOI                *poi;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end

@implementation SimpleLocationAnnotation

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

@property (nonatomic, copy  ) NSString *countTitle;
@property (nonatomic, strong) UIImage  *backgroundImage;
@property (nonatomic, strong) UIButton *button;

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

@interface SGMainLocationViewController ()<SGViewControllerDelegate, MAMapViewDelegate, UITableViewDelegate, AMapSearchDelegate>

@property (nonatomic, strong) MAMapView                       *mapView;
@property (nonatomic, strong) UIView                          *searchContainer;
@property (nonatomic, strong) SGTextField                     *textField;
@property (nonatomic, strong) UITableView                     *tableView;
@property (nonatomic, strong) id<SGMainLocationViewModelProtocol> viewModel;
@property (nonatomic, strong) SGTableDataSource               *tableDataSource;
@property (nonatomic, strong) SGVideoLocationModel            *selectLocationModel;
@property (nonatomic, strong) AMapSearchAPI                   *searchAPI;
@property (nonatomic, strong) NSArray                         *pois;

@end

@implementation SGMainLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupListeners];
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.searchContainer];
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
    [self.searchContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(45 + STATUS_BAR_HEIGHT);
    }];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.searchContainer).insets(UIEdgeInsetsMake(0, 12, 0, 12));
        make.top.mas_equalTo(self.searchContainer).offset(STATUS_BAR_HEIGHT + 8);
        make.height.mas_equalTo(28);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, TAB_BAR_HEIGHT, 0));
        make.height.mas_equalTo(CELL_HEADER_HEIGHT + (180 * SCREEN_SCALE));
    }];
}

- (void)showStreamLocations {
    self.pois = nil;
    [self.mapView removeAnnotations:[self.mapView annotations]];
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

- (void)showPOILocations:(NSArray *)pois {
    self.selectLocationModel = nil;
    [self.mapView removeAnnotations:[self.mapView annotations]];
    NSInteger count = [pois count];
    for (int i = 0; i < count; i++) {
        AMapPOI *poi  = [pois objectAtIndex:i];
        SimpleLocationAnnotation *annotation = [[SimpleLocationAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude)];
        annotation.title = [NSString stringWithFormat:@"%d", (int)(i+1)];
        annotation.image = [UIImage imageForKey:SG_IMAGE_LOCATION_RED];
        annotation.poi = poi;
        [self.mapView addAnnotation:annotation];
    }
    [self showTableView];
}

- (void)showTableView {
    self.tableView.hidden = NO;
    if(self.selectLocationModel) {
        NSArray *dataArray = [self.viewModel streamSummaryArrayForLocation:self.selectLocationModel];
        SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[dataArray count]];
        self.tableDataSource.sectionList = @[item];
    } else {
        SGTableDataSourceSectionItem *item = [[SGTableDataSourceSectionItem alloc] initWithItemCount:[self.pois count]];
        self.tableDataSource.sectionList = @[item];
    }
    [self.tableView reloadData];
}

- (void)setupListeners {
    WS(weakSelf);
    [[RACObserve(self.textField, content) deliverOnMainThread] subscribeNext:^(NSString *x) {
        if(x.length == 0) {
            [weakSelf loadLocations];
        } else {
            [weakSelf POISearchWithKeyword:x];
        }
    }];
}

#pragma mark - SGViewControllerDelegate
- (void)onViewModelLoaded:(id)viewModel {
    self.viewModel = viewModel;
}

#pragma mark - MAMapViewDelegate
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if(self.selectLocationModel) {
        self.selectLocationModel = nil;
        self.tableView.hidden = YES;
    }
}

- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    if([annotation isKindOfClass:[SimpleAnnotation class]]) {
        static NSString *identifer = @"customReuseIndetifier";
        SimpleAnnotationView *annotationView = (SimpleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
        if(!annotationView) {
            annotationView = [[SimpleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer];
            annotationView.frame = CGRectMake(0, 0, 25, 25);
        }
        SimpleAnnotation *simpleAnnotation = annotation;
        annotationView.countTitle = simpleAnnotation.title;
        annotationView.backgroundImage = simpleAnnotation.image;
        return annotationView;
    } else if([annotation isKindOfClass:[SimpleLocationAnnotation class]]) {
        static NSString *identifer = @"poiReuseIndetifier";
        SimpleAnnotationView *annotationView = (SimpleAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:identifer];
        if(!annotationView) {
            annotationView = [[SimpleAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer];
            annotationView.frame = CGRectMake(0, 0, 17, 23);
        }
        SimpleLocationAnnotation *simpleAnnotation = annotation;
        annotationView.countTitle = simpleAnnotation.title;
        annotationView.backgroundImage = simpleAnnotation.image;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    id annotation = view.annotation;
    if([annotation isKindOfClass:[SimpleAnnotation class]]) {
        SGVideoLocationModel *model = ((SimpleAnnotation *)annotation).model;
        self.selectLocationModel = model;
        [self loadSummary:model more:NO];
    } else if([annotation isKindOfClass:[SimpleLocationAnnotation class]]) {

    }
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    self.pois = response.pois;
    [self showPOILocations:response.pois];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.selectLocationModel == nil) {
        return 0;
    }
    return CELL_HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectLocationModel == nil) {
        return [SGMapLocationCell cellHeight];
    }
    return [SGStreamSummaryLittleSnapCell cellHeight];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.selectLocationModel == nil) {
        return nil;
    }
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
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - config cell
- (UITableViewCell *)tableview:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectLocationModel == nil) {
        static NSString *cellIdentifer = @"location_map_cell";
        SGMapLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
        if(!cell) {
            cell = [[SGMapLocationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        }
        if(indexPath.row < [self.pois count]) {
            AMapPOI *poi = [self.pois objectAtIndex:indexPath.row];
            [cell updateWithTitle:poi.name content:poi.address index:indexPath.row];
        }
        return cell;
    }
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
    [self showDefaultProgressHUD];
    [[[self.viewModel signalForLoadStreamDataWithLocation:model more:more] deliverOnMainThread] subscribeNext:^(id x) {
        [weakSelf dismissHUD];
    } error:^(NSError *error) {
        [weakSelf showDefaultTextHUD:[error localizedDescription]];
    } completed:^{
        [weakSelf showTableView];
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

- (void)POISearchWithKeyword:(NSString *)keyword {
    NSString *finalKeyword = [keyword stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(finalKeyword.length == 0) {
        return;
    }
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    NSString *requestString = [finalKeyword stringByReplacingOccurrencesOfString:@" " withString:@"|"];
    request.keywords = requestString;
    request.types = @"餐饮服务|购物服务|生活服务|风景名胜|商务住宅|地名地址信息|公共设施";
    [self.searchAPI AMapPOIKeywordsSearch:request];
}

#pragma mark - accessory
- (MAMapView *)mapView {
    if(!_mapView) {
        _mapView = [[MAMapView alloc] init];
        _mapView.delegate = self;
        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(CENTER_LATITUDE, CENTER_LONGITUDE)];
    }
    return _mapView;
}

- (UIView *)searchContainer {
    if(!_searchContainer) {
        _searchContainer = [[UIView alloc] init];
        _searchContainer.backgroundColor = [[UIColor colorForKey:SG_COLOR_FIELD_GRAY] alpha:0.5];
    }
    return _searchContainer;
}

- (SGTextField *)textField {
    if(!_textField) {
        _textField = [[SGTextField alloc] init];
        _textField.placeHolder = [NSString stringForKey:SG_TEXT_INPUT_SEARCH_CONTENT];
        _textField.rightImage = [UIImage imageForKey:SG_IMAGE_SEARCH];
        _textField.editEnable = YES;
        _textField.contentFont = [UIFont fontForKey:SG_FONT_M];
        _textField.contentColor = [UIColor colorForFontKey:SG_FONT_M];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.clearMode = UITextFieldViewModeNever;
        _textField.fillColor = [UIColor colorForKey:SG_COLOR_FIELD_GRAY];
        _textField.borderWidth = _1_PX;
        _textField.borderColor = [UIColor colorForKey:SG_COLOR_FIELD_GRAY];
        _textField.cornerRadius = 5;
        _textField.insets = UIEdgeInsetsMake(0, 10, 0, 10);
        __weak typeof(_textField) weakFiled = _textField;
        _textField.returnKeyBlock = ^() {
            [weakFiled resignFirstResponder];
        };
    }
    return _textField;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self.tableDataSource;
        _tableView.hidden = YES;
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

- (AMapSearchAPI *)searchAPI {
    if(!_searchAPI) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        _searchAPI.delegate = self;
    }
    return _searchAPI;
}

@end
