//
//  WMGAsyncDrawView.h
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
#import "WMGAsyncDrawLayer.h"

typedef void(^WMGAsyncDrawCallback)(BOOL drawInBackground);

@interface WMGAsyncDrawView : UIView

// 绘制完成后，内容经过此时间的渐变显示出来，默认为 0.0
@property (nonatomic, assign) NSTimeInterval fadeDuration;

// 绘制逻辑，定义同步绘制或异步，详细见枚举定义，默认为 WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged
@property (nonatomic, assign) WMGViewDrawingPolicy drawingPolicy;

// 在drawingPolicy 为 WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged 时使用
// 需要异步绘制时设置一次 YES，默认为NO
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

// 下次AsyncDrawing完成前保留当前的contents
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;

// 用于异步绘制的队列，为nil时将使用GCD的global queue进行绘制，默认为nil
@property (nonatomic, assign) dispatch_queue_t dispatchDrawQueue;

// 异步绘制时global queue的优先级，默认优先级为DEFAULT。在设置了drawQueue时此参数无效。
@property (nonatomic, assign) dispatch_queue_priority_t dispatchPriority;

// 绘制次数
@property (nonatomic, assign, readonly) NSUInteger drawingCount;

// 是否永远使用离屏渲染，默认YES。子类如果不希望离屏渲染必须重写此方法并 重写drawingPolicy为WMViewDrawingPolicySynchronouslyDraw
@property (nonatomic, assign, readonly) BOOL alwaysUsesOffscreenRendering;

/**
 * 设置需要异步显示
 */
- (void)setNeedsDisplayAsync;

/**
 * 如果可能，中断当前绘制工作
 */
- (void)interruptDrawingWhenPossible;

/**
 * 设置异步绘制全局开关
 *
 * @param disable YES or NO
 *
 */
+ (void)setGlobalAsyncDrawingDisable:(BOOL)disable;

/**
 * 是否全局禁用了异步绘制
 *
 */
+ (BOOL)globalAsyncDrawingDisabled;

/**
 * 立即开始重绘流程，无需等到下一个runloop（异步绘制会在下个runloop开始）
 */
- (void)redraw;

#pragma mark - Methods for subclass overriding

/**
 * 子类可以重写，并在此方法中进行绘制，请勿直接调用此方法
 *
 * @param rect 进行绘制的区域，目前只可能是 self.bounds
 * @param context 绘制到的context，目前在调用时此context都会在系统context堆栈栈顶
 * @param asynchronously 当前是否是异步绘制
 *
 * @return 绘制是否已执行完成。若为 NO，绘制的内容不会被显示
 *
 */
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously;

/**
 * 子类可以重写，并在此方法中进行绘制，请勿直接调用此方法
 *
 * @param rect 进行绘制的区域，目前只可能是 self.bounds
 * @param context 绘制到的context，目前在调用时此context都会在系统context堆栈栈顶
 * @param asynchronously 当前是否是异步绘制
 * @param userInfo 由currentDrawingUserInfo传入的字典，供绘制传参使用
 *
 * @return 绘制是否已执行完成。若为 NO，绘制的内容不会被显示
 */
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo;

/**
 * 子类可以重写，是绘制即将开始前的回调，请勿直接调用此方法
 *
 * @param asynchronously 当前是否是异步绘制
 */
- (void)drawingWillStartAsynchronously:(BOOL)asynchronously;

/**
 * 子类可以重写，是绘制完成后的回调，请勿直接调用此方法
 *
 * @param asynchronously 当前是否是异步绘制
 * @param success 绘制是否成功
 *
 * @discussion 如果在绘制过程中进行一次重绘，会导致首次绘制不成功，第二次绘制成功。
 */
- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success;

/**
 * 子类可以重写，用于在主线程生成并传入绘制所需参数
 *
 * @discussion 有时在异步线程配置参数可能导致crash，例如在异步线程访问ivar。可以通过此方法将参数放入字典并传入绘制方法。此方法会在displayLayer:的当前线程调用，一般为主线程。
 */
- (NSDictionary *)currentDrawingUserInfo;


@end
