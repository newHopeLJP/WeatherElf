//
//  ResultCityController.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/21.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ResultCityControllerDelegate <NSObject>

-(void)didScroll;
-(void)didSelectedString:(NSString *)string;

@end

@interface ResultCityController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,retain)NSMutableArray *dataArray;
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,assign) id <ResultCityControllerDelegate>delegate;
@end
