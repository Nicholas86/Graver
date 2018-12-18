//
//  WMGCanvasControl.m
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
    

#import "WMGCanvasControl.h"

@interface __WMGCanvasControlTargetAction : NSObject

@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) UIControlEvents controlEvents;

@end

@implementation __WMGCanvasControlTargetAction

- (BOOL)isEqual:(__WMGCanvasControlTargetAction *)object
{
    if (object == self) return YES;
    if (![object isKindOfClass:[self class]]) return NO;
    
    return (object.target == self.target &&
            object.action == self.action &&
            object.controlEvents == self.controlEvents);
}

@end

@interface WMGCanvasControl ()
{
    NSMutableArray * _targetActions;
}
@property (nonatomic, assign) CGPoint touchStartPoint;

@end

@implementation WMGCanvasControl

- (void)dealloc
{
    _targetActions = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.enabled = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)_stateWillChange
{
    
}

- (void)_stateDidChange
{
    if ([self redrawsAutomaticallyWhenStateChange]) {
        [self setNeedsDisplay];
        [self setNeedsLayout];
    }
}

- (BOOL)redrawsAutomaticallyWhenStateChange
{
    return YES;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (_highlighted != highlighted)
    {
        [self _stateWillChange];
        _highlighted = highlighted;
        [self _stateDidChange];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (_enabled != enabled)
    {
        [self _stateWillChange];
        _enabled = enabled;
        [self _stateDidChange];
        [self setUserInteractionEnabled:enabled];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (_selected != selected)
    {
        [self _stateWillChange];
        _selected = selected;
        [self _stateDidChange];
    }
}

- (UIControlState)state
{
    UIControlState state = UIControlStateNormal;
    
    if (_highlighted)     state |= UIControlStateHighlighted;
    if (!_enabled)        state |= UIControlStateDisabled;
    if (_selected)        state |= UIControlStateSelected;
    
    return state;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchInside = YES;
    _tracking = [self beginTrackingWithTouch:touch withEvent:event];
    
    self.highlighted = YES;
    
    if (_tracking)
    {
        UIControlEvents currentEvents = UIControlEventTouchDown;
        
        if (touch.tapCount > 1) {
            currentEvents |= UIControlEventTouchDownRepeat;
        }
        
        [self _sendActionsForControlEvents:currentEvents withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.highlighted = NO;
    
    if (_tracking)
    {
        [self cancelTrackingWithEvent:event];
        [self _sendActionsForControlEvents:UIControlEventTouchCancel withEvent:event];
    }
    
    _touchInside = NO;
    _tracking = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _touchInside = [self pointInside:[touch locationInView:self] withEvent:event];
    
    self.highlighted = NO;
    
    if (_tracking)
    {
        [self endTrackingWithTouch:touch withEvent:event];
        
        UIControlEvents events = ((_touchInside)? UIControlEventTouchUpInside : UIControlEventTouchUpOutside);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self _sendActionsForControlEvents:events withEvent:event];
        });
    }
    
    _tracking = NO;
    _touchInside = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    const BOOL wasTouchInside = _touchInside;
    _touchInside = [self pointInside:[touch locationInView:self] withEvent:event];
    
    self.highlighted = _touchInside;
    
    if (_tracking)
    {
        _tracking = [self continueTrackingWithTouch:touch withEvent:event];
        
        if (_tracking)
        {
            UIControlEvents currentEvents = ((_touchInside)? UIControlEventTouchDragInside : UIControlEventTouchDragOutside);
            
            if (!wasTouchInside && _touchInside)
            {
                currentEvents |= UIControlEventTouchDragEnter;
            }
            else if (wasTouchInside && !_touchInside)
            {
                currentEvents |= UIControlEventTouchDragExit;
            }
            
            [self _sendActionsForControlEvents:currentEvents withEvent:event];
        }
    }
}

#pragma mark - Target Action

- (NSMutableArray *)_targetActions
{
    if(!_targetActions)
        _targetActions = [[NSMutableArray alloc] init];
    return _targetActions;
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    if(action)
    {
        __WMGCanvasControlTargetAction *t = [[__WMGCanvasControlTargetAction alloc] init];
        t.target = target;
        t.action = action;
        t.controlEvents = controlEvents;
        [[self _targetActions] addObject:t];
    }
}
- (void)removeTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    NSMutableArray *targetActionsToRemove = [NSMutableArray array];
    
    for(__WMGCanvasControlTargetAction *t in [self _targetActions])
    {
        BOOL actionMatches = action == t.action;
        BOOL targetMatches = [target isEqual:t.target];
        BOOL controlMatches = controlEvents == t.controlEvents;
        
        if((action && targetMatches && actionMatches && controlMatches) ||
           (!action && targetMatches && controlMatches))
        {
            [targetActionsToRemove addObject:t];
        }
    }
    
    [[self _targetActions] removeObjectsInArray:targetActionsToRemove];
}

- (NSArray *)actionsForTarget:(id)target forControlEvent:(UIControlEvents)controlEvent
{
    NSMutableArray *actions = [[NSMutableArray alloc] init];
    
    for (__WMGCanvasControlTargetAction *controlAction in [self _targetActions])
    {
        if ((target == nil || controlAction.target == target) &&
            (controlAction.controlEvents & controlEvent))
        {
            [actions addObject:NSStringFromSelector(controlAction.action)];
        }
    }
    
    if ([actions count] == 0)
    {
        return nil;
    }
    else
    {
        return actions;
    }
}

- (NSSet *)allTargets
{
    return [NSSet setWithArray:[[self _targetActions] valueForKey:@"target"]];
}

- (UIControlEvents)allControlEvents
{
    UIControlEvents allEvents = 0;
    
    for (__WMGCanvasControlTargetAction *t in [self _targetActions])
    {
        allEvents |= t.controlEvents;
    }
    
    return allEvents;
}

- (void)_sendActionsForControlEvents:(UIControlEvents)controlEvents withEvent:(UIEvent *)event
{
    for(__WMGCanvasControlTargetAction *t in [self _targetActions])
    {
        if(t.controlEvents == controlEvents)
        {
            if(t.target && t.action)
            {
                [self sendAction:t.action to:t.target forEvent:nil];
            }
        }
    }
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents
{
    [self _sendActionsForControlEvents:controlEvents withEvent:nil];
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:action to:target from:self forEvent:event];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
}

@end
