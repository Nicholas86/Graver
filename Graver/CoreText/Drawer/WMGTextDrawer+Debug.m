//
//  WMGTextDrawer+Debug.m
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
    

#import "WMGTextDrawer+Debug.h"
#import <UIKit/UIKit.h>
#import "WMGTextDrawer+Coordinate.h"
#import "WMGTextDrawer+Private.h"
#import "WMGTextLayoutFrame.h"
#import "WMGTextLayoutLine.h"

static BOOL WMGTextDrawerDebugModeEnabled = NO;

@implementation WMGTextDrawer (Debug)

+ (void)debugModeSetEverythingNeedsDisplayForView:(UIView *)view
{
    [view setNeedsDisplay];
    
    if ([view respondsToSelector:@selector(displayLayer:)])
    {
        [view displayLayer:view.layer];
    }
    
    for (UIView * subview in view.subviews)
    {
        [self debugModeSetEverythingNeedsDisplayForView:subview];
    }
}

+ (void)debugModeSetEverythingNeedsDisplay
{
    NSArray * windows = [UIApplication sharedApplication].windows;
    
    for (UIWindow * window in windows)
    {
        [self debugModeSetEverythingNeedsDisplayForView:window];
    }
}

+ (BOOL)debugModeEnabled
{
    return WMGTextDrawerDebugModeEnabled;
}

+ (void)setDebugModeEnabled:(BOOL)enabled
{
    WMGTextDrawerDebugModeEnabled = enabled;
    [self debugModeSetEverythingNeedsDisplay];
    [CATransaction flush];
}

+ (void)enableDebugMode
{
    [self setDebugModeEnabled:YES];
}

+ (void)disableDebugMode
{
    [self setDebugModeEnabled:NO];
}

- (void)debugModeDrawLineFramesWithLayoutFrame:(WMGTextLayoutFrame *)layoutFrame context:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
    CGContextSetAlpha(ctx, 0.1);
    CGContextSetFillColorWithColor(ctx, [UIColor greenColor].CGColor);
    CGContextFillRect(ctx, self.frame);
    
    NSArray *lines = layoutFrame.arrayLines;
    
    CGFloat lineWidth = 1 / [UIScreen mainScreen].scale;
    
    [lines enumerateObjectsUsingBlock:^(WMGTextLayoutLine *line, NSUInteger idx, BOOL *stop) {
        CGRect rect = line.lineRect;
        rect = [self convertRectFromLayout:rect offsetPoint:self.drawOrigin];
        
        CGContextSaveGState(ctx);
        
        CGContextSetAlpha(ctx, 0.3);
        CGContextSetFillColorWithColor(ctx, [UIColor blueColor].CGColor);
        CGContextFillRect(ctx, rect);
        
        CGRect baselineRect = CGRectMake(0, 0, rect.size.width, lineWidth);
        baselineRect.origin = [self convertPointFromLayout:line.baselineOrigin offsetPoint:self.drawOrigin];
        
        CGContextSetAlpha(ctx, 0.6);
        CGContextSetFillColorWithColor(ctx, [UIColor redColor].CGColor);
        CGContextFillRect(ctx, baselineRect);
        
        CGContextRestoreGState(ctx);
    }];
    
    CGContextRestoreGState(ctx);
}


@end
