//
//  WMGContextAssisant.h
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

/**
 * 为上下文添加圆角区域
 *
 * @param context 上下文
 * @param rect 指定区域
 * @param radius 指定圆角
 *
 */
extern void wmg_context_add_round_rect(CGContextRef context, CGRect rect, CGFloat radius);

/**
 * 对上下文绘制区域进行圆角裁剪
 *
 * @param context 上下文
 * @param rect 指定区域
 * @param radius 指定圆角
 *
 */
extern void wmg_context_clip_to_round_rect(CGContextRef context, CGRect rect, CGFloat radius);

/**
 * 在指定区域进行圆角绘制
 *
 * @param context 上下文
 * @param rect 指定区域
 * @param radius 期望的圆角值
 *
 */
extern void wmg_context_fill_round_rect(CGContextRef context, CGRect rect, CGFloat radius);

/**
 * 梯度绘制
 */
extern void wmg_context_draw_linear_gradient_between_points(CGContextRef context, CGPoint a, CGFloat color_a[4], CGPoint b, CGFloat color_b[4]);

/**
 * 根据绘制区域、是否不透明创建一个图形上下文
 *
 * @param size 绘制区域的size
 * @param isOpaque 同系统CALayer的同名属性
 *
 * @return CGContextRef 上下文
 */
extern CGContextRef wmg_create_graphics_context(CGSize size, BOOL isOpaque);

/**
 * 获取位图上下文的Size
 *
 * @param ctx  上下文
 *
 * @return size
 */
extern CGSize wmg_bitmap_context_get_point_size(CGContextRef ctx);

