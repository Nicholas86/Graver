//
//  WMGTextDrawer+Coordinate.h
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

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer (Coordinate)
/**
 *  将坐标点从文字布局中转换到 TextDrawer 的绘制区域中
 *
 *  @param point 需要转换的坐标点
 *
 *  @return 转换过的坐标点
 */
- (CGPoint)convertPointFromLayout:(CGPoint)point offsetPoint:(CGPoint)offsetPoint;

/**
 *  将坐标点从 TextDrawer 的绘制区域转换到文字布局中
 *
 *  @param point 需要转换的坐标点
 *
 *  @return 转换过的坐标点
 */
- (CGPoint)convertPointToLayout:(CGPoint)point offsetPoint:(CGPoint)offsetPoint;

/**
 *  将一个 rect 从文字布局中转换到 TextDrawer 的绘制区域中
 *
 *  @param rect 需要转换的 rect
 *
 *  @return 转换后的 rect
 */
- (CGRect)convertRectFromLayout:(CGRect)rect offsetPoint:(CGPoint)offsetPoint;

/**
 *  将一个 rect 从 TextDrawer 的绘制区域转换到文字布局中
 *
 *  @param rect 需要转换的 rect
 *
 *  @return 转换后的 rect
 */
- (CGRect)convertRectToLayout:(CGRect)rect offsetPoint:(CGPoint)offsetPoint;

@end

NS_ASSUME_NONNULL_END
