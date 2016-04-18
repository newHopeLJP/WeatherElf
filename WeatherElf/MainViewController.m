//
//  MainViewController.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/18.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "MainViewController.h"
#import "WeatherViewController.h"
#import "CityPool.h"

#define kDEFAULT_BACKGROUND_GRADIENT    @"gradient5"

@interface MainViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UILabel *locationLable;
@property (weak, nonatomic) IBOutlet UIScrollView *weatherScrollView;

@property (strong,nonatomic) WeatherViewController *curWeatherViewController;
@property (strong,nonatomic) NSDictionary *bgPictureDict;

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

- (void)addController{
    for (int i=0; i<[CityPool shareCityPool].cities.count; i++) {
        UIStoryboard *sb=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        WeatherViewController *weatherVC=[sb instantiateViewControllerWithIdentifier:@"weather"];
        weatherVC.locationName=[CityPool shareCityPool].cities[i];
        [self addChildViewController:weatherVC];
    }
   
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


@end
