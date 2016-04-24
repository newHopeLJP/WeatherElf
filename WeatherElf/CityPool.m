//
//  CityPool.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/10.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "CityPool.h"

@interface CityPool ()

@property (nonatomic,strong) NSMutableArray<NSString *> *cityList;

@end


@implementation CityPool

+ (CityPool *)shareCityPool{
    
    static CityPool *cityPool=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cityPool=[[CityPool alloc]init];
    });
    return cityPool;
}

- (NSString *)cityBeforeCity:(NSString *)city{
    for (int i=0; i<self.cityList.count; i++) {
        if ([self.cityList[i] isEqualToString:city]) {
            if ((i-1)>=0) {
                return self.cityList[i-1];
            }
        }
    }
    return city;//匹配不到则返回原值
}


- (NSString *)cityAfterCity:(NSString *)city{
    for (int i=0; i<self.cityList.count; i++) {
        if ([self.cityList[i] isEqualToString:city]) {
            if ((i+1)<self.cityList.count) {
                return self.cityList[i+1];
            }
        }
    }
    return city;//匹配不到则返回原值
}

- (void)addCityByName:(NSString *)cityName{
    if (![self.cityList containsObject:cityName]) {
        [self.cityList addObject:cityName];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(cityPoolChangedWithCity:changedType:)]) {
            [self.delegate cityPoolChangedWithCity:cityName changedType:CityPoolChangedTypeAdd];
        }
    }
}

- (void)insertCity:(NSString *)city atIndex:(NSUInteger)index{
    if (![self.cityList containsObject:city]) {
        [self.cityList insertObject:city atIndex:index];
        if (self.delegate &&[self.delegate respondsToSelector:@selector(cityPoolChangedWithCity:changedType:)]) {
            [self.delegate cityPoolChangedWithCity:city changedType:CityPoolChangedTypeAdd];
        }
    }

}

- (NSMutableArray<NSString *> *)cityList{
    if (!_cityList) {
        _cityList=[NSMutableArray arrayWithArray:@[@"北京",@"厦门",@"深圳",@"上海",@"广州",@"杭州",@"西安"]];
    }
    return _cityList;
}

- (NSArray<NSString *> *)cities{
    return self.cityList;
}

@end
