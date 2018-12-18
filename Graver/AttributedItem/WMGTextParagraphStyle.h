//
//  WMGTextParagraphStyle.h
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
#import <CoreGraphics/CoreGraphics.h>

@class WMGTextParagraphStyle;

@protocol WMGTextParagraphStyleDelegate <NSObject>
- (void)paragraphStyleDidUpdated:(WMGTextParagraphStyle *)style;
@end

NS_ASSUME_NONNULL_BEGIN
/*
 段落风格设置类，该类是对系统CTParagraphStyle各个属性相关设置的封装
 */
@interface WMGTextParagraphStyle : NSObject

/**
 * 获取默认段落风格，每次调用都会创建一个实例返回。
 *
 * @return WMGTextParagraphStyle
 */
+ (instancetype)defaultParagraphStyle;

// 段落风格代理
@property (nonatomic, weak, nullable) id<WMGTextParagraphStyleDelegate> delegate;

// 获取默认段落风格，每次调用都会创建一个实例返回。
@property (nonatomic, assign) BOOL allowsDynamicLineSpacing;

// 行间距，默认值5
@property (nonatomic, assign) CGFloat lineSpacing;

// 最大行高
@property (nonatomic, assign) CGFloat maximumLineHeight;

// 换行模式，默认NSLineBreakByWordWrapping
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;

// 对齐风格，默认NSTextAlignmentLeft
@property (nonatomic, assign) NSTextAlignment alignment;

// 段落首行头部缩进
@property (nonatomic, assign) CGFloat firstLineHeadIndent;

// 段落前间距
@property (nonatomic, assign) CGFloat paragraphSpacingBefore;

// 段落后间距
@property (nonatomic, assign) CGFloat paragraphSpacingAfter;

/**
 * 根据指定字号获取NS类型的段落对象
 * @param fontSize 字号大小
 *
 * @return NSParagraphStyle
 */
- (NSParagraphStyle *)nsParagraphStyleWithFontSize:(NSInteger)fontSize;

/**
 * 根据指定字号获取CT类型的段落对象
 * @param fontSize 字号大小
 *
 * @return CTParagraphStyleRef
 */

- (CTParagraphStyleRef)ctParagraphStyleWithFontSize:(NSInteger)fontSize;

@end

NS_ASSUME_NONNULL_END
