//
//  CustomTopView.h
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/21.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol CustomTopViewDelegate <NSObject>

-(void)didSelectBackButton;

@end

@interface CustomTopView : UIView
@property (nonatomic,assign) id <CustomTopViewDelegate>delegate;
@end
