//
//  LifeIndex.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  生活指数
 */
@interface LifeIndex : NSObject

@property (nonatomic,copy) NSString *title; //指数title分为:穿衣、洗车、感冒、运动、紫外线这几个类型
@property (nonatomic,copy) NSString *zs;    //指数取指，不同指数描述不一
@property (nonatomic,copy) NSString *tipt;  //指数含义
@property (nonatomic,copy) NSString *des;   //指数详情

/**
 *  使用JSON字典生成一个LifeIndex实例对象
 *
 *  @param dict JSON字典
 *
 *  @return 新生成的LifeIndex对象
 */
- (instancetype)initWithDict:(NSDictionary *)dict;

/**
 *  根据JSON字典生成相应的LifeIndex实例对象（类方法）
 *
 *  @param dict JSON字典
 *
 *  @return 新生成的LifeIndex对象
 */

+ (LifeIndex *)lifeIndexWithDict:(NSDictionary *)dict;

@end
