//
//  CityManageController.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/21.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DidSelectCity)(NSInteger cityIndex);

@interface CityManageController : UIViewController

@property (nonatomic,copy) DidSelectCity didSelectCity;

@end
