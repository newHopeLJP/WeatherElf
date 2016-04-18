//
//  ViewController.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "WeatherViewController.h"
#import "MJRefresh.h"
#import "TodayWeatherView.h"
#import "WeatherForecastInfo.h"
#import "WeatherCollectionViewCell.h"
#import "LifeIndexCollectionViewCell.h"
#import "CityPool.h"

#define kDEFAULT_BACKGROUND_GRADIENT    @"gradient5"
#define kDEFAULT_LOCATION_NAME          @"北京"
#define kWEATHER_API_KEY                @"E2ee198403a6b10416b9afea3e9273a9"

#define kWEATHER_API             @"http://api.map.baidu.com/telematics/v3/weather?location=%@&output=json&ak=%@"



@interface WeatherViewController ()<UICollectionViewDataSource,TodayWeatherViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *lifeIndexCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *lifeIndexLayout;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (strong,nonatomic) NSURLSession *session;
@property (strong,nonatomic) NSMutableURLRequest *request;
@property (strong,nonatomic) TodayWeatherView *todayWeatherView;
@property (strong,nonatomic) WeatherForecastInfo *weatherForecastInfo;
@property (strong,nonatomic) NSDictionary *bgPictureDict;

@property (strong,nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end

@implementation WeatherViewController

- (instancetype)initWithLocationName:(NSString *)locationName{
    self=[super init];
    if (self) {
        _locationName=locationName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.topView addSubview:self.todayWeatherView];
    [self setupRefreshView];
    [self setupPageControl];
    [self loadWeatherData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (void)setupPageControl{
    self.pageControl.numberOfPages=[CityPool shareCityPool].cities.count;
    self.pageControl.hidden=YES;
}

- (void)setupRefreshView {
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"%s",__FUNCTION__);
        [self loadWeatherData];
        [self.scrollView.header endRefreshing];
    }];
    
//    header.ignoredScrollViewContentInsetTop=15;
    
    header.stateLabel.textColor = [UIColor whiteColor];
    header.lastUpdatedTimeLabel.textColor = [UIColor whiteColor];
    
    self.scrollView.header=header;
}


- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.todayWeatherView.frame=self.topView.bounds;
    CGFloat height=self.lifeIndexLayout.itemSize.width;
    CGFloat width=(CGRectGetWidth(self.lifeIndexCollectionView.bounds)-3*self.lifeIndexLayout.minimumInteritemSpacing)*0.5;
    self.lifeIndexLayout.itemSize=CGSizeMake(width, height);
}


-(BOOL)prefersStatusBarHidden{
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)loadWeatherData{
    NSString *urlStr=[NSString stringWithFormat:kWEATHER_API,self.locationName,kWEATHER_API_KEY];
    NSURL *url=[NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    self.request.URL=url;

    NSURLSessionDataTask *dataTask=[self.session dataTaskWithRequest:self.request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([dict[@"status"] isEqualToString:@"success"]) {
                NSArray *results=dict[@"results"];
                if (results&&results.count) {
                    self.weatherForecastInfo=[WeatherForecastInfo weatherForecastInfoWithDict:results[0]];
                }
            }
        }else{
            NSLog(@"%@",error);
        }
    }];
    [dataTask resume];
}

- (TodayWeatherView *)todayWeatherView{
    if (!_todayWeatherView) {
        _todayWeatherView=[TodayWeatherView loadFromNib];
        _todayWeatherView.delegate=self;
    }
    return _todayWeatherView;
}

- (void)setWeatherForecastInfo:(WeatherForecastInfo *)weatherForecastInfo{
    _weatherForecastInfo=weatherForecastInfo;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.todayWeatherView loadWeatherData:weatherForecastInfo.weatherData[0]];
        self.todayWeatherView.pm25=weatherForecastInfo.pm25;
//        self.todayWeatherView.currentCity=self.locationName;
        [self.collectionView reloadData];
        [self.lifeIndexCollectionView reloadData];
    });
    
}

- (NSURLSession *)session{
    if (!_session) {
        _session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    }
    return _session;
}

- (NSMutableURLRequest *)request{
    if (!_request) {
        _request=[[NSMutableURLRequest alloc] init];
        _request.cachePolicy=NSURLRequestReloadIgnoringCacheData;
    }
    return _request;
}

- (NSString *)locationName{
    if (!_locationName) {
        _locationName=kDEFAULT_LOCATION_NAME;//提供默认值，并非为了延迟加载
    }
    return _locationName;
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

#pragma mark - CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView==self.collectionView) {
       if (self.weatherForecastInfo &&self.weatherForecastInfo.weatherData) {
          return self.weatherForecastInfo.weatherData.count;
       }
       else{
          return 0;
       }
    }else{
        return 6;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView==self.collectionView) {
        WeatherCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"weatherCell" forIndexPath:indexPath];
        cell.weatherData=self.weatherForecastInfo.weatherData[indexPath.item];
        return cell;
    }else{
        LifeIndexCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"lifeIndexCell" forIndexPath:indexPath];
        cell.lifeIndex=self.weatherForecastInfo.index[indexPath.item];
        return cell;
    }
    
}

#pragma mark -TodayViewDelegate

- (void)todayWeatherView:(TodayWeatherView *)todayWeatherView pm25Value:(NSInteger)pm25 pm25Description:(NSString *)description{
//    self.view.layer.contents = (id)[UIImage imageNamed:self.bgPictureDict[description]].CGImage;
    self.pm25Level=description;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"pm25ValueChanged" object:description];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
