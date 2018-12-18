//
//  DemoOrderListViewModel.m
//  WMCoreText
//
//  Created by jiangwei on 2018/11/27.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderCellData.h"
#import "WMGTextDrawer.h"
#import "UIImage+Graver.h"

@interface DemoOrderCellData ()
@end

@implementation DemoOrderCellData

- (instancetype)init
{
    if (self = [super init]) {
        _textDrawerDatas = [NSMutableArray array];
    }
    return self;
}


- (Class)cellClass{
    return NSClassFromString(@"DemoOrderListCell");
}

@end
