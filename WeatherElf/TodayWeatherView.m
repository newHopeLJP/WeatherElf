//
//  TodayWeather.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "TodayWeatherView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TodayWeatherView ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *pm25Label;

@property (nonatomic,assign,getter=isDay) BOOL day;



@end

IB_DESIGNABLE
@implementation TodayWeatherView

- (void)loadWeatherData:(WeatherData *)weatherData{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    dateFormatter.locale=[NSLocale currentLocale];
    dateFormatter.dateFormat=@"yyyy年MM月dd日";
    self.dateLabel.text=[dateFormatter stringFromDate:[NSDate date]];
    if (self.isDay) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:weatherData.dayPictureUrl]];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:weatherData.nightPictureUrl]];
    }
    
    //显示实时温度  原始值  "周六 04月09日 (实时：24℃)"
    NSArray<NSString *> *array=[weatherData.date componentsSeparatedByString:@"："];
    if (array&&array.count>1) {
        self.temperatureLabel.text=[array[1] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@")"]];
    }else{
        self.temperatureLabel.text=weatherData.temperature;
    }
    
    self.descLabel.text=[NSString stringWithFormat:@"%@ | %@",weatherData.weather,weatherData.wind];
}

/**
 *  指示当前是否是白天
 *
 *  @return 当前若是白天，则返回YES，否则返回NO
 */
- (BOOL)isDay{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH"];
    NSString *str = [formatter stringFromDate:[NSDate date]];
    int time = [str intValue];
    if (time>=18||time<=06) {
       return NO;
    }
    else{
       return YES;
    }
}

- (void)setPm25:(NSInteger)pm25{
    _pm25=pm25;
    NSString *pm25Desc;
    NSString *format=@"%ld%@";
    NSString *level;
    if (pm25<=50) {
        level=@"优";
    }else if(pm25<=100){
        level=@"良";
    }else if(pm25<=150){
        level=@"轻度污染";
    }else if(pm25<=200){
        level=@"中度污染";
    }else if(pm25<=300){
        level=@"重度污染";
    }else{//>300
        level=@"严重污染";
    }
    pm25Desc=[NSString stringWithFormat:format,pm25,level];
    self.pm25Label.text=pm25Desc;
    if (self.delegate&&[self.delegate respondsToSelector:@selector(todayWeatherView:pm25Value:pm25Description:)]) {
        [self.delegate todayWeatherView:self pm25Value:pm25 pm25Description:level];
    }
        
}

- (void)setCurrentCity:(NSString *)currentCity{
    _currentCity=currentCity;
    self.dateLabel.text=[NSString stringWithFormat:@"%@ %@",self.dateLabel.text,currentCity];
}

+ (TodayWeatherView *)loadFromNib{
    return [[[NSBundle mainBundle] loadNibNamed:@"TodayWeatherView" owner:self options:nil] lastObject];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
