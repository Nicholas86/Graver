//
//  WMGFontMetrics.m
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
    

#import "WMGFontMetrics.h"

const WMGFontMetrics WMGFontMetricsZero = {0, 0, 0};
const WMGFontMetrics WMGFontMetricsNull = {NSNotFound, NSNotFound, NSNotFound};

static WMGFontMetrics WMGCachedFontMetrics[13];

WMGFontMetrics WMGFontDefaultMetrics(NSInteger pointSize)
{
    if (pointSize < 8 || pointSize > 20)
    {
        UIFont *font = [UIFont systemFontOfSize:pointSize];
        return WMGFontMetricsMakeFromUIFont(font);
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            for (NSInteger i = 0; i < 13; i++) {
                NSUInteger pointSize = i + 8;
                UIFont * font = [UIFont systemFontOfSize:pointSize];
                WMGCachedFontMetrics[i] = WMGFontMetricsMakeFromUIFont(font);
            }
        }
    });
    
    return WMGCachedFontMetrics[pointSize - 8];
}

