//
//  LifeIndex.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "LifeIndex.h"


@implementation LifeIndex

- (instancetype)initWithDict:(NSDictionary *)dict{
    self=[super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (LifeIndex *)lifeIndexWithDict:(NSDictionary *)dict{
    return [[LifeIndex alloc] initWithDict:dict];
}

@end
