//
//  WeatherForecastInfo.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LifeIndex.h"
#import "WeatherData.h"

/**
 *  天气预报信息
 */
@interface WeatherForecastInfo : NSObject

//@property (nonatomic,strong) NSDate *date;                     //当前时间
@property (nonatomic,strong) NSString *currentCity;              //当前城市
@property (nonatomic,assign) NSInteger pm25;                     //PM2.5
@property (nonatomic,copy) NSArray<LifeIndex *> *index;          //生活指数
@property (nonatomic,copy) NSArray<WeatherData *> *weatherData;  //天气数据

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (WeatherForecastInfo *)weatherForecastInfoWithDict:(NSDictionary *)dict;

@end
