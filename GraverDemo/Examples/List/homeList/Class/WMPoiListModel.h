//
//  WMPoiModel.h
//  WMHomelist
//
//  Created by yan on 2018/11/14.
//  Copyright © 2018年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMGBusinessModel.h"

typedef NS_ENUM(NSInteger, WMPoiStatusType) {
    WMPoiStatusOK = 1,
    WMPoiStatusBusy,
    WMPoiStatusRest,
};

typedef NS_ENUM(NSInteger, WMPoiReservationStatus) {
    WMPoiReservationOpening = 0,
    WMPoiReservationOnly = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface WMPoiLabelInfo : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *contentColor;
@property (nonatomic, copy) NSString *labelBackgroundColor;
@property (nonatomic, copy) NSString *labelFrameColor;

@end


@interface WMPoiListModel : WMGBusinessModel

@property (nonatomic, copy) NSString *name;                             // 商家名称
@property (nonatomic, copy) NSString *restaurantImg;                    // 商家 logo
@property (nonatomic, copy) NSString *restaurantIcon;                   // logo 上的 icon
@property (nonatomic, assign) CGFloat star;                             // 星评
@property (nonatomic, assign) WMPoiReservationStatus reservationStatus; // 仅预定状态
@property (nonatomic, copy) NSString *statusContent;                    // 预下单左侧文案
@property (nonatomic, copy) NSString *descContent;                      // 预下单右侧文案
@property (nonatomic, copy) NSString *monthSalesTip;                    // 月售
@property (nonatomic, copy) NSString *deliveryTime;                     // 配送时间
@property (nonatomic, copy) NSString *distance;                         // 配送距离
@property (nonatomic, copy) NSString *minPriceTip;                      // 起送价
@property (nonatomic, copy) NSString *shippingFeeTip;                   // 配送价
@property (nonatomic, copy) NSString *originShippingFeeTip;             // 原始配送费
@property (nonatomic, copy) NSString *averagePriceTip;                  // 人均价
@property (nonatomic, copy) NSString *thirdCategory;                    // 主营品类
@property (nonatomic, strong) NSArray<WMPoiLabelInfo *> *labelInfoArray;// 商家标签信息;

@property (nonatomic, assign) BOOL showAlltag;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end


NS_ASSUME_NONNULL_END
