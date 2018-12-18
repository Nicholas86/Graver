//
//  WMGTextActiveRange.m
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
    

#import "WMGTextActiveRange.h"

@implementation WMGTextActiveRange
@synthesize type = _type, range = _range, text = _text, bindingData = _bindingData;

+ (instancetype)activeRange:(NSRange)range type:(WMGActiveRangeType)type text:(NSString *)text
{
    WMGTextActiveRange *r = [[WMGTextActiveRange alloc] init];
    r.range = range;
    r.type = type;
    r.text = text;
    
    return r;
}

@end
