//
//  WMGTextActiveRange.h
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
#import "WMGActiveRange.h"

@interface WMGTextActiveRange : NSObject<WMGActiveRange>

/**
 * 创建一个激活区，框架内部使用
 *
 * @param range 激活区对应的range
 * @param type 激活区类型
 * @param text 如果是非WMGActiveRangeTypeAttachment类型的指定才有意义
 *
 * @return 激活区
 */
+ (instancetype)activeRange:(NSRange)range type:(WMGActiveRangeType)type text:(NSString *)text;

@end
