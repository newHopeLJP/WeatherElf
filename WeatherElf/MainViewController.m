//
//  MainViewController.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/18.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherViewController.h"
#import "CityManageController.h"
#import "CityPool.h"
#import <CoreLocation/CoreLocation.h>

#define kDEFAULT_BACKGROUND_GRADIENT    @"gradient5"

@interface MainViewController ()<UIScrollViewDelegate,CityPoolDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *locationLable;
@property (weak, nonatomic) IBOutlet UIScrollView *weatherScrollView;

@property (strong,nonatomic) WeatherViewController *curWeatherViewController;
@property (strong,nonatomic) NSDictionary *bgPictureDict;
@property (strong,nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLGeocoder *geocoder;

@end

@implementation MainViewController

- (void)viewDidLoad{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIEdgeInsets insets=self.bgScrollView.contentInset;
    insets.top=10;
    self.bgScrollView.contentInset=insets;
    self.view.layer.contents = (id)[UIImage imageNamed:kDEFAULT_BACKGROUND_GRADIENT].CGImage;
    [self addController];
    
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.weatherScrollView.contentSize = CGSizeMake(contentX, 0);
    self.weatherScrollView.pagingEnabled = YES;
    self.weatherScrollView.delegate=self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPM25VauleChanged:) name:@"pm25ValueChanged" object:nil];

    // 添加默认控制器
    WeatherViewController *vc = [self.childViewControllers firstObject];
    vc.view.frame = self.weatherScrollView.bounds;
    [self.weatherScrollView addSubview:vc.view];
    self.locationLable.text=vc.locationName;
    self.weatherScrollView.showsHorizontalScrollIndicator = NO;
    self.curWeatherViewController=vc;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [[UINavigationBar appearance] setTintColor:[UIColor grayColor]];
    
    [CityPool shareCityPool].delegate=self;
    
    [self.locationManager startUpdatingLocation];
    
}

- (void)onPM25VauleChanged:(NSNotification *)notification{
    [self settingBackgroundWithPM25Level:notification.object];
}

- (void)settingBackgroundWithPM25Level:(NSString *)pm25Level{
    if (!pm25Level) {
        return;
    }
    self.view.layer.contents = (id)[UIImage imageNamed:self.bgPictureDict[pm25Level]].CGImage;
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc{
    [self.locationManager stopUpdatingLocation];
}

- (void)addController{
    for (int i=0; i<[CityPool shareCityPool].cities.count; i++) {
        [self addWeatherViewControllerByCityName:[CityPool shareCityPool].cities[i]];
    }
   
}

- (void)addWeatherViewControllerByCityName:(NSString *)city{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    WeatherViewController *weatherVC=[sb instantiateViewControllerWithIdentifier:@"weather"];
    weatherVC.locationName=city;
    [self addChildViewController:weatherVC];
}

- (NSDictionary *)bgPictureDict{
    if (!_bgPictureDict) {
        _bgPictureDict=@{@"优":@"gradient5",
                         @"良":@"gradient2",
                         @"轻度污染":@"gradient7",
                         @"中度污染":@"gradient8",
                         @"重度污染":@"gradient0",
                         @"严重污染":@"gradient9",
                         };
    }
    return _bgPictureDict;
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager=[[CLLocationManager alloc]init];
        _locationManager.delegate=self;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        _locationManager.distanceFilter=10;
        [_locationManager requestAlwaysAuthorization];
    }
    return _locationManager;
}

- (CLGeocoder *)geocoder{
    if (!_geocoder) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}

#pragma mark 根据地名确定地理坐标
-(void)getCoordinateByAddress:(NSString *)address{
    //地理编码
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        CLPlacemark *placemark=[placemarks firstObject];
        
        CLLocation *location=placemark.location;//位置
        CLRegion *region=placemark.region;//区域
        NSDictionary *addressDic= placemark.addressDictionary;//详细地址信息字典,包含以下部分信息
        //        NSString *name=placemark.name;//地名
        //        NSString *thoroughfare=placemark.thoroughfare;//街道
        //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
        //        NSString *locality=placemark.locality; // 城市
        //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
        //        NSString *administrativeArea=placemark.administrativeArea; // 州
        //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
        //        NSString *postalCode=placemark.postalCode; //邮编
        //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
        //        NSString *country=placemark.country; //国家
        //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
        //        NSString *ocean=placemark.ocean; // 海洋
        //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
        NSLog(@"位置:%@,区域:%@,详细信息:%@",location,region,addressDic);
    }];
}

