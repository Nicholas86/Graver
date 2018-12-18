//
//  WMGCanvasView.m
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

NSString * const WMGCanvasViewCornerRadiusKey      = @"waimai-graver-canvas-cornerradius-key";
NSString * const WMGCanvasViewBorderWidthKey       = @"waimai-graver-canvas-borderwidth-key";
NSString * const WMGCanvasViewBorderColorKey       = @"waimai-graver-canvas-bordercolor-key";

NSString * const WMGCanvasViewShadowColorKey       = @"waimai-graver-canvas-shadowcolor-key";
NSString * const WMGCanvasViewShadowOffsetKey      = @"waimai-graver-canvas-shadowoffset-key";
NSString * const WMGCanvasViewShadowBlurKey        = @"waimai-graver-canvas-shadowblur-key";

NSString * const WMGCanvasViewBackgroundColorKey   = @"waimai-graver-canvas-backgroundcolor-key";
NSString * const WMGCanvasViewBackgroundImageKey   = @"waimai-graver-canvas-backgroundimage-key";

@interface WMGCanvasView ()
@property (nonatomic, strong) UIColor *fillColor;
@end

@implementation WMGCanvasView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.drawingPolicy = WMGViewDrawingPolicyAsynchronouslyDrawWhenContentsChanged;
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = NO;
        self.contentMode = UIViewContentModeRedraw;
        
        _cornerRadius = 0.0;
        _borderWidth = 0.0;
        _borderColor = nil;
        
        _shadowColor = nil;
        _shadowOffset = UIOffsetZero;
        _shadowBlur = 0.0;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    if (_fillColor != backgroundColor) {
        _fillColor = backgroundColor;
        self.contentsChangedAfterLastAsyncDrawing = YES;
        [self setNeedsDisplay];
    }
}

- (UIColor *)backgroundColor{
    return _fillColor;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (_backgroundImage != backgroundImage) {
        _backgroundImage = backgroundImage;
        
        self.contentsChangedAfterLastAsyncDrawing = YES;
        [self setNeedsDisplay];
    }
}

- (NSDictionary *)currentDrawingUserInfo
{
    NSDictionary *dic = [super currentDrawingUserInfo];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (dic) {
        [userInfo addEntriesFromDictionary:dic];
    }
    
    if (self.borderWidth > 0.0) {
        [userInfo setValue:@(self.borderWidth) forKey:WMGCanvasViewBorderWidthKey];
    }
    
    if (self.cornerRadius >= 0.0) {
        [userInfo setValue:@(self.cornerRadius) forKey:WMGCanvasViewCornerRadiusKey];
    }
    
    if (self.borderColor) {
        [userInfo setValue:self.borderColor forKey:WMGCanvasViewBorderColorKey];
    }
    
    if (self.shadowColor) {
        [userInfo setValue:self.shadowColor forKey:WMGCanvasViewShadowColorKey];
    }
    
    if (!UIOffsetEqualToOffset(self.shadowOffset, UIOffsetZero)) {
        [userInfo setValue:[NSValue valueWithUIOffset:self.shadowOffset] forKey:WMGCanvasViewShadowOffsetKey];
    }
    
    if (self.shadowBlur > 0.0) {
        [userInfo setValue:@(self.shadowBlur) forKey:WMGCanvasViewShadowBlurKey];
    }
    
    if (self.fillColor) {
        [userInfo setValue:self.fillColor forKey:WMGCanvasViewBackgroundColorKey];
    }
    
    if (self.backgroundImage) {
        [userInfo setValue:self.backgroundImage forKey:WMGCanvasViewBackgroundImageKey];
    }
    
    return userInfo;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
{
    [super drawInRect:rect withContext:context asynchronously:asynchronously userInfo:userInfo];
    
    UIColor *backgroundColor = (UIColor *)[userInfo valueForKey:WMGCanvasViewBackgroundColorKey];
    
    CGFloat borderWidth = [[userInfo valueForKey:WMGCanvasViewBorderWidthKey] floatValue];
    CGFloat cornerRadius = [[userInfo valueForKey:WMGCanvasViewCornerRadiusKey] floatValue];
    UIColor *borderColor = (UIColor *)[userInfo valueForKey:WMGCanvasViewBorderColorKey];
    
    borderWidth *= [[UIScreen mainScreen] scale];
    
    if(cornerRadius == 0){
        
        if (backgroundColor && backgroundColor != [UIColor clearColor]) {
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextFillRect(context, rect);
        }
        
        if(borderWidth > 0){
            CGContextAddPath(context, [UIBezierPath bezierPathWithRect:rect].CGPath);
        }
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        
        if(borderWidth > 0){
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, borderWidth);
            CGContextDrawPath(context, kCGPathFillStroke);
        }else{
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    else{
        
        CGRect targetRect = CGRectMake(0, 0, rect.size.width , rect.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:targetRect
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
        [path setUsesEvenOddFillRule:YES];
        [path addClip];
        CGContextAddPath(context, path.CGPath);
        
        if (backgroundColor && backgroundColor != [UIColor clearColor]) {
            CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
            CGContextFillRect(context, rect);
            CGContextAddPath(context, path.CGPath);
        }
        
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        
        if(borderWidth > 0){
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, borderWidth);
            CGContextDrawPath(context, kCGPathFillStroke);
        }else{
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    // 阴影设置
    UIColor *shadowColor = (UIColor *)[userInfo valueForKey:WMGCanvasViewShadowColorKey];
    CGFloat shadowBlur = [[userInfo valueForKey:WMGCanvasViewShadowBlurKey] floatValue];
    UIOffset shadowOffset = [[userInfo valueForKey:WMGCanvasViewShadowOffsetKey] UIOffsetValue];
    
    if (shadowColor) {
        CGContextSetShadowWithColor(context, CGSizeMake(shadowOffset.horizontal, shadowOffset.vertical), shadowBlur, shadowColor.CGColor);
    }
    
    UIGraphicsPushContext(context);
    UIImage *image = [userInfo valueForKey:WMGCanvasViewBackgroundImageKey];
    [image drawInRect:rect];
    UIGraphicsPopContext();
    
    return YES;
}


@end
