//
//  LifeIndexCollectionViewCell.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/10.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "LifeIndexCollectionViewCell.h"

@interface LifeIndexCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *zsLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation LifeIndexCollectionViewCell

- (void)setLifeIndex:(LifeIndex *)lifeIndex{
    _lifeIndex=lifeIndex;
    self.zsLabel.text=[NSString stringWithFormat:@"%@ ∙ %@",lifeIndex.title,lifeIndex.zs];
    self.descLabel.text=lifeIndex.des;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    UIColor *color=[[UIColor alloc] initWithWhite:1.0 alpha:0.6];
    self.layer.borderColor=color.CGColor;
    self.layer.borderWidth=0.25;
}

@end