#pragma mark 根据坐标取得地名
-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"获取地名失败：%@",error);
        }else{
            CLPlacemark *placemark=[placemarks firstObject];
            NSLog(@"当前城市：%@",placemark.locality);
            if (placemark.locality) {
                NSString *shortName=[placemark.locality stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"市"]];
                [CityPool shareCityPool].localCity=shortName;
                [[CityPool shareCityPool] insertCity:shortName atIndex:0];//定位城市放在第一位置
            }
           
            NSLog(@"详细信息:%@",placemark.addressDictionary);
        }
    }];
}

#pragma mark -UIScrollView Delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / self.weatherScrollView.frame.size.width;
    
   
    // 添加控制器
    WeatherViewController *newsVc = self.childViewControllers[index];
    newsVc.locationName=[CityPool shareCityPool].cities[index];
    self.locationLable.text=newsVc.locationName;
    self.locationLable.alpha=1;
    [self settingBackgroundWithPM25Level:newsVc.pm25Level];
    
    if (newsVc.view.superview) return;
    
    newsVc.view.frame = scrollView.bounds;
    [self.weatherScrollView addSubview:newsVc.view];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 取出绝对值 避免最左边往右拉时超过1
    CGFloat value = ABS(scrollView.contentOffset.x / scrollView.frame.size.width);
    NSUInteger leftIndex = (int)value;
    CGFloat alphaRight = value - leftIndex;
    CGFloat alphaLeft = 1 - alphaRight;
    
    static float newx = 0;
    static float oldx = 0;
    newx= scrollView.contentOffset.x ;
    if (newx != oldx ) {
        if (newx > oldx) {
            self.locationLable.alpha=alphaLeft;
        }else if(newx < oldx){
           self.locationLable.alpha=alphaRight;
        }
        oldx = newx;
    }
    
}

#pragma mark - CityPoolDelegate
- (void)cityPoolChangedWithCity:(NSString *)city changedType:(CityPoolChangedType)changedType{
    if (changedType==CityPoolChangedTypeAdd) {
        [self addWeatherViewControllerByCityName:city];
        
    }else if(changedType==CityPoolChangedTypeRemove){
        
    
    }
    CGFloat contentX = self.childViewControllers.count * [UIScreen mainScreen].bounds.size.width;
    self.weatherScrollView.contentSize = CGSizeMake(contentX, 0);
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *currLocation = [locations lastObject];
    NSLog(@"经度=%f 纬度=%f 高度=%f", currLocation.coordinate.latitude, currLocation.coordinate.longitude, currLocation.altitude);
    
    // 当前所在地的使用语言
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSLog(@"Language Code is %@", [currentLocale objectForKey:NSLocaleLanguageCode]);
    
    [self getAddressByLatitude:currLocation.coordinate.latitude longitude:currLocation.coordinate.longitude];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code] == kCLErrorDenied)
    {
        NSLog(@"%@",@"访问被拒绝");
    }
    if ([error code] == kCLErrorLocationUnknown) {
        NSLog(@"%@",@"无法获取位置信息");
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"错误" message:@"无法获取位置信息" preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - StroyboardSegue Prepare

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isMemberOfClass:[CityManageController class]]) {
        CityManageController *toVC=segue.destinationViewController;
        toVC.didSelectCity=^(NSInteger cityIndex){
            CGPoint newOffset=CGPointMake(self.weatherScrollView.frame.size.width*cityIndex,0);
            [self.weatherScrollView setContentOffset:newOffset animated:YES];
//            self.weatherScrollView.contentOffset=newOffset;
//            [self scrollViewDidEndDecelerating:self.weatherScrollView];//手动调用
        };
    }
}

@end
