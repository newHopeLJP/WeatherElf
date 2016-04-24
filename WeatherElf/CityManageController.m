//
//  CityManageController.m
//  WeatherElf
//
//  Created by 新新希冀 on 16/4/21.
//  Copyright © 2016年 Linjianping's Awesome App House. All rights reserved.
//

#import "CityManageController.h"
#import "CityViewController.h"
#import "CityPool.h"

@interface CityManageController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CityManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setTableFooterView:[[UIView alloc]initWithFrame:CGRectZero]];
    [self alignTableViewCellHorizontalMargin];
    self.navigationItem.title=@"位置管理";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:19.0]}];
}

- (void)alignTableViewCellHorizontalMargin{
    UIEdgeInsets seperatrorInset=self.tableView.separatorInset;
    seperatrorInset.right=seperatrorInset.left;
    self.tableView.separatorInset=seperatrorInset;
    
    UIEdgeInsets layoutMargins=self.tableView.layoutMargins;
    layoutMargins.right=layoutMargins.left;
    self.tableView.layoutMargins=layoutMargins;
}

- (IBAction)addCity:(UIButton *)sender {
    CityViewController *cityViewController=[[CityViewController alloc]init];
    cityViewController.currentCityString=@"北京";
    cityViewController.selectString=^(NSString *city){
        [[CityPool shareCityPool] addCityByName:city];
        [self.tableView reloadData];
    };
    
    [self presentViewController:cityViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [CityPool shareCityPool].cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    if (indexPath.row==0) {
        cell=[tableView dequeueReusableCellWithIdentifier:@"currentCityCell" forIndexPath:indexPath];
        cell.textLabel.text=[CityPool shareCityPool].cities[indexPath.row];
        cell.detailTextLabel.text=@"当前位置";
        cell.detailTextLabel.font=[UIFont systemFontOfSize:13];
    }else{
        cell=[tableView dequeueReusableCellWithIdentifier:@"cityCell" forIndexPath:indexPath];
        cell.textLabel.text=[CityPool shareCityPool].cities[indexPath.row];
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.didSelectCity) {
        self.didSelectCity(indexPath.row);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row!=0) {
        return;
    }
    CGRect imageRect=cell.textLabel.frame;
    imageRect.origin.x=CGRectGetMaxX(cell.textLabel.frame)+5;
    imageRect.size.width=20;
    imageRect.size.height=20;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:imageRect];
    imageView.image=[UIImage imageNamed:@"location-marker"];
    [cell.contentView addSubview:imageView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
