//
//  WMMutableAttributedImage.m
//  WMCoreText
//
//  Created by yan on 2018/11/19.
//  Copyright © 2018年 sankuai. All rights reserved.
//

#import "WMPoiListAttributedImage.h"

@implementation WMPoiListAttributedImage

- (WMMutableAttributedItem *)appendAttachment:(WMGTextAttachment *)att
{
    att.retriveFontMetricsAutomatically = NO;
    att.edgeInsets = UIEdgeInsetsZero;
    att.position = 0;
    att.length = 1;

    WMGFontMetrics metrics = WMGFontMetricsMakeWithTargetLineHeight(WMGFontMetricsMakeFromUIFont([UIFont systemFontOfSize:11]), floor(att.size.height));
    att.baselineFontMetrics = metrics;
    return [super appendAttachment:att];
}

@end
