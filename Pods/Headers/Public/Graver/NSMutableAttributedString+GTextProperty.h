//
//  NSMutableAttributedString+GTextProperty.h
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
#import "WMGTextParagraphStyle.h"

extern NSString * const WMGTextStrikethroughStyleAttributeName;
extern NSString * const WMGTextStrikethroughColorAttributeName;
extern NSString * const WMGTextDefaultForegroundColorAttributeName;

typedef NS_ENUM(NSUInteger, WMGTextAlignment)
{
    WMGTextAlignmentLeft = 0,
    WMGTextAlignmentCenter,
    WMGTextAlignmentRight,
    WMGTextAlignmentJustified,
};

typedef NS_ENUM(NSUInteger, WMGTextLigature)
{
    WMGTextLigatureProperRendering = 0,
    WMGTextLigatureDefault = 1,
    WMGTextLigatureAllAvailable = 2,
};

typedef NS_ENUM(NSUInteger, WMGTextUnderlineStyle)
{
    WMGTextUnderlineStyleNone = 0x00,
    WMGTextUnderlineStyleSingle = 0x01,
    WMGTextUnderlineStyleThick = 0x02,
    WMGTextUnderlineStyleDouble = 0x09
};

typedef NS_ENUM(NSUInteger, WMGTextStrikeThroughStyle)
{
    WMGTextStrikeThroughStyleNone = 0x00,
    WMGTextStrikeThroughStyleSingle = 0x01,
    WMGTextStrikeThroughStyleThick = 0x02,
};

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (GTextProperty)

/**
* 设置字体 range默认 （0，s.length）
*
* @param font 字体
*
*/
- (void)wmg_setFont:(UIFont *)font;

/**
 * 设置字体，对AttributedString的指定Range生效
 *
 * @param font 字体
 *
 */
- (void)wmg_setFont:(UIFont *)font inRange:(NSRange)range;

/**
 * 设置文本字体  range默认 （0，s.length）
 *
 * @param size 指定字号
 * @param weight 指定字重
 * @param boldDisplay 是否加粗
 *
 */
- (void)wmg_setFontSize:(CGFloat)size fontWeight:(CGFloat)weight boldDisplay:(BOOL)boldDisplay;

/**
 * 设置文本CTFont形式的字体  range默认 （0，s.length）
 *
 * @param ctFont   字体
 *
 */
- (void)wmg_setCTFont:(CTFontRef)ctFont;

/**
 * 设置文本CTFont形式的字体
 *
 * @param ctFont   字体
 * @param range    range
 *
 */
- (void)wmg_setCTFont:(CTFontRef)ctFont inRange:(NSRange)range;

/**
 * 设置文本颜色 range默认 （0，s.length）
 *
 * @param color   字体颜色
 *
 */
- (void)wmg_setColor:(UIColor *)color;

/**
 * 设置文本颜色，仅对指定range生效
 *
 * @param color     字间距
 * @param range     range
 *
 */
- (void)wmg_setColor:(UIColor *)color inRange:(NSRange)range;

/**
 * 设置字间距 range默认 （0，s.length）
 *
 * @param kern     字间距
 *
 */
- (void)wmg_setKerning:(CGFloat)kern;

/**
 * 设置字间距，仅对指定range生效
 *
 * @param kern     字间距
 * @param range    指定区间
 *
 */
- (void)wmg_setKerning:(CGFloat)kern inRange:(NSRange)range;

/**
 * 设置AttributedString的段落风格
 *
 * @param paragraphStyle     段落风格
 * @param fontSize           字号
 *
 */
- (void)wmg_setTextParagraphStyle:(WMGTextParagraphStyle *)paragraphStyle fontSize:(CGFloat)fontSize;

/**
 * 设置AttributedString的段落对齐方式、换行模式、行高
 *
 * @param alignment          对齐方式
 *
 */
- (void)wmg_setAlignment:(WMGTextAlignment)alignment;

/**
 * 设置AttributedString的段落对齐方式、换行模式、行高
 *
 * @param alignment          对齐方式
 * @param lineBreakMode      换行模式
 *
 */
- (void)wmg_setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 * 设置AttributedString的段落对齐方式、换行模式、行高
 *
 * @param alignment          对齐方式
 * @param lineBreakMode      换行模式
 * @param lineheight         段落行高
 *
 */
- (void)wmg_setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineheight;

/**
 * 设置文本连字风格
 *
 */
- (void)wmg_setTextLigature:(WMGTextLigature)textLigature;

/**
 * 设置AttributedString的下划线风格、默认颜色0x333333、默认range（0， s.length）
 *
 * @param underlineStyle          下划线风格
 *
 */
- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle;

/**
 * 设置AttributedString的下划线风格、默认颜色0x333333
 *
 * @param underlineStyle          下划线风格
 * @param range                   下划线添加的range
 *
 */
- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle inRange:(NSRange)range;

/**
 * 设置AttributedString的下划线风格、颜色 默认range（0， s.length）
 *
 * @param underlineStyle          下划线风格
 * @param color                   下划线颜色
 *
 */
- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle color:(UIColor *)color;

/**
 * 设置AttributedString的下划线风格、颜色、指定range
 *
 * @param underlineStyle          下划线风格
 * @param color                   下划线颜色
 * @param range                   下划线添加的range
 *
 */
- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle color:(UIColor *)color inRange:(NSRange)range;

/**
 * 设置AttributedString指定range的删除线风格 默认0x333333颜色 默认range （0，s.length）
 *
 * @param strikeThroughStyle      删除线风格
 *
 */
- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle;

/**
 * 设置AttributedString指定range的删除线风格 默认0x333333颜色
 *
 * @param strikeThroughStyle      删除线风格
 * @param range                   删除线添加的range
 *
 */
- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle inRange:(NSRange)range;

/**
 * 设置AttributedString指定range的删除线风格、颜色
 *
 * @param strikeThroughStyle      删除线风格
 * @param color                   删除线颜色
 *
 */
- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle color:(UIColor *)color;

/**
 * 设置AttributedString指定range的删除线风格、颜色
 *
 * @param strikeThroughStyle      删除线风格
 * @param color                   删除线颜色
 * @param range                   删除线添加的range
 *
 */
- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle color:(UIColor *)color inRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
