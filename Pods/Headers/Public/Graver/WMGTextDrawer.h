//
//  WMGTextDrawer.h
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
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIView;
@class WMGTextLayout;
@class WMGTextActiveRange;
@class WMGTextAttachment;

@protocol WMGActiveRange;
@protocol WMGAttachment;
@protocol WMGTextDrawerDelegate;
@protocol WMGTextDrawerEventDelegate;

typedef BOOL (^WMGTextDrawerShouldInterruptBlock)(void);

/*
 文本绘制器类是框架核心类，混排图文的绘制、size计算都依赖文本绘制器实现
 */
@interface WMGTextDrawer : UIResponder

// 文本绘制器的绘制起点和绘制区域的定义，Frame会被拆解成两部分，origin决定绘制起点，size决定绘制区域大小
@property (nonatomic, assign) CGRect frame;

// CoreText排版模型封装
@property (nonatomic, strong, readonly) WMGTextLayout *textLayout;

// 文本绘制器的代理
@property (nonatomic, weak) id <WMGTextDrawerDelegate> delegate;

// 文本绘制器的事件代理，用以处理混排图文中的可点击响应
@property (nonatomic, weak) id <WMGTextDrawerEventDelegate> eventDelegate;

/**
 *  文本绘制器的基本绘制方法，绘制到当前上下文中
 */
- (void)draw;

/**
 *  将文本绘制器裹挟的内容绘制到指定上下文中
 *
 *  @param ctx      当前的 CGContext
 */
- (void)drawInContext:(CGContextRef)ctx;

/**
 *  将文本绘制器裹挟的内容绘制到指定上下文中，同时通过block控制中断
 *  中断意味着可以终止绘制流程，但不是一定会终止，这是由于多线程并发决定的，可以参考NSOperation的cancel方法的理念理解
 *
 *  @param ctx        当前的 CGContext
 *  @param block      中断block
 *
 */
- (void)drawInContext:(CGContextRef)ctx shouldInterruptBlock:(WMGTextDrawerShouldInterruptBlock)block;

/**
 *  将文本绘制器裹挟的内容绘制到指定上下文中，同时通过block控制中断
 *  中断意味着可以终止绘制流程，但不是一定会终止，这是由于多线程并发决定的，可以参考NSOperation的cancel方法的理念理解
 *
 *  @param ctx                      当前的 CGContext
 *  @param visibleRect              可见区域
 *  @param replaceAttachments       是否替换组件
 *  @param block                    中断block
 *
 */
- (void)drawInContext:(CGContextRef)ctx visibleRect:(CGRect)visibleRect replaceAttachments:(BOOL)replaceAttachments shouldInterruptBlock:(WMGTextDrawerShouldInterruptBlock)block;

@end

@protocol WMGTextDrawerDelegate <NSObject>

@optional

/**
 *  textAttachment 渲染的回调方法，
 *  delegate 可以通过此方法定义 Attachment 的样式，具体显示的方式可以是绘制到 context 或者添加一个自定义 View
 *
 *  @param textDrawer   执行文字渲染的 textDrawer
 *  @param att          需要渲染的 TextAttachment
 *  @param frame        建议渲染到的 frame
 *  @param context      当前的 CGContext
 */
- (void)textDrawer:(WMGTextDrawer *)textDrawer replaceAttachment:(id <WMGAttachment>)att frame:(CGRect)frame context:(CGContextRef)context;

@end

@protocol WMGTextDrawerEventDelegate <NSObject>

@required
/**
 *  返回 textDrawer 处理事件时所基于的 view，用于确定坐标系等，必须
 *
 *  @param textDrawer 查询的 textDrawer
 *
 *  @return 处理事件时基于的 view
 */
- (UIView *)contextViewForTextDrawer:(WMGTextDrawer *)textDrawer;

/**
 *  返回定义 textDrawer 可点击区域的数组
 *
 *  @param textDrawer 查询的 textDrawer
 *
 *  @return 由 (id<WMGTextActiveRange>) 对象组成的数组
 */
- (NSArray *)activeRangesForTextDrawer:(WMGTextDrawer *)textDrawer;

/**
 *  响应对一个 activeRange 的点击事件
 *
 *  @param textDrawer 响应事件的 textDrawer
 *  @param activeRange  响应的 activeRange
 */
- (void)textDrawer:(WMGTextDrawer *)textDrawer didPressActiveRange:(id<WMGActiveRange>)activeRange;

@optional
/**
 *  activeRange点击的 高亮事件
 *
 *  @param textDrawer 响应事件的 textDrawer
 *  @param activeRange  响应的 activeRange
 */
- (void)textDrawer:(WMGTextDrawer *)textDrawer didHighlightedActiveRange:(id<WMGActiveRange>)activeRange rect:(CGRect)rect;

@optional
/**
 *  返回 textDrawer 是否要与一个 activeRange 进行交互，如点击操作
 *
 *  @param textDrawer 查询的 textDrawer
 *  @param activeRange  是否要与此 activeRange 进行交互
 *
 *  @return 是否与 activeRange 进行交互
 */
- (BOOL)textDrawer:(WMGTextDrawer *)textDrawer shouldInteractWithActiveRange:(id<WMGActiveRange>)activeRange;

@end
