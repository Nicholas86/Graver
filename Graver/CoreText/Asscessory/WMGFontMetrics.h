//
//  WMGFontMetrics.h
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
    

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

struct WMGFontMetrics {
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
};

typedef struct WMGFontMetrics WMGFontMetrics;

static inline WMGFontMetrics WMGFontMetricsMake(CGFloat a, CGFloat d, CGFloat l)
{
    WMGFontMetrics metrics;
    metrics.ascent = a;
    metrics.descent = d;
    metrics.leading = l;
    return metrics;
}

extern const WMGFontMetrics WMGFontMetricsZero;
extern const WMGFontMetrics WMGFontMetricsNull;

static inline WMGFontMetrics WMGFontMetricsMakeFromUIFont(UIFont * font)
{
    if (!font) {
        return WMGFontMetricsNull;
    }
    
    WMGFontMetrics metrics;
    metrics.ascent = ABS(font.ascender);
    metrics.descent = ABS(font.descender);
    metrics.leading = ABS(font.lineHeight) - metrics.ascent - metrics.descent;
    return metrics;
}

static inline WMGFontMetrics WMGFontMetricsMakeFromCTFont(CTFontRef font)
{
    return WMGFontMetricsMake(ABS(CTFontGetAscent(font)), ABS(CTFontGetDescent(font)), ABS(CTFontGetLeading(font)));
}

static inline WMGFontMetrics WMGFontMetricsMakeWithTargetLineHeight(WMGFontMetrics metrics, CGFloat targetLineHeight)
{
    return WMGFontMetricsMake(targetLineHeight - metrics.descent - metrics.leading, metrics.descent, metrics.leading);
}

static inline CGFloat WMGFontMetricsGetLineHeight(WMGFontMetrics metrics)
{
    return ceil(metrics.ascent + metrics.descent + metrics.leading);
}

static inline BOOL WMGFontMetricsEqual(WMGFontMetrics m1, WMGFontMetrics m2)
{
    return m1.ascent == m2.ascent && m1.descent == m2.descent && m1.leading == m2.leading;
}

static inline NSInteger WMGFontMetricsHash(WMGFontMetrics metrics)
{
    CGRect concrete = CGRectMake(metrics.ascent, metrics.descent, metrics.leading, 0);
    return [NSStringFromCGRect(concrete) hash];
}

extern WMGFontMetrics WMGFontDefaultMetrics(NSInteger pointSize);
