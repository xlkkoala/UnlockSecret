//
//  ViewController.m
//  MapNearbyLocationDemo
//
//  Created by crw on 11/26/15.
//  Copyright © 2015 crw. All rights reserved.
//

#import "USNearAddressViewController.h"
#import "MJRefresh.h"
#import "SelectLocationCell.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#define SelectLocation_Not_Show @"不显示位置"
const static NSString *ApiKey = @"2acb7487918ad2fcc86f2515c0907850";

@interface USNearAddressViewController ()<AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) AMapSearchAPI  *search;
@property (nonatomic,strong) NSMutableArray *addressArray;
@property (nonatomic,strong) UITableView    *mTableView;
@property (nonatomic,assign) BOOL           needInsertOldAddress;
@property (nonatomic,assign) BOOL           isSelectCity;
@property (nonatomic,assign) NSInteger      pageIndex;
@property (nonatomic,assign) NSInteger      pageCount;
@property (nonatomic,strong) AMapLocationManager   *locationManager;
@property (nonatomic,assign) CLLocationDegrees  latitude;
@property (nonatomic,assign) CLLocationDegrees  longitude;

@end

@implementation USNearAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"所在位置";
    [AMapServices sharedServices].apiKey = (NSString *)ApiKey;
    AMapPOI *first  = [[AMapPOI alloc] init];
    first.name      = SelectLocation_Not_Show;
    [self.addressArray addObject:first];
    
    if (self.oldPoi) {
        AMapPOI *poi                = self.oldPoi;
        self.needInsertOldAddress   = poi.address.length > 0;
        self.isSelectCity           = poi.address.length == 0;
    }
    
    [self.view addSubview:self.mTableView];
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 5;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (error)
        {
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            
            if (error.code == AMapLocationErrorLocateFailed)
            {
                [SVProgressHUD showErrorWithStatus:@"定位失败"];
                return;
            }
        }else{
            self.latitude = location.coordinate.latitude;
            self.longitude = location.coordinate.longitude;
            [self headRefreshing];
        }
    }];
}

#pragma mark - getData
- (void)headRefreshing{
    self.pageIndex = 0;
    self.pageCount = 10;
    [self footRefreshing];
}

- (void)footRefreshing{
    self.pageIndex += 1;
    [self sendRequest];
}

- (void)sendRequest{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location                    = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.keywords                    = @"";
    request.sortrule                    = 0;
    request.requireExtension            = YES;
    request.radius                      = 1000;
    request.page                        = self.pageIndex;
    request.offset                      = self.pageCount;
    request.types                       = @"050000|060000|070000|080000|090000|100000|110000|120000|130000|140000|150000|160000|170000";
    
    [self.search AMapPOIAroundSearch:request];
}

#pragma mark - AMapSearchDelegate
/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if (response.pois.count == 0){
        return;
    }
    
    if (self.addressArray.count == 1) {
        AMapPOI *poi = [[AMapPOI alloc] init];
        poi.city     = ((AMapPOI *)response.pois.firstObject).city;
        [self.addressArray addObject:poi];
    }
    
    [self.addressArray addObjectsFromArray:response.pois];
    
    [self.mTableView reloadData];
    
    self.mTableView.mj_footer.hidden = response.pois.count != self.pageCount;
    
    [self.mTableView.mj_header endRefreshing];
    
}

#pragma mark TableView delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"SelectLocationCell";
    SelectLocationCell *cell    = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    AMapPOI *info               = self.addressArray[indexPath.row];
    cell.textLabel.text         = info.name.length > 0 ? info.name : info.city;
    cell.detailTextLabel.text   = info.address;
    
    cell.accessoryType  = UITableViewCellAccessoryNone;
    
    if (self.oldPoi && indexPath.row == 2) {
        if (self.isSelectCity) {
            cell.accessoryType  = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType  = UITableViewCellAccessoryCheckmark;
        }
    }else if (!self.oldPoi        && indexPath.row == 0) {
        cell.accessoryType      = UITableViewCellAccessoryCheckmark;
    }else if (self.isSelectCity   && indexPath.row == 1){
        cell.accessoryType      = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AMapPOI *info = self.addressArray[indexPath.row];
    if (self.successBlock) {
        self.successBlock([info.name isEqualToString:SelectLocation_Not_Show] ? nil : info);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark - get set
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView = ({
            __weak __typeof(self) weakSelf = self;
            
            UITableView *mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - (_IPHONE_X?83:49))];
            mTableView.showsHorizontalScrollIndicator = NO;
            mTableView.showsVerticalScrollIndicator   = NO;
            mTableView.dataSource                     = self;
            mTableView.delegate                       = self;
            mTableView.tableFooterView                = [UIView new];
            [mTableView registerClass:[SelectLocationCell class] forCellReuseIdentifier:@"SelectLocationCell"];
            
            mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf headRefreshing];
            }];
            mTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                __strong __typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf footRefreshing];
            }];
            mTableView;
        });
    }
    return _mTableView;
}

- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = ({
            [[NSMutableArray alloc] init];
        });
    }
    return _addressArray;
}

- (AMapSearchAPI *)search{
    if (!_search) {
        _search = ({
            AMapSearchAPI *api = [[AMapSearchAPI alloc] init];
            api.delegate       = self;
            api;
        });
    }
    return _search;
}

- (void)setSuccessBlock:(SelectLocationSuccessBlock)successBlock{
    _successBlock = successBlock;
}

@end
