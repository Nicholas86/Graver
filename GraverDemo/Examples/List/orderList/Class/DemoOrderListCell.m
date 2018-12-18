//
//  DemoOrderListCell.m
//  WMCoreText
//
//  Created by jiangwei on 2018/11/28.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderListCell.h"
#import "DemoOrderListContentView.h"
#import "DemoOrderCellData.h"

@interface DemoOrderListCell ()
@property (nonatomic, strong) DemoOrderListContentView * orderContentView;
@end

@implementation DemoOrderListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _orderContentView = [[DemoOrderListContentView alloc] initWithFrame:CGRectMake(10, 5, 0, 0)];
        _orderContentView.cornerRadius = 2;
        _orderContentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_orderContentView];
    }
    return self;
}

- (void)setupCellData:(DemoOrderCellData *)cellData
{
    _orderContentView.frame = CGRectMake(10, 5, cellData.cellWidth, cellData.cellHeight-10);
    _orderContentView.textDrawerDatas = cellData.textDrawerDatas;
}


@end
