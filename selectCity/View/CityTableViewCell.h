//
//  CityTableViewCell.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/21.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CityTableViewCell : UITableViewCell
{
    NSArray * _cityArray;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cityArray:(NSArray*)array;
@property (nonatomic,copy)void(^didSelectedBtn)(int tag);
@end
