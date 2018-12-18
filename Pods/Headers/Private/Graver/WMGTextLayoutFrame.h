//
//  WMGTextLayoutFrame.h
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

@class WMGTextLayout;
@class WMGTextLayoutLine;

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextLayoutFrame : NSObject<NSCopying, NSMutableCopying>

@property (nonatomic, strong, readonly, nullable) NSArray <WMGTextLayoutLine *> *arrayLines;
@property (nonatomic, assign, readonly) CGSize layoutSize;

/**
 *  根据一个CTFrameRef进行初始化
 *
 *  @param frameRef    CTFrameRef
 *  @param textLayout  WMGTextLayout
 *
 *  @return WMGTextLayoutFrame
 */
- (id)initWithCTFrame:(CTFrameRef)frameRef textLayout:(WMGTextLayout *)textLayout;

/**
 *  获取一个文字 index 对应的行数
 *
 *  @param characterIndex 文字 index
 *
 *  @return 行的 index
 */
- (NSUInteger)lineIndexForCharacterAtIndex:(NSUInteger)characterIndex;

/**
 *  获取某一行 在 layout 中的 frame，并可以返回这一行文字对应的字符串范围
 *
 *  @param index                   行的 index
 *  @param effectiveCharacterRange 这一行文字对应的字符串范围
 *
 *  @return 这一行的 frame，如果 index 无效，将返回 CGRectNull
 */
- (CGRect)lineRectForLineAtIndex:(NSUInteger)index
                  effectiveRange:(NSRangePointer)effectiveCharacterRange;

/**
 *  获取某一文字 index 对应的 行 在 layout 中的 frame，并可以返回这一行文字对应的字符串范围
 *
 *  @param index                   文字的 index
 *  @param effectiveCharacterRange 文字所在行中的文字对应的字符串范围
 *
 *  @return 这一行的 frame，如果 index 无效，将返回 CGRectNull
 */
- (CGRect)lineRectForCharacterAtIndex:(NSUInteger)index
                       effectiveRange:(NSRangePointer)effectiveCharacterRange;

/**
 *  某一字符串范围对应的 frame，如果该范围中包含多行文字，则返回第一行的 frame
 *
 *  @param characterRange 字符串的范围
 *
 *  @return 文字的 frame，如果 range 无效，将返回 CGRectNull
 */
- (CGRect)firstSelectionRectForCharacterRange:(NSRange)characterRange;

/**
 *  遍历行的信息
 *
 *  @param block   传入参数分别为：行的index、行的frame、行中 文字对应的字符串范围
 */
- (void)enumerateLinesUsingBlock:(void (^)(NSUInteger idx, CGRect rect, NSRange characterRange, BOOL *stop))block;

/**
 *  遍历某一字符串范围中文字的 frame 等信息
 *
 *  @param characterRange 字符串范围
 *  @param block          如果文字存在于多行中，会被调用多次。传入参数分别为：文字的 frame、文字对应的字符串范围
 */
- (void)enumerateEnclosingRectsForCharacterRange:(NSRange)characterRange
                                      usingBlock:(void (^)(CGRect rect, NSRange characterRange, BOOL *stop))block;

/**
 *  遍历某一字符串范围中文字的 frame 等信息，用于选择区域的绘制等操作
 *
 *  @param characterRange 字符串范围
 *  @param block          如果文字存在于多行中，会被调用多次。传入参数分别为：文字的 frame、文字对应的字符串范围
 *
 *  @return 整个区域的 bounding 区域
 */
- (CGRect)enumerateSelectionRectsForCharacterRange:(NSRange)characterRange usingBlock:(nullable void (^)(CGRect rect, NSRange characterRange, BOOL *stop))block;

/**
 *  获取某一字符串 index 对应文字在 layout 中的坐标
 *
 *  @param characterIndex 字符串 index
 *
 *  @return layout 中的坐标，取 glyph 的中心点
 */
- (CGPoint)locationForCharacterAtIndex:(NSUInteger)characterIndex;

/**
 *  获取一个 frame，它包含传入字符串范围中的所有文字
 *
 *  @param characterRange 字符串范围
 *
 *  @return 包含所有文字的 frame
 */
- (CGRect)boundingRectForCharacterRange:(NSRange)characterRange;

/**
 *  获取序号为index的CTLine的起始点坐标
 *
 *  @param index CTLine的序号
 *
 *  @return CTLine的位置
 */
- (CGPoint)positionForLinesAtIndex:(NSUInteger)index;

/**
 *  获取序号为index的CTLine的rect
 *
 *  @param index CTLine的序号
 *
 *  @return CTLine的rect
 */
- (CGRect)rectForLinesAtIndex:(NSUInteger)index;

@end

@interface WMGTextLayoutFrame (HitTest)

/**
 *  获取一个区域中包含的文字对应的字符串范围
 *
 *  @param bounds 要查询的区域
 *
 *  @return 字符串范围
 */
- (NSRange)characterRangeForBoundingRect:(CGRect)bounds;

/**
 *  获取某一坐标上的文字对应的字符串 index
 *
 *  @param point 坐标点
 *
 *  @return 字符串 index
 */
- (NSUInteger)characterIndexForPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
