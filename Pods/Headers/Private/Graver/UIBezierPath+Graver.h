//
//  UIBezierPath+Graver.h
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
#import "UIImage+Graver.h"

@interface UIBezierPath (Graver)
/**
 * 该方法用来根据指定的矩形区域获取一个带圆角边框的路径
 * 一般情况下仅限于框架内部使用
 *
 * @param rect 矩形区域
 * @param radius 定义圆角的结构体，可以指定任意一个角的弧度
 * @param lineWidth 路径线条宽度
 *
 * @return 贝塞尔路径
 */
+ (UIBezierPath *)wmg_bezierPathWithRect:(CGRect)rect cornerRadius:(WMGCornerRadius)radius lineWidth:(CGFloat)lineWidth;

@end
