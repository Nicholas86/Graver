//
//  WMGAttachment.h
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

typedef NS_ENUM(NSInteger, WMGAttachmentType)
{
    WMGAttachmentTypeStaticImage  = 0,
    WMGAttachmentTypePlaceholder  = 1,
    
    WMGAttachmentTypeApplicationReserved = 0xF000,
};

NS_ASSUME_NONNULL_BEGIN
/**
 *  Attachment 定义了一个特殊的attributedString字符，它可以被展示成特殊的大小、样式
 */
@protocol WMGAttachment <NSObject>

// 定义组件类型，一般文本中插入的图片被标记为WMGAttachmentTypeStaticImage
@property (nonatomic) WMGAttachmentType type;

// 指定组件以size大小展示
@property (nonatomic) CGSize size;

// 组件和四周的edgeInsets
@property (nonatomic) UIEdgeInsets edgeInsets;

// 组件展示相关的数据 一般为 NSString*、UIImage、WMGImage
// 分别对应图片名称（或者是一组文本）、本地图片、网络下载图片
@property (nonatomic, strong, nullable) id contents;

@optional
// 指定组件在AttributedString中的位置和长度，对于图片组件而言，由于是用\ufffc表达，所以长度为1。
@property (nonatomic, assign) NSUInteger position;
@property (nonatomic, assign) NSUInteger length;

@required
// 组件的fontMetrics，系统判定一个系统组件的占位通过一下属性、方法实现
@property (nonatomic) WMGFontMetrics baselineFontMetrics;
- (CGSize)placeholderSize;

@end

NS_ASSUME_NONNULL_END
