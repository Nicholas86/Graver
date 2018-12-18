//
//  ExamplesViewController.m
//  Graver-Meituan-Waimai
//
//  Created by yangyang
//
//  Copyright © 2018-present, Beijing Sankuai Online Technology Co.,Ltd (Meituan).  All rights reserved.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
    

#import "ExamplesViewController.h"
#import "BasicDetailViewController.h"
#import "DemoOrderListViewController.h"
#import "WMPoiListViewController.h"
#import "WMGBaseCell.h"

typedef NS_ENUM(NSUInteger, GraverDemoSection) {
    GraverDemoSection_Basic,
    GraverDemoSection_List,
};

typedef NS_ENUM(NSInteger, GraverDemoListRow) {
    GraverDemoListRow_ResturantList,
    GraverDemoListRow_OrderList,
};


@interface ExamplesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation ExamplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title =  @"Examples";
    
    _dataSource = [NSMutableArray array];
    _dataSource = @[@[@"基本使用", @"高级使用", @"文本计算", @"图片相关"], @[@"外卖商家列表", @"外卖订单列表"]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataSource count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *list = [_dataSource objectAtIndex:section];
    return [list count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 25)];
    view.backgroundColor = WMGHEXCOLOR(0xF4F4F4);
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 30, 25)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = WMGHEXCOLOR(0x333333);
    label.font = [UIFont systemFontOfSize:14];
    label.text = (section == 0) ? @"基本使用" : @"列表示例";
    
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *section = [_dataSource objectAtIndex:indexPath.section];
    NSString *text = [section objectAtIndex:indexPath.row];
    
    static NSString *graverKey = @"GraverCellKey";
    
    WMGBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:graverKey];
    if (cell == nil) {
        cell = [[WMGBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:graverKey];
        cell.textLabel.textColor = WMGHEXCOLOR(0x333333);
        cell.textLabel.font = [UIFont systemFontOfSize:18];
    }
    cell.textLabel.text = text;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    WMGBaseCellData *data = [[WMGBaseCellData alloc] init];
    data.cellWidth = self.view.frame.size.width;
    data.cellHeight = 60;
    data.separatorStyle = WMGCellSeparatorLineStyleLeftPadding;
    [cell setupCellData:data];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == GraverDemoSection_Basic) {
        BasicDetailViewController *detailVC = [[BasicDetailViewController alloc] initWithStyle:(GraverDemoBasicRow)indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if (indexPath.section == GraverDemoSection_List){
        if (indexPath.row == GraverDemoListRow_ResturantList) {
            WMPoiListViewController *resturantVC = [[WMPoiListViewController alloc] init];
            [self.navigationController pushViewController:resturantVC animated:YES];
        }
        else if (indexPath.row == GraverDemoListRow_OrderList){
            DemoOrderListViewController *orderVC = [[DemoOrderListViewController alloc] init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
    }
}

@end
