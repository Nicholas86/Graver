//
//  UIFont+Graver.h
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
    

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (Graver)

/**
 * 根据字体大小获取系统字体
 *
 * @param size 字体大小
 *
 * @return 系统CTFont
 */
+ (CTFontRef)wmg_newSystemCTFontOfSize:(CGFloat)size;

/**
 * 根据字体大小获取一个bold类型的系统字体
 *
 * @param size 字体大小
 *
 * @return bold类型的系统CTFont
 */
+ (CTFontRef)wmg_newBoldSystemCTFontOfSize:(CGFloat)size;

/**
 * 根据字体名称、字体大小获取一个CTFont类型的字体
 *
 * @param fontName 字符串类型，字体名称
 * @param fontSize 字体大小
 *
 * @return CTFont类型的字体
 */
+ (CTFontRef)wmg_newCTFontWithName:(NSString *)fontName size:(CGFloat)fontSize;

/**
 * 获取某一字体的Bold类型的字体
 *
 * @param ctFont 待转换的CTFontRef类型字体
 *
 * @return bold类型的CTFont
 */
+ (CTFontRef)wmg_newBoldCTFontForCTFont:(CTFontRef)ctFont;

/**
 * 获取某一字体的Italic类型的字体
 *
 * @param ctFont 待转换的CTFontRef类型字体
 *
 * @return italic类型的CTFont
 */
+ (CTFontRef)wmg_newItalicCTFontForCTFont:(CTFontRef)ctFont;

/**
 * 根据指定的字体符号特性对CTFont进行转换
 *
 * @param ctFont 待转换的CTFontRef类型字体
 *
 * @return 完成字体符号特性转换的CTFont
 */
+ (CTFontRef)wmg_newCTFontWithCTFont:(CTFontRef)ctFont symbolicTraits:(CTFontSymbolicTraits)symbolicTraits;

/**
 * 根据CTFont转换成UIFont
 *
 * @param CTFont CTFontRef类型的字体
 *
 * @return UIFont类型的字体
 */
+ (UIFont *)wmg_fontWithCTFont:(CTFontRef)CTFont;

/**
 * 获取系统字体名称
 *
 * @return 系统字体名称 NSString类型
 *
 */
+ (NSString *)wmg_systemFontName;

@end

