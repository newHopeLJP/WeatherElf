//
//  WeatherData.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  天气预报数据
 */
@interface WeatherData : NSObject

@property (nonatomic,strong) NSString *date;            //天气预报时间
@property (nonatomic,copy) NSString *dayPictureUrl;   //白天的天气预报图片url
@property (nonatomic,copy) NSString *nightPictureUrl; //晚上的天气预报图片url
@property (nonatomic,copy) NSString *weather;         //天气状况
@property (nonatomic,copy) NSString *wind;            //风力
@property (nonatomic,copy) NSString *temperature;     //温度

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (WeatherData *)weatherDataWithDict:(NSDictionary *)dict;

@end
