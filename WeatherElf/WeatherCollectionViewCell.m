//
//  WeatherCollectionViewCell.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/10.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "WeatherCollectionViewCell.h"
#import "NSDate+Extention.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface WeatherCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end

@implementation WeatherCollectionViewCell

- (void)setWeatherData:(WeatherData *)weatherData{
    _weatherData=weatherData;
    if (weatherData.date.length>2) {
        self.dateLabel.text=[weatherData.date substringToIndex:2];
    }else{
        self.dateLabel.text=weatherData.date;
    }
    if ([NSDate isDay]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:weatherData.dayPictureUrl]];
    }else{
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:weatherData.nightPictureUrl]];
    }
    
    self.temperatureLabel.text=weatherData.temperature;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.layer.cornerRadius=8;
    self.imageView.layer.masksToBounds=YES;
}

@end
