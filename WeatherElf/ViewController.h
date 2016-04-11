//
//  ViewController.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/9.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic,copy) NSString *locationName;

- (instancetype)initWithLocationName:(NSString *)locationName;

@end

