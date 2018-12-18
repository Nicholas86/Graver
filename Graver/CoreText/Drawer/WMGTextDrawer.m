//
//  WMGTextDrawer.m
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
#import "WMGTextLayout.h"
#import "WMGTextLayoutFrame.h"
#import "WMGTextLayoutLine.h"
#import "WMGTextLayout+Coordinate.h"
#import "WMGTextDrawer+Event.h"
#import "WMGTextDrawer+Debug.h"
#import "WMGTextDrawer+Coordinate.h"
#import "WMGContextAssisant.h"
#import "WMGraverMacroDefine.h"
#import "WMGAttachment.h"
#import "WMGActiveRange.h"

extern NSString * const WMGTextAttachmentAttributeName;

@interface WMGTextDrawer ()
{
    CGPoint _drawOrigin;
    BOOL drawing;
}
@property (nonatomic, assign) CGPoint drawOrigin;
@property (nonatomic, strong, readwrite) WMGTextLayout *textLayout;
@end

@implementation WMGTextDrawer

- (void)setFrame:(CGRect)frame
{
    if (drawing && !CGSizeEqualToSize(frame.size, self.textLayout.size)) {
        WMGLog(@"draw_error");
    }
    
    _drawOrigin = frame.origin;
    if (self.textLayout.heightSensitiveLayout) {
        self.textLayout.size = frame.size;
    } else {
        CGFloat height = ceil((frame.size.height * 1.1) / 100000) * 100000;
        self.textLayout.size = CGSizeMake(frame.size.width, height);
    }
}

- (CGRect)frame
{
    return CGRectMake(_drawOrigin.x, _drawOrigin.y, self.textLayout.size.width, self.textLayout.size.height);
}

- (WMGTextLayout *)textLayout
{
    if (!_textLayout) {
        _textLayout = [[WMGTextLayout alloc] init];
        _textLayout.heightSensitiveLayout = YES;
    }
    return _textLayout;
}

- (void)setDelegate:(id<WMGTextDrawerDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateHas.placeAttachment = [delegate respondsToSelector:@selector(textDrawer:replaceAttachment:frame:context:)];
    }
}

- (void)setEventDelegate:(id<WMGTextDrawerEventDelegate>)eventDelegate
{
    if ([eventDelegate conformsToProtocol:@protocol(WMGTextDrawerEventDelegate)]) {
        _eventDelegate = eventDelegate;
        
        _eventDelegateHas.contextView = [eventDelegate respondsToSelector:@selector(contextViewForTextDrawer:)];
        _eventDelegateHas.activeRanges = [eventDelegate respondsToSelector:@selector(activeRangesForTextDrawer:)];
        _eventDelegateHas.didPressActiveRange = [eventDelegate respondsToSelector:@selector(textDrawer:didPressActiveRange:)];
        _eventDelegateHas.shouldInteractWithActiveRange = [eventDelegate respondsToSelector:@selector(textDrawer:shouldInteractWithActiveRange:)];
        _eventDelegateHas.didHighlightedActiveRange = [eventDelegate respondsToSelector:@selector(textDrawer:didHighlightedActiveRange:rect:)];
    }
}

#pragma mark - Drawing

- (void)draw
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
}

- (void)drawInContext:(CGContextRef)ctx
{
    [self drawInContext:ctx shouldInterruptBlock:NULL];
}

- (void)drawInContext:(CGContextRef)ctx shouldInterruptBlock:(WMGTextDrawerShouldInterruptBlock)block
{
    [self drawInContext:ctx visibleRect:CGRectNull replaceAttachments:YES shouldInterruptBlock:block];
}

