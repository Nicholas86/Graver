//
//  WMGBaseCellData.h
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
#import <CoreGraphics/CoreGraphics.h>
#import "WMGClientData.h"

typedef NS_ENUM(NSInteger, WMGCellSeparatorLineStyle) {
    //没有线
    WMGCellSeparatorLineStyleNone,
    //左侧留有空白
    WMGCellSeparatorLineStyleLeftPadding,
    //右侧留有空白
    WMGCellSeparatorLineStyleRightPadding,
    //双侧无空白
    WMGCellSeparatorLineStyleNonePadding,
};

NS_ASSUME_NONNULL_BEGIN

@interface WMGBaseCellData : NSObject

// cell宽度
@property (nonatomic, assign) CGFloat cellWidth;

// cell高度
@property (nonatomic, assign) CGFloat cellHeight;

// 视图分割线样式
@property (nonatomic, assign) WMGCellSeparatorLineStyle separatorStyle;

// 根据该属性值反射UI数据对应的视图Class，子类可以通过覆盖方式指定，默认取当前类同名对应的Cell
// 例如: WMGListCellData -> WMGListCell
@property (nonatomic, assign, readonly) Class cellClass;

// UI数据对应的业务数据
@property (nonatomic, weak) id <WMGClientData> metaData;

@end

NS_ASSUME_NONNULL_END
