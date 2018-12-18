//
//  NSAttributedString+GCalculateAndDraw.h
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

@class WMGTextDrawer;
@class WMGTextLayout;

typedef CGRect (^WMGTextDrawingFrameBlock)(CGSize size);

@interface NSAttributedString (GCalculateAndDraw)

/**
 * 获取一个文本绘制器
 *
 * @discussion 以线程内共享方式返回一个文本绘制器，同一个线程获取的对象是同一个，不同的线程获取到的不一样
 *
 * @return WMGTextDrawer
 */
+ (WMGTextDrawer *)wmg_sharedTextDrawer;
- (WMGTextDrawer *)wmg_sharedTextDrawer;

#pragma mark - Size

/**
 * 计算AttributedString的size
 *
 * @return size
 */
- (CGSize)wmg_size;

/**
 * 计算AttributedString的size
 *
 * @param size              限定size
 *
 * @return size
 */
- (CGSize)wmg_sizeConstrainedToSize:(CGSize)size;

/**
 * 计算AttributedString的size
 *
 * @param size              限定size
 * @param numberOfLines     限定行数
 *
 * @return size
 */
- (CGSize)wmg_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines;

/**
 * 计算AttributedString的size
 *
 * @param size              限定size
 * @param numberOfLines     限定行数
 * @param derivedLineCount  实际占用的行数
 *
 * @return size
 */
- (CGSize)wmg_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger *)derivedLineCount;

/**
 * 计算AttributedString的size
 *
 * @param width 限定宽度
 *
 * @return size
 */
- (CGSize)wmg_sizeConstrainedToWidth:(CGFloat)width;

/**
 * 计算AttributedString的size
 *
 * @param width         限定宽度
 * @param numberOfLines 限定行数
 *
 * @return size
 */
- (CGSize)wmg_sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines;

/**
 * 计算AttributedString的高度
 *
 * @param width 限定的宽度
 *
 * @return 高度
 */
- (CGFloat)wmg_heightConstrainedToWidth:(CGFloat)width;

#pragma mark - Draw in Rect

/**
 * 将AttributedString以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect;

/**
 * 将AttributedString以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param ctx 上下文
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect context:(CGContextRef)ctx;

/**
 * 将AttributedString以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param numberOfLines 限定行数
 * @param ctx 上下文
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines context:(CGContextRef)ctx;

/**
 * 将AttributedString以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param numberOfLines 限定行数
 * @param metrics fontMetrics
 * @param ctx 上下文
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines baselineMetrics:(WMGFontMetrics)metrics context:(CGContextRef)ctx;

/**
 * 将AttributedString以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param numberOfLines 限定行数
 * @param metrics fontMetrics
 * @param ctx 上下文
 * @param textDrawer 文本绘制器
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines baselineMetrics:(WMGFontMetrics)metrics context:(CGContextRef)ctx textDrawer:(WMGTextDrawer *)textDrawer;

#pragma mark - Size Based Drawing

/**
 * 将AttributedString以限定宽度绘制到某一个区域
 *
 * @param width 限定宽度
 * @param frameBlock frameBlock
 *
 */
- (void)wmg_drawWithWidth:(CGFloat)width frameBlock:(WMGTextDrawingFrameBlock)frameBlock;

/**
 * 将AttributedString以限定条件绘制到某一个区域
 *
 * @param width 限定宽度
 * @param numberOfLines 限定行数
 * @param ctx 上下文
 * @param frameBlock frameBlock
 *
 */
- (void)wmg_drawWithWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines context:(CGContextRef)ctx frameBlock:(WMGTextDrawingFrameBlock)frameBlock;

/**
 * 将AttributedString以限定条件进行布局
 *
 * @param width 限定宽度
 * @param lines 限定行数
 *
 * @return WMGTextLayout
 */
- (WMGTextLayout *)wmg_layoutToWidth:(CGFloat)width maxNumberOfLines:(NSInteger)lines;

/**
 * 将AttributedString以限定条件进行布局
 *
 * @param width         限定宽度
 * @param lines         限定行数
 * @param layoutSize    布局结果的排版size
 *
 * @return WMGTextLayout
 */
- (WMGTextLayout *)wmg_layoutToWidth:(CGFloat)width maxNumberOfLines:(NSInteger)lines layoutSize:(CGSize)layoutSize;

@end

@interface NSString (GCalculateAndDraw)

#pragma mark - Size

/**
 * 获取NSString的cachesize
 *
 * @param font              限定字体
 *
 * @return size
 *
 * @discussion 根据NSString内容和当前的UIFont联合作为key做缓存，如果没有缓存调用wmg_sizeWithFont计算返回
 */
- (CGSize)wmg_cacheSizeWithFont:(UIFont *)font;

/**
 * 计算NSString的size
 *
 * @param font              限定字体
 *
 * @return size
 */
- (CGSize)wmg_sizeWithFont:(UIFont *)font;

/**
 * 计算NSString的size
 *
 * @param font              限定字体
 * @param size              限定size
 *
 * @return size
 */
- (CGSize)wmg_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

/**
 * 计算NSString的size
 *
 * @param font              限定字体
 * @param size              限定size
 * @param lineBreakMode     换行模式
 *
 * @return size
 */
- (CGSize)wmg_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 * 计算NSString的size
 *
 * @param font              限定字体
 * @param size              限定size
 * @param lineBreakMode     换行模式
 * @param numberOfLines     限定行数
 *
 * @return size
 */
- (CGSize)wmg_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode numberOfLines:(NSInteger)numberOfLines;

#pragma mark - Draw at Points

- (CGSize)wmg_drawAtPoint:(CGPoint)point withFont:(UIFont *)font;
- (CGSize)wmg_drawAtPoint:(CGPoint)point withFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

#pragma mark - Draw in Rect

/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param font 字体
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font;

/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param font 字体
 * @param lineBreakMode 换行模式
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param font 字体
 * @param lineBreakMode 换行模式
 * @param alignment 对齐方式
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment;

/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param font 字体
 * @param lineBreakMode 换行模式
 * @param alignment 对齐方式
 * @param context 上下文
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment inContext:(CGContextRef)context;

/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param font 字体
 * @param lineBreakMode 换行模式
 * @param alignment 对齐方式
 * @param numberOfLines 限定行数
 * @param context 上下文
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines inContext:(CGContextRef)context;

/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param rect 限定区域
 * @param font 字体
 * @param lineBreakMode 换行模式
 * @param alignment 对齐方式
 * @param numberOfLines 限定行数
 * @param context 上下文
 * @param textDrawer 文本绘制器
 *
 * @return 绘制结果占用的size
 */
- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines inContext:(CGContextRef)context textDrawer:(WMGTextDrawer *)textDrawer;

#pragma mark - Size Based Drawing


/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param width 限定宽度
 * @param font 字体
 * @param frameBlock frameBlock
 *
 */
- (void)wmg_drawWithWidth:(CGFloat)width font:(UIFont *)font frameBlock:(WMGTextDrawingFrameBlock)frameBlock;

/**
 * 将String以限定条件绘制到某一个区域
 *
 * @param width         限定宽度
 * @param font          字体
 * @param lineBreakMode 换行模式
 * @param alignment     对齐方式
 * @param numberOfLines 限定行数
 * @param context       上下文
 * @param frameBlock frameBlock
 *
 */
- (void)wmg_drawWithWidth:(CGFloat)width font:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment numberOfLines:(NSInteger)numberOfLines context:(CGContextRef)context frameBlock:(WMGTextDrawingFrameBlock)frameBlock;

@end
