//
//  WMGTextLayout+Coordinate.h
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
    

#import "WMGTextLayout.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextLayout (Coordinate)

/**
 * 将UIKit坐标系统的点转换到CoreText坐标系统的点
 *
 * @param point UIKit坐标系统的点
 *
 * @return CoreText坐标系统的点
 */
- (CGPoint)wmg_CTPointFromUIPoint:(CGPoint)point;

/**
 * 将CoreText坐标系统的点转换到UIKit坐标系统的点
 *
 * @param point CoreText坐标系统的点
 *
 * @return UIKit坐标系统的点
 */
- (CGPoint)wmg_UIPointFromCTPoint:(CGPoint)point;

/**
 * 将UIKit坐标系统的rect转换到CoreText坐标系统的rect
 *
 * @param rect UIKit坐标系统的rect
 *
 * @return CoreText坐标系统的rect
 */
- (CGRect)wmg_CTRectFromUIRect:(CGRect)rect;

/**
 * 将CoreText坐标系统的rect转换到UIKit坐标系统的rect
 *
 * @param rect CoreText坐标系统的rect
 *
 * @return UIKit坐标系统的rect
 */
- (CGRect)wmg_UIRectFromCTRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