- (void)drawInContext:(CGContextRef)ctx visibleRect:(CGRect)visibleRect replaceAttachments:(BOOL)replaceAttachments shouldInterruptBlock:(WMGTextDrawerShouldInterruptBlock)block
{
    if (!ctx) {
        return;
    }
    drawing = YES;
    
    WMGTextLayout *textLayout = [self textLayout];
    CGPoint drawingOrigin = _drawOrigin;
    CGSize drawingSize = textLayout.size;
    
#define should_interrupt (block && block())
#define interrupt_if_needed if(should_interrupt) {drawing = NO; return;}
    
    const BOOL partialDrawing = !CGRectIsNull(visibleRect);
    
    interrupt_if_needed;
    
    WMGTextLayoutFrame *layoutFrame = [textLayout.layoutFrame copy];
    
    if (!layoutFrame) {
        return;
    }
    
    interrupt_if_needed;
    
    if ([self.class debugModeEnabled]) {
        [self debugModeDrawLineFramesWithLayoutFrame:layoutFrame context:ctx];
    }
    
    interrupt_if_needed;
    
    if (self.pressingActiveRange) {
        CGContextSaveGState(ctx);
        
        [layoutFrame enumerateEnclosingRectsForCharacterRange:self.pressingActiveRange.range usingBlock:^(CGRect rect, NSRange characterRange, BOOL *stop) {
            rect = [self convertRectFromLayout:rect offsetPoint:drawingOrigin];
            [self _drawHighlightedBackgroundForActiveRange:self.pressingActiveRange rect:rect context:ctx];
        }];
        
        CGContextRestoreGState(ctx);
    }
    
    interrupt_if_needed;
    
    CGContextSaveGState(ctx);
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0, -textLayout.size.height);
    
    if (should_interrupt) {
        CGContextRestoreGState(ctx);
        drawing = NO;
        return;
    }
    
    for (WMGTextLayoutLine *line in layoutFrame.arrayLines) {
        
        CGRect fragmentRect = line.lineRect;
        fragmentRect = [self convertRectFromLayout:fragmentRect offsetPoint:drawingOrigin];
        
        if (partialDrawing && !CGRectIntersectsRect(fragmentRect, visibleRect)) {
            continue;
        }
        
        CTLineRef lineRef = line.lineRef;
        CGPoint lineOrigin = line.baselineOrigin;
        lineOrigin.y = drawingSize.height - lineOrigin.y;
        lineOrigin.y -= drawingOrigin.y;
        lineOrigin.x += drawingOrigin.x;
        
        //        CGRect glyphBounds = CTLineGetImageBounds(lineRef, ctx);
        //        CGFloat glyphHeight = ceil(CGRectGetHeight(glyphBounds));
        //        CGFloat lineHeight = WMGFontMetricsGetLineHeight(line.fontMetrics);
        //
        //        lineOrigin.y -= (lineHeight - glyphHeight) / 2;
        
        CGContextSetTextPosition(ctx, lineOrigin.x, lineOrigin.y);
        CTLineDraw(lineRef, ctx);
        
        UIColor *strikeColor = [UIColor colorWithRed : ((CGFloat)((0x999999 & 0xFF0000) >> 16)) / 255.0 green : ((CGFloat)((0x999999 & 0xFF00) >> 8)) / 255.0 blue : ((CGFloat)(0x999999 & 0xFF)) / 255.0 alpha : 1.0];
        for (NSValue *rectValue in line.strikeThroughFrames) {
            CGRect strikeFrame = [rectValue CGRectValue];
            strikeFrame.origin.y = drawingSize.height - strikeFrame.origin.y;
            strikeFrame.origin.y -= drawingOrigin.y;
            strikeFrame.origin.x += drawingOrigin.x;
            
            CGContextSaveGState(ctx);
            CGContextSetTextPosition(ctx, strikeFrame.origin.x, strikeFrame.origin.y);
            CGContextMoveToPoint(ctx, strikeFrame.origin.x, strikeFrame.origin.y);
            CGContextAddLineToPoint(ctx, strikeFrame.origin.x + strikeFrame.size.width, strikeFrame.origin.y);
            CGContextSetStrokeColorWithColor(ctx, strikeColor.CGColor);
            CGContextStrokePath(ctx);
            CGContextRestoreGState(ctx);
        }
        
        if (should_interrupt) {
            CGContextRestoreGState(ctx);
            drawing = NO;
            return;
        }
    }
    
    CGContextRestoreGState(ctx);
    
    if (replaceAttachments) {
        
        [self _drawAttachmentsInContext:ctx shouldInterrupt:block];
    }
    drawing = NO;
#undef interrupt_if_needed
#undef should_interrupt
}

#pragma mark private

- (void)_drawAttachmentsInContext:(CGContextRef)ctx shouldInterrupt:(WMGTextDrawerShouldInterruptBlock)shouldInterrupt
{
#define should_interrupt (shouldInterrupt && shouldInterrupt())
#define interrupt_if_needed if(should_interrupt) {*stop = YES;}
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGPoint offset = _drawOrigin;
    
    [self.textLayout.layoutFrame.arrayLines enumerateObjectsUsingBlock:^(WMGTextLayoutLine *line, NSUInteger idx, BOOL *stop) {
        [line enumerateRunsUsingBlock:^(NSUInteger idx, NSDictionary *attributes, NSRange characterRange, BOOL *stop) {
            id <WMGAttachment> attachment = [attributes objectForKey:WMGTextAttachmentAttributeName];
            if (![attachment conformsToProtocol:@protocol(WMGAttachment)]) {
                return;
            }
            
            CGPoint characterOrigin = [line baselineOriginForCharacterAtIndex:characterRange.location];
            WMGFontMetrics metrics = attachment.baselineFontMetrics;
            UIEdgeInsets edgeInsets = attachment.edgeInsets;
            CGRect frame = CGRectMake(characterOrigin.x + edgeInsets.left, characterOrigin.y + metrics.descent + metrics.leading - edgeInsets.bottom - attachment.size.height, attachment.size.width, attachment.size.height);
            
            frame.origin.x += offset.x;
            frame.origin.y += offset.y;
            
            frame.origin.x = round(frame.origin.x * scale) / scale;
            frame.origin.y = round(frame.origin.y * scale) / scale;
            
            if (self->_delegateHas.placeAttachment) {
                [self.delegate textDrawer:self replaceAttachment:attachment frame:frame context:ctx];
            } else if (attachment.type == WMGAttachmentTypeStaticImage) {
                
                if ([attachment.contents isKindOfClass:[NSString class]]) {
                    UIGraphicsPushContext(ctx);
                    UIImage *image = [UIImage imageNamed:(NSString *)attachment.contents];
                    [image drawInRect:frame];
                    UIGraphicsPopContext();
                }
                else if ([attachment.contents isKindOfClass:[UIImage class]]) {
                    UIGraphicsPushContext(ctx);
                    [(UIImage *)attachment.contents drawInRect:frame];
                    UIGraphicsPopContext();
                }
            }
        }];
        interrupt_if_needed;
    }];
    
#undef interrupt_if_needed
#undef should_interrupt
}

