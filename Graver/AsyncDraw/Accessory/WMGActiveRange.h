//
//  WMGActiveRange.h
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

typedef NS_ENUM(NSInteger, WMGActiveRangeType)
{
    WMGActiveRangeTypeUnknow         = 0,
    WMGActiveRangeTypeURL            = 1,
    WMGActiveRangeTypeEmail          = 2,
    WMGActiveRangeTypePhone          = 3,
    WMGActiveRangeTypeAttachment     = 4,
    WMGActiveRangeTypeText           = 5,
};

/*
 激活区，定义了混排图文中可相应点击的组件
 */
@protocol WMGActiveRange <NSObject>

// 激活区类型 现仅有Attachment使用
@property (nonatomic, assign) WMGActiveRangeType type;

// 标识激活区在AttributedString中的位置
@property (nonatomic, assign) NSRange range;

// 如果是可点击文本，代表该文本内容
@property (nonatomic, copy) NSString *text;

// 涉及处理的相关数据
@property (nonatomic, strong) id bindingData;

@end
