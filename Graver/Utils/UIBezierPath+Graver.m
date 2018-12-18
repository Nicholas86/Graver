//
//  UIBezierPath+Graver.m
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
    

#import "UIBezierPath+Graver.h"

@implementation UIBezierPath (Graver)

+ (UIBezierPath *)wmg_bezierPathWithRect:(CGRect)rect cornerRadius:(WMGCornerRadius)radius lineWidth:(CGFloat)lineWidth
{
    if (WMGCornerRadiusIsPerfect(radius)) {
        return [UIBezierPath bezierPathWithRoundedRect:rect
                                     byRoundingCorners:UIRectCornerAllCorners
                                           cornerRadii:CGSizeMake(radius.topLeft, radius.topLeft)];
    }
    
    CGFloat lineCenter = lineWidth / 2.0;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(radius.topLeft, lineCenter)];
    [path addArcWithCenter:CGPointMake(radius.topLeft, radius.topLeft) radius:radius.topLeft - lineCenter startAngle:M_PI * 1.5 endAngle:M_PI clockwise:NO];
    [path addLineToPoint:CGPointMake(lineCenter, CGRectGetHeight(rect) - radius.bottomLeft)];
    [path addArcWithCenter:CGPointMake(radius.bottomLeft, CGRectGetHeight(rect) - radius.bottomLeft) radius:radius.bottomLeft - lineCenter startAngle:M_PI endAngle:M_PI * 0.5 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - radius.bottomRight, CGRectGetHeight(rect) - lineCenter)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - radius.bottomRight, CGRectGetHeight(rect) - radius.bottomRight) radius:radius.bottomRight - lineCenter startAngle:M_PI * 0.5 endAngle:0.0 clockwise:NO];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect) - lineCenter, radius.topRight)];
    [path addArcWithCenter:CGPointMake(CGRectGetWidth(rect) - radius.topRight, radius.topRight) radius:radius.topRight - lineCenter startAngle:0.0 endAngle:M_PI * 1.5 clockwise:NO];
    [path closePath];
    
    return path;
}

@end
