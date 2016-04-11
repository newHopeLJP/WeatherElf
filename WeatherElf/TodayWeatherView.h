//
//  TodayWeather.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"

@class TodayWeatherView;
@protocol TodayWeatherViewDelegate <NSObject>

- (void)todayWeatherView:(TodayWeatherView *)todayWeatherView pm25Value:(NSInteger)pm25 pm25Description:(NSString*)description;

@end

@interface TodayWeatherView : UIView

@property (nonatomic,assign) NSInteger pm25;
@property (nonatomic,copy) NSString *currentCity;

@property (weak,nonatomic) id<TodayWeatherViewDelegate> delegate;

- (void)loadWeatherData:(WeatherData *)weatherData;

+ (TodayWeatherView *)loadFromNib;

@end
