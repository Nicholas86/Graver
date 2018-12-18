//
//  DemoOrderModel.m
//  WMCoreText
//
//  Created by jiangwei on 2018/11/27.
//  Copyright © 2018 sankuai. All rights reserved.
//

#import "DemoOrderModel.h"

@implementation DemoOrderButtonInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.title = [dict objectForKey:@"title"];
        self.highlight = [[dict objectForKey:@"highlight"] boolValue];
    }
    return self;
}

@end

@implementation DemoOrderProductInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.productName = [dict objectForKey:@"food_name"];
        self.productCount = [[dict objectForKey:@"food_count"] integerValue];
    }
    return self;
}

@end

@implementation DemoOrderLabelInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.content = [dict objectForKey:@"content"];
        self.contentColor = [dict objectForKey:@"content_color"];
        self.labelFrameColor = [dict objectForKey:@"label_frame_color"];
    }
    return self;
}

@end

@implementation DemoOrderModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.poiPic = [dict objectForKey:@"business_pic"];
        self.poiName = [dict objectForKey:@"business_name"];
        self.statusDescription = [dict objectForKey:@"status_description"];
        self.totalPrice = [NSString stringWithFormat:@"￥%.1f",[[dict objectForKey:@"total"] floatValue]];
        NSArray * buttonJSONArr = [dict objectForKey:@"button_list"];
        NSMutableArray * buttonArray = [NSMutableArray array];
        for (NSDictionary * dic in buttonJSONArr) {
            DemoOrderButtonInfo * buttonInfo = [[DemoOrderButtonInfo alloc] initWithDictionary:dic];
            [buttonArray addObject:buttonInfo];
        }
        self.buttonList = buttonArray;
        
        NSArray * productJSONArray = [dict objectForKey:@"food_list"];
        NSMutableArray * productArray = [NSMutableArray array];
        for (NSDictionary * dic in productJSONArray) {
            DemoOrderProductInfo * productInfo = [[DemoOrderProductInfo alloc] initWithDictionary:dic];
            [productArray addObject:productInfo];
        }
        self.productList = productArray;
        NSArray * labelJSONArray = [[dict objectForKey:@"business_extension_info"] objectForKey:@"business_label_info"];
        NSMutableArray * labelArray = [NSMutableArray array];
        for (NSDictionary * dic in labelJSONArray) {
            DemoOrderLabelInfo * labelInfo = [[DemoOrderLabelInfo alloc] initWithDictionary:dic];
            [labelArray addObject:labelInfo];
        }
        self.labelList = labelArray;

    }
    return self;
}

@end
