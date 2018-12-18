//
//  WMGTextAttachment+Event.h
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
    

#import "WMGTextAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextAttachment ()

// 文本组件触发事件的target
@property (nonatomic, weak, nullable) id target;

// 文本组件触发的事件回调
@property (nonatomic, assign) SEL selector;

// 文本组件是否响应事件，默认responseEvent = （target && selector && target respondSelector:selector）
@property (nonatomic, assign) BOOL responseEvent;

/**
 *  给一个文本组件添加事件
 *
 * @param target 事件执行者
 * @param action 事件行为
 * @param controlEvents 事件类型
 *
 */
- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 *  处理事件，框架内部使用
 */
- (void)handleEvent:(nullable id)sender;

@end

NS_ASSUME_NONNULL_END
