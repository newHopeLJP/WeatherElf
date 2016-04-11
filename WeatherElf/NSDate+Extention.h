//
//  NSDate+Extention.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/10.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extention)

/**
 *  指示当前是否是白天
 *
 *  @return 白天则返回YES，晚上则返回NO
 */
+ (BOOL)isDay;

@end
