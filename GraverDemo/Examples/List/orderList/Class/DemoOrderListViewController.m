//
//  DemoOrderListViewController.m
//  WMCoreText
//
//  Created by jiangwei on 2018/11/27.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderListViewController.h"
#import "DemoOrderListViewModel.h"
#import "WMGBaseCell.h"
#import "WMGBaseCellData.h"
#import "DemoOrderModel.h"
#import "DemoOrderListEngine.h"
@interface DemoOrderListViewController ()
@property (nonatomic, strong) UITableView * tableview;
@property (nonatomic, strong) WMGBaseViewModel *viewModel;
@end

@implementation DemoOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setTitle:@"订单列表"];
    [self.view addSubview:self.tableview];
    
    
    _viewModel = [[DemoOrderListViewModel alloc] init];
    _viewModel.engine = [[DemoOrderListEngine alloc] init];
    
    __weak typeof(self) weakSelf = self;
    [_viewModel reloadDataWithParams:@{} completion:^(NSArray<WMGBaseCellData *> *cellLayouts, NSError *error) {
        if (weakSelf) {
            [weakSelf.tableview reloadData];
        }
    }];
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.backgroundColor = WMGHEXCOLOR(0xEEEEEE);
    }
    return _tableview;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _viewModel.arrayLayouts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGBaseCellData *cellData = [_viewModel.arrayLayouts objectAtIndex:indexPath.row];
    return cellData.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMGBaseCellData *cellData = [_viewModel.arrayLayouts objectAtIndex:indexPath.row];
    
    WMGBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellData.cellClass)];
    if (!cell) {
        cell = [(WMGBaseCell *)[cellData.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellData.cellClass)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    [cell setupCellData:cellData];

    if (!cell) {
        cell = [[WMGBaseCell alloc] init];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WMGBaseCellData *cellData = [_viewModel.arrayLayouts objectAtIndex:indexPath.row];
    DemoOrderModel *model = (DemoOrderModel *)cellData.metaData;
    model.poiName = @"xxx";
    
    [model setNeedsUpdateUIData];
    
    [_viewModel refreshModelWithResultSet:_viewModel.engine.resultSet];
    [_tableview reloadData];
}

@end
