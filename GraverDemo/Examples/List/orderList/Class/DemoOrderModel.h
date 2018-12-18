//
//  DemoOrderModel.h
//  WMCoreText
//
//  Created by jiangwei on 2018/11/27.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMGBusinessModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DemoOrderButtonInfo : NSObject
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) BOOL highlight;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface DemoOrderProductInfo : NSObject
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, assign) NSInteger productCount;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface DemoOrderLabelInfo : NSObject
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * contentColor;
@property (nonatomic, copy) NSString * labelFrameColor;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

@interface DemoOrderModel : WMGBusinessModel

@property (nonatomic, copy) NSString * poiPic;
@property (nonatomic, copy) NSString * poiName;
@property (nonatomic, copy) NSString * statusDescription;
@property (nonatomic, copy) NSString * totalPrice;
@property (nonatomic, copy) NSArray <DemoOrderButtonInfo *> * buttonList;
@property (nonatomic, copy) NSArray <DemoOrderProductInfo *> * productList;
@property (nonatomic, copy) NSArray <DemoOrderLabelInfo *> * labelList;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
