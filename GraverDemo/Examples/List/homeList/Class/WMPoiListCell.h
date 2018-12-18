//
//  WMPoiCell.h
//  WMHomelist
//
//  Created by yan on 2018/11/14.
//  Copyright © 2018年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMPoiListCellData.h"
#import <WMGBaseCell.h>

@protocol tagClickDelegate <NSObject>

- (void)tagDidClickInCell:(WMGBaseCell *)cell;

@end

NS_ASSUME_NONNULL_BEGIN

@interface WMPoiListCell : WMGBaseCell

@end

NS_ASSUME_NONNULL_END
