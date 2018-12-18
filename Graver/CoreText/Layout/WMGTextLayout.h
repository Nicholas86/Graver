//
//  WMGTextLayout.h
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
#import "WMGFontMetrics.h"

extern CGFloat const WMGTextLayoutMaximumWidth;
extern CGFloat const WMGTextLayoutMaximumHeight;

@class WMGTextLayout;
@class WMGTextLayoutFrame;

@protocol WMGTextLayoutDelegate <NSObject>

/**
 * 当发生截断时，获取截断行的高度
 *
 * @param textLayout 排版模型
 * @param lineRef CTLineRef类型，截断行
 * @param index 截断行的行索引号
 *
 */
@optional
- (CGFloat)textLayout:(WMGTextLayout *)textLayout maximumWidthForTruncatedLine:(CTLineRef)lineRef atIndex:(NSUInteger)index;

@end

/*
 WMGTextlayout是对CoreText排版的封装、入口类
 */
@interface WMGTextLayout : NSObject

// 待排版的AttributedString
@property (nonatomic, strong, nullable) NSAttributedString *attributedString;

// 可排版区域的size
@property (nonatomic, assign) CGSize size;

// 最大排版行数，默认为0即不限制排版行数
@property (nonatomic, assign) NSUInteger maximumNumberOfLines;

// 是否自动获取 baselineFontMetrics，如果为 YES，将第一行的 fontMetrics 作为 baselineFontMetrics
@property (nonatomic, assign) BOOL retriveFontMetricsAutomatically;

// 待排版的AttributedString的基线FontMetrics，当retriveFontMetricsAutomatically=YES时，该值框架内部会自动获取
@property (nonatomic, assign) WMGFontMetrics baselineFontMetrics;

// 布局受高度限制，如自动截断超过高度的部分，默认为 YES
@property (nonatomic, assign) BOOL heightSensitiveLayout;

// 如果发生截断，由truncationString指定截断显示内容，默认"..."
@property (nonatomic, strong, nullable) NSAttributedString *truncationString;

// 排版模型的代理
@property (nonatomic, weak, nullable) id<WMGTextLayoutDelegate> delegate;

// 标记当前排版结果需要更新
- (void)setNeedsLayout;
@end

@interface WMGTextLayout (LayoutResult)
// 标记当前排版结果是否为最新的
@property (nonatomic, assign, readonly) BOOL layoutUpToDate;

// 排版结果
@property (nonatomic, strong, readonly) WMGTextLayoutFrame *layoutFrame;

@end

