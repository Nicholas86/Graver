//
//  WMMutableAttributedItem.h
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
#import "NSAttributedString+GCalculateAndDraw.h"
#import "NSMutableAttributedString+GTextProperty.h"
#import "WMGTextAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMMutableAttributedItem : NSObject

// 视觉元素对应的resultString
@property (nonatomic, strong, readonly) NSAttributedString *resultString;

// 视觉元素中涉及的文本组件
@property (nonatomic, strong, readonly) NSArray <WMGTextAttachment *> *arrayAttachments;

/**
 * 根据Text创建一个AttributedItem
 *
 * @param text 文本
 * @return WMMutableAttributedItem
 */
+ (instancetype)itemWithText:(nullable NSString *)text;

/**
 * 根据imgname创建一个AttributedItem
 *
 * @param imgname 图片名称
 * @return WMMutableAttributedItem
 */
+ (instancetype)itemWithImageName:(nullable NSString *)imgname;

/**
 * 根据指定size的imgname创建一个AttributedItem
 *
 * @param imgname 图片名字
 * @param size 图片大小
 * @return WMMutableAttributedItem
 */
+ (instancetype)itemWithImageName:(nullable NSString *)imgname size:(CGSize)size;

/**
 * 根据指定text初始化
 *
 * @param text 文本
 * @return WMMutableAttributedItem
 */
- (instancetype)initWithText:(nullable NSString *)text;

/**
 * 设置AttributedItem的Font
 *
 * @param font 字体
 */
- (void)setFont:(UIFont *)font;

/**
 * 设置AttributedItem的Font
 *
 * @param size 字号
 * @param weight 字重
 * @param boldDisplay 是否加粗显示
 */
- (void)setFontSize:(CGFloat)size fontWeight:(CGFloat)weight boldDisplay:(BOOL)boldDisplay;

/**
 * 设置AttributedItem的Font
 *
 * @param ctFont 字体
 */
- (void)setCTFont:(CTFontRef)ctFont;

/**
 * 设置AttributedItem的color
 *
 * @param color 颜色
 */
- (void)setColor:(UIColor *)color;

/**
 * 设置AttributedItem的对齐方式
 *
 * @param alignment 对齐方式
 */
- (void)setAlignment:(WMGTextAlignment)alignment;

/**
 * 设置AttributedItem的对齐方式
 *
 * @param alignment 对齐方式
 * @param lineBreakMode 换行模式
 *
 */
- (void)setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 * 设置AttributedItem的对齐方式
 *
 * @param alignment 对齐方式
 * @param lineBreakMode 换行模式
 * @param lineheight 行高
 *
 */
- (void)setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineheight;

/**
 * 设置AttributedItem的排版字间距
 *
 * @param kern 字间距
 *
 */
- (void)setKerning:(CGFloat)kern;

/**
 * 设置AttributedItem的连字风格
 *
 * @param textLigature 连字风格
 *
 */
- (void)setTextLigature:(WMGTextLigature)textLigature;

/**
 * 设置AttributedItem的下划线
 *
 * @param underlineStyle 下划线风格
 *
 */
- (void)setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle;

/**
 * 设置AttributedItem的删除线
 *
 * @param strikeThroughStyle 删除线风格
 *
 */
- (void)setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle;

/**
 * 设置AttributedItem的段落风格, 默认按照11号字进行段落设置
 *
 * @param paragraphStyle 段落风格
 *
 */
- (void)setTextParagraphStyle:(WMGTextParagraphStyle *)paragraphStyle;

/**
 * 设置AttributedItem的段落风格
 *
 * @param paragraphStyle 段落风格
 * @param fontSize 指定按照该字号进行段落风格设置
 *
 */
- (void)setTextParagraphStyle:(WMGTextParagraphStyle *)paragraphStyle fontSize:(CGFloat)fontSize;


/**
 * 拼接一段文本
 *
 * @param text 文本
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendText:(NSString *)text;

/**
 * 拼接一段文本
 *
 * @param item WMMutableAttributedItem
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendAttributedItem:(WMMutableAttributedItem *)item;

/**
 * 拼接分割线，默认颜色0xc4c4c4
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendSeparatorLine;

/**
 * 拼接指定颜色分割线
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendSeparatorLineWithColor:(UIColor *)lineColor;

/**
 * 拼接指定Url的图片，默认size (11, 11)
 *
 * @param imgUrl 图片Url
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl;

/**
 * 拼接指定Url的图片
 *
 * @param imgUrl 图片Url
 * @param size 图片size
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl size:(CGSize)size;

/**
 * 拼接指定Url的图片
 *
 * @param imgUrl 图片Url
 * @param placeholder 占位图
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl placeholder:(NSString *)placeholder;

/**
 * 拼接指定Url的图片
 *
 * @param imgUrl 图片Url
 * @param size 图片size
 * @param placeholder 占位图
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl size:(CGSize)size placeholder:(NSString *)placeholder;

/**
 * 拼接指定名字的本地图片 默认size(11, 11)
 *
 * @param imgname 图片名称
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithName:(NSString *)imgname;

/**
 * 拼接指定名字的本地图片
 *
 * @param imgname 图片名称
 * @param size 图片size
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithName:(NSString *)imgname size:(CGSize)size;

/**
 * 拼接指定本地图片 默认size(11, 11)
 *
 * @param image 本地图片
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithImage:(UIImage *)image;

/**
 * 拼接指定本地图片
 *
 * @param image 本地图片
 * @param size 图片size
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendImageWithImage:(UIImage *)image size:(CGSize)size;

/**
 * 拼接一个指定宽度的空白占位
 *
 * @param width 空白占位宽度
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendWhiteSpaceWithWidth:(CGFloat)width;

/**
 * 拼接一个文本组件
 *
 * @param att 文本组件
 *
 * @return WMMutableAttributedItem
 *
 */
- (WMMutableAttributedItem *)appendAttachment:(WMGTextAttachment *)att;

@end

NS_ASSUME_NONNULL_END