- (void)_drawHighlightedBackgroundForActiveRange:(id<WMGActiveRange>)activeRange rect:(CGRect)rect context:(CGContextRef)context
{
    if ([self.class debugModeEnabled])
    {
        rect = CGRectIntegral(rect);
        UIColor *color = [UIColor blueColor];
        [color set];
        CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 8, color.CGColor);
        wmg_context_fill_round_rect(context, rect, 10);
    }
    
    if (_eventDelegateHas.didHighlightedActiveRange) {
        [_eventDelegate textDrawer:self didHighlightedActiveRange:activeRange rect:rect];
    }
}

#pragma mark - Event Handle

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView *contextView = [self eventDelegateContextView];
    
    if (!contextView) {
        return;
    }
    
    const CGPoint location = [[touches anyObject] locationInView:contextView];
    const CGPoint layoutLocation = [self convertPointToLayout:location offsetPoint:_drawOrigin];
    
    id<WMGActiveRange> activeRange = [self rangeInRanges:[self eventDelegateActiveRanges] forLayoutLocation:layoutLocation];
    
    if (activeRange) {
        [self setPressingActiveRange:activeRange];
        [contextView setNeedsDisplay];
    }
    
    _touchesBeginPoint = location;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIView * contextView = [self eventDelegateContextView];
    
    const CGFloat respondingRadius = 50;
    
    CGPoint location = [[touches anyObject] locationInView:contextView];
    CGFloat movedDistance = sqrt(pow((location.x - _touchesBeginPoint.x), 2.0) + pow((location.y - _touchesBeginPoint.y), 2.0));
    
    BOOL responds = movedDistance <= respondingRadius;
    if (!responds && self.pressingActiveRange)
    {
        self.savedPressingActiveRange = self.pressingActiveRange;
        self.pressingActiveRange = nil;
        
        [contextView setNeedsDisplay];
    }
    else if (responds && self.savedPressingActiveRange)
    {
        self.pressingActiveRange = self.savedPressingActiveRange;
        self.savedPressingActiveRange = nil;
        
        [contextView setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_lastTouchEndedTimeStamp!= event.timestamp) {
        self.savedPressingActiveRange = nil;
        _lastTouchEndedTimeStamp = event.timestamp;
        if (self.pressingActiveRange) {
            
            id<WMGActiveRange> activeRange = self.pressingActiveRange;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self eventDelegateDidPressActiveRange:activeRange];
            });
            
            _touchesBeginPoint = CGPointZero;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 若用户点击速度过快，hitRange高亮状态还未绘制又取消高亮会导致没有高亮效果
                // 故延迟执行
                [self setPressingActiveRange:nil];
                [[self eventDelegateContextView] setNeedsDisplay];
            });
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.savedPressingActiveRange = nil;
    if (self.pressingActiveRange) {
        self.pressingActiveRange = nil;
        
        [[self eventDelegateContextView] setNeedsDisplay];
    }
}

#pragma mark - HitTest

#pragma mark - Hit Testing

- (id<WMGActiveRange>)rangeInRanges:(NSArray *)ranges forLayoutLocation:(CGPoint)location
{
    for (id<WMGActiveRange> activeRange in ranges) {
        
        BOOL __block hit = NO;
        [self.textLayout.layoutFrame enumerateEnclosingRectsForCharacterRange:activeRange.range usingBlock:^(CGRect rect, NSRange characterRange, BOOL *stop) {
            if (CGRectContainsPoint(rect, location)) {
                hit = YES;
                *stop = YES;
            }
        }];
        
        if (hit && _eventDelegateHas.shouldInteractWithActiveRange) {
            hit = [_eventDelegate textDrawer:self shouldInteractWithActiveRange:activeRange];
        }
        
        if (hit) {
            return activeRange;
        }
    }
    
    return nil;
}

#pragma mark - Event Delegate

- (UIView *)eventDelegateContextView
{
    if (_eventDelegateHas.contextView) {
        return [_eventDelegate contextViewForTextDrawer:self];
    }
    return nil;
}

- (NSArray *)eventDelegateActiveRanges
{
    if (_eventDelegateHas.activeRanges) {
        return [_eventDelegate activeRangesForTextDrawer:self];
    }
    return nil;
}

- (void)eventDelegateDidPressActiveRange:(id<WMGActiveRange>)activeRange
{
    if (_eventDelegateHas.didPressActiveRange) {
        [_eventDelegate textDrawer:self didPressActiveRange:activeRange];
    }
}

@end
