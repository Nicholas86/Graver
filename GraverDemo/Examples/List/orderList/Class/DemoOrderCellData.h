//
//  DemoOrderListViewModel.h
//  WMCoreText
//
//  Created by jiangwei on 2018/11/27.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderModel.h"
#import "WMGBaseCellData.h"
NS_ASSUME_NONNULL_BEGIN

@interface DemoOrderCellData : WMGBaseCellData
@property (nonatomic, strong) NSMutableArray <WMGVisionObject *> * textDrawerDatas;

@end

NS_ASSUME_NONNULL_END
