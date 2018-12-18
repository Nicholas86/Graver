//
//  WMGCanvasControl.h
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
    

#import "WMGCanvasView.h"

@interface WMGCanvasControl : WMGCanvasView

// how to position content vertically inside control. default is center
@property (nonatomic) UIControlContentHorizontalAlignment contentHorizontalAlignment;
// how to position content horizontally inside control. default is center
@property (nonatomic) UIControlContentVerticalAlignment contentVerticalAlignment;
// could be more than one state (e.g. disabled|selected). synthesized from other flags.
@property (nonatomic, readonly) UIControlState state;
// default is YES. if NO, ignores touch events and subclasses may draw differently
@property (nonatomic, getter=isEnabled) BOOL enabled;
// default is NO may be used by some subclasses or by application
@property (nonatomic, getter=isSelected) BOOL selected;
// default is NO. this gets set/cleared automatically when touch enters/exits during tracking and cleared on up
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

// is tracking
@property (nonatomic, readonly, getter=isTracking) BOOL tracking;
// valid during tracking only
@property (nonatomic, readonly, getter=isTouchInside) BOOL touchInside;

// auto redraws when state changed
@property (nonatomic, readonly) BOOL redrawsAutomaticallyWhenStateChange;

// add target/action for particular event. you can call this multiple times and you can specify multiple target/actions for a particular event.
// passing in nil as the target goes up the responder chain. The action may optionally include the sender and the event in that order
// the action cannot be NULL. Note that the target is not retained.
- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

// remove the target/action for a set of events. pass in NULL for the action to remove all actions for that target
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

// single event. returns NSArray of NSString selector names. returns nil if none
- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent;
// set may include NSNull to indicate at least one nil target
- (NSSet *)allTargets;
// list of all events that have at least one action
- (UIControlEvents)allControlEvents;

// send all actions associated with events
- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents;
// send the action. the first method is called for the event and is a point at which you can observe or override behavior. it is called repeately by the second.
- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)cancelTrackingWithEvent:(UIEvent *)event;

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event;

@end

