//
//  WMGTextDrawer+Debug.h
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
    

#import "WMGTextDrawer.h"

@class WMGTextLayoutFrame;
NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer (Debug)

/**
 *  判断Debug开关是否打开
 *
 *  @return YES or NO
 */
+ (BOOL)debugModeEnabled;

/**
 *  打开Debug开关
 */
+ (void)enableDebugMode;
/**
 *  关闭Debug开关
 */
+ (void)disableDebugMode;

/**
 *  设置Debug开关
 *
 *  @param enabled YES or NO
 */
+ (void)setDebugModeEnabled:(BOOL)enabled;

/**
 *  框架内部使用，用来控制是否为每一个绘制元素添加调试底色
 *
 *  @param layoutFrame 排版结果
 *  @param ctx 上下文
 */
- (void)debugModeDrawLineFramesWithLayoutFrame:(WMGTextLayoutFrame *)layoutFrame context:(CGContextRef)ctx;

@end

NS_ASSUME_NONNULL_END
