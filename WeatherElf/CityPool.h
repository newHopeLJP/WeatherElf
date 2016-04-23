//
//  CityPool.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/10.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,CityPoolChangedType){
    CityPoolChangedTypeAdd,
    CityPoolChangedTypeRemove
};

@protocol CityPoolDelegate <NSObject>

@optional
- (void)cityPoolChangedWithCity:(NSString *)city changedType:(CityPoolChangedType)changedType;

@end




@interface CityPool : NSObject

@property (nonatomic,weak)id<CityPoolDelegate> delegate;
@property (nonatomic,strong,readonly) NSArray<NSString *> *cities;

- (void)addCityByName:(NSString *)cityName;

- (NSString *)cityBeforeCity:(NSString *)city;

- (NSString *)cityAfterCity:(NSString *)city;

+ (CityPool *)shareCityPool;

@end
