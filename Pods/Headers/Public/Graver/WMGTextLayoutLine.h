//
//  WMGTextLayoutLine.h
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
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>
#import "WMGFontMetrics.h"

@class WMGTextLayout;

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextLayoutLine : NSObject<NSCopying, NSMutableCopying>

/**
 *  根据一个CTLineRef进行初始化
 *
 *  @param lineRef CoreText的行
 *  @param baselineOrigin 基线原点
 *  @param textLayout 行所在的TextLayout
 *
 *  @return WMGTextLayoutLine
 */
- (instancetype)initWithCTLine:(CTLineRef)lineRef
                baselineOrigin:(CGPoint)baselineOrigin
                    textLayout:(WMGTextLayout *)textLayout;

/**
 *  根据一个截断前的原始CTLineRef、人为截断的CTLineRef进行初始化
 *
 *  @param lineRef 截断前CoreText的行
 *  @param truncatedLineRef 截断后的CoreText的行
 *  @param baselineOrigin 基线原点
 *  @param textLayout 行所在的TextLayout
 *
 *  @return WMGTextLayoutLine
 */
- (instancetype)initWithCTLine:(CTLineRef)lineRef
                 truncatedLine:(nullable CTLineRef)truncatedLineRef
                baselineOrigin:(CGPoint)baselineOrigin
                    textLayout:(WMGTextLayout *)textLayout;

// 被封装的行，如果未截断代表原始行，如果截断代表截断后的行，注意截断行是人为创建的
@property (nonatomic, assign, readonly) CTLineRef lineRef;

// 原始行坐标,UIKit坐标系统
@property (nonatomic, assign, readonly) CGRect originalLineRect;

// 行坐标，是经过基线等调整后的结果，UIKit坐标系统
@property (nonatomic, assign, readonly) CGRect lineRect;

// 原始基线原点，UIKit坐标系统
@property (nonatomic, assign, readonly) CGPoint originalBaselineOrigin;

// 基线原点，UIKit坐标系统
@property (nonatomic, assign, readonly) CGPoint baselineOrigin;

// 该行对应的字符Range，截断前的值，例如最后一行是截断的，那么它的Range可能是（12， 10）
@property (nonatomic, assign, readonly) NSRange originStringRange;

// 该行对应的截断字符Range，截断后的值，例如最后一行是截断的，那么它的截断后Range是（0， 10）
@property (nonatomic, assign, readonly) NSRange truncatedStringRange;

// 行原始FontMetrics
@property (nonatomic, assign, readonly) WMGFontMetrics originalFontMetrics;

// 经过基线调校后的FontMetrics
@property (nonatomic, assign, readonly) WMGFontMetrics fontMetrics;

// 删除线对应的Frame
@property (nonatomic, strong, readonly, nullable) NSArray *strikeThroughFrames;

// 标记该行是否是截断行
@property (nonatomic, assign, readonly) BOOL truncated;

/**
 * 计算指定索引位置字符相对于行基线原点的偏移量
 *
 * @param characterIndex 全体字符范围内的字符索引
 *
 * @return 水平偏移量
 */
- (CGFloat)offsetXForCharacterAtIndex:(NSUInteger)characterIndex;

/**
 * 计算指定索引位置字符相对于行基线原点的偏移坐标Point
 *
 * @param characterIndex 全体字符范围内的字符索引
 *
 * @return 水平偏移点的坐标
 */
- (CGPoint)baselineOriginForCharacterAtIndex:(NSUInteger)characterIndex;

/**
 * 计算指定位置对应的字符索引，进而我们可以获取到点击位置的字符
 *
 * @param position 触摸位置
 *
 * @return 字符索引
 */
- (NSUInteger)characterIndexForBoundingPosition:(CGPoint)position;

/**
 * 遍历当前行中的所有Runs，Runs即当前行中插入的所有文本组件
 *
 * @param block 以block方式回调每个CTRun对应的索引，附加属性参数，对应的字符Range
 *
 */
- (void)enumerateRunsUsingBlock:(void (^)(NSUInteger idx, NSDictionary *attributes, NSRange characterRange, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
