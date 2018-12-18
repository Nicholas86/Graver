//
//  WMGAsyncDrawLayer.h
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
    

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, WMGViewDrawingPolicy)
{
    // 当 contentsChangedAfterLastAsyncDrawing 为 YES 时异步绘制
    WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged,
    // 同步绘制
    WMGViewDrawingPolicySynchronouslyDraw,
    // 异步绘制
    WMGViewDrawingPolicyAsynchronouslyDraw,
};

@interface WMGAsyncDrawLayer : CALayer

// 绘制完成后，内容经过此时间的渐变显示出来，默认为 0.0
@property (nonatomic, assign) NSTimeInterval fadeDuration;

// 绘制逻辑，定义同步绘制或异步，详细见枚举定义，默认为 WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged
@property (nonatomic, assign) WMGViewDrawingPolicy drawingPolicy;

// 在drawingPolicy 为 WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged 时使用
// 需要异步绘制时设置一次 YES，默认为NO
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

// 下次AsyncDrawing完成前保留当前的contents
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;

// 绘制次数
@property (nonatomic, assign, readonly) NSInteger drawingCount;

/**
 * 增加异步绘制次数
 */
- (void)increaseDrawingCount;

/**
 * 当前内容是否异步绘制
 */
- (BOOL)isAsyncDrawsCurrentContent;
@end

