//
//  WeatherData.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

- (instancetype)initWithDict:(NSDictionary *)dict{
    self=[super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (WeatherData *)weatherDataWithDict:(NSDictionary *)dict{
    return [[WeatherData alloc]initWithDict:dict];
}

@end
