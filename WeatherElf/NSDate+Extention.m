//
//  NSDate+Extention.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/10.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "NSDate+Extention.h"

@implementation NSDate (Extention)

+ (BOOL)isDay{
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

@end
