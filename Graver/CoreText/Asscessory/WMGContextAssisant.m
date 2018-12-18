//
//  WMGContextAssisant.m
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
    

#import "WMGContextAssisant.h"

void wmg_context_add_round_rect(CGContextRef context, CGRect rect, CGFloat radius)
{
    radius = MIN(radius, rect.size.width / 2);
    radius = MIN(radius, rect.size.height / 2);
    radius = floor(radius);
    
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + radius);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI / 2, 0.0f, 1);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGContextAddArc(context, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI / 2, 1);
    CGContextAddLineToPoint(context, rect.origin.x + radius, rect.origin.y);
    CGContextAddArc(context, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI / 2, M_PI, 1);
}

void wmg_context_clip_to_round_rect(CGContextRef context, CGRect rect, CGFloat radius)
{
    CGContextBeginPath(context);
    wmg_context_add_round_rect(context, rect, radius);
    CGContextClosePath(context);
    CGContextClip(context);
}

void wmg_context_fill_round_rect(CGContextRef context, CGRect rect, CGFloat radius)
{
    CGContextBeginPath(context);
    wmg_context_add_round_rect(context, rect, radius);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

void wmg_context_draw_linear_gradient_between_points(CGContextRef context, CGPoint a, CGFloat color_a[4], CGPoint b, CGFloat color_b[4])
{
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { color_a[0], color_a[1], color_a[2], color_a[3], color_b[0], color_b[1], color_b[2], color_b[3] };
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, NULL, 2);
    CGContextDrawLinearGradient(context, gradient, a, b, 0);
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

CGContextRef wmg_create_graphics_context(CGSize size, BOOL isOpaque)
{
    size_t width = size.width;
    size_t height = size.height;
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    
    if (isOpaque)
    {
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    else
    {
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorSpace, bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    return ctx;
}

CGSize wmg_bitmap_context_get_point_size(CGContextRef ctx)
{
    CGFloat width = CGBitmapContextGetWidth(ctx);
    CGFloat height = CGBitmapContextGetHeight(ctx);
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGContextGetCTM(ctx);
    transform = CGAffineTransformInvert(transform);
    bounds = CGRectApplyAffineTransform(bounds, transform);
    
    return bounds.size;
}

