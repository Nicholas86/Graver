//
//  WMGTextDrawer+Event.h
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

@protocol WMGActiveRange;
@protocol WMGTextDrawerEventDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface WMGTextDrawer ()
{
@protected
    __weak id<WMGTextDrawerEventDelegate> _eventDelegate;
    // 记录上次touch end时候的timestamp，否则调用2次touch ended
    NSTimeInterval _lastTouchEndedTimeStamp;
    
    struct {
        unsigned int placeAttachment: 1;
    } _delegateHas;
    
    struct {
        unsigned int contextView: 1;
        unsigned int activeRanges: 1;
        unsigned int didPressActiveRange: 1;
        unsigned int didHighlightedActiveRange: 1;
        unsigned int shouldInteractWithActiveRange: 1;
    } _eventDelegateHas;
    
    CGPoint _touchesBeginPoint;
}

// 正在响应点击的激活区，每一个可点击区域都被定义成了激活区
@property (nonatomic, strong, nullable) id<WMGActiveRange> pressingActiveRange;

// 已保存的点击激活区
@property (nonatomic, strong, nullable) id<WMGActiveRange> savedPressingActiveRange;

@end

NS_ASSUME_NONNULL_END
