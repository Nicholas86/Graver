//
//  NSMutableAttributedString+GTextProperty.m
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
    

#import "NSMutableAttributedString+GTextProperty.h"
#import "UIFont+Graver.h"
#import "WMGraverMacroDefine.h"

NSString * const WMGTextStrikethroughStyleAttributeName = @"WMGTextStrikethroughStyleAttributeName";
NSString * const WMGTextStrikethroughColorAttributeName = @"WMGTextStrikethroughColorAttributeName";
NSString * const WMGTextDefaultForegroundColorAttributeName = @"WMGTextDefaultForegroundColorAttributeName";

@implementation NSMutableAttributedString (GTextProperty)

- (void)wmg_setFont:(UIFont *)font
{
    [self wmg_setFont:font inRange:[self wmg_stringRange]];
}

- (void)wmg_setFont:(UIFont *)font inRange:(NSRange)range
{
    range = [self wmg_effectiveRangeWithRange:range];
    
    if (!font)
    {
        [self removeAttribute:(NSString *)kCTFontAttributeName range:range];
    }
    else
    {
        [self addAttribute:(NSString *)kCTFontAttributeName value:font range:range];
    }
}

- (void)wmg_setFontSize:(CGFloat)size fontWeight:(CGFloat)weight boldDisplay:(BOOL)boldDisplay
{
    CTFontRef ctFont = NULL;
    if ([[[UIDevice currentDevice] systemVersion] intValue] >= 9)
    {
        NSString *systemFontName = [UIFont wmg_systemFontName];
        
        if (weight != CGFLOAT_MIN)
        {
            ctFont = (__bridge_retained  CTFontRef)[UIFont systemFontOfSize:size weight:weight];
        }
        else
        {
            ctFont = [UIFont wmg_newCTFontWithName:systemFontName size:size];
        }
    }
    else
    {
        ctFont = [UIFont wmg_newCTFontWithName:@"HelveticaNeue" size:size];
    }
    
    if (boldDisplay) {
        CTFontRef boldCTFont = [UIFont wmg_newBoldCTFontForCTFont:ctFont];
        [self wmg_setCTFont:boldCTFont];
        
        if (boldCTFont)
        {
            CFRelease(boldCTFont);
        }
    }
    else{
        [self wmg_setCTFont:ctFont];
    }
    
    if (ctFont)
    {
        CFRelease(ctFont);
    }
}

- (void)wmg_setCTFont:(CTFontRef)ctFont
{
    [self wmg_setCTFont:ctFont inRange:[self wmg_stringRange]];
}

- (void)wmg_setCTFont:(CTFontRef)ctFont inRange:(NSRange)range
{
    range = [self wmg_effectiveRangeWithRange:range];
    
    if (!ctFont)
    {
        [self removeAttribute:(NSString *)kCTFontAttributeName range:range];
    }
    else
    {
        [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:range];
    }
}

- (void)wmg_setColor:(UIColor *)color
{
    [self wmg_setColor:color inRange:[self wmg_stringRange]];
}

- (void)wmg_setColor:(UIColor *)color inRange:(NSRange)range
{
    range = [self wmg_effectiveRangeWithRange:range];
    
    if (!color)
    {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
    }
    else
    {
        CGColorRef cg_color = [color CGColor];
        
        if (cg_color)
        {
            [self addAttribute:(NSString *)kCTForegroundColorAttributeName value:(__bridge id)cg_color range:range];
            
            if (NSEqualRanges(range, [self wmg_stringRange])) {
                [self addAttribute:WMGTextDefaultForegroundColorAttributeName value:(__bridge id)cg_color range:range];
            }
        }
    }
}

- (void)wmg_setKerning:(CGFloat)kern
{
    [self wmg_setKerning:kern inRange:[self wmg_stringRange]];
}

- (void)wmg_setKerning:(CGFloat)kern inRange:(NSRange)range
{
    range = [self wmg_effectiveRangeWithRange:range];
    
    [self addAttribute:(NSString *)kCTKernAttributeName value:[NSNumber numberWithFloat:kern] range:range];
}

- (void)wmg_setTextLigature:(WMGTextLigature)textLigature
{
    [self addAttribute:(id)kCTLigatureAttributeName value:@(textLigature) range:[self wmg_stringRange]];
}

- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle
{
    [self wmg_setUnderlineStyle:underlineStyle inRange:[self wmg_stringRange]];
}

- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle color:(UIColor *)color
{
    [self wmg_setUnderlineStyle:underlineStyle color:color inRange:[self wmg_stringRange]];
}

- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle inRange:(NSRange)range
{
    [self wmg_setUnderlineStyle:underlineStyle color:WMGHEXCOLOR(0x333333) inRange:range];
}

- (void)wmg_setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle color:(UIColor *)color inRange:(NSRange)range
{
    if (underlineStyle != WMGTextUnderlineStyleNone) {
        [self addAttribute:(id)kCTUnderlineStyleAttributeName value:@(underlineStyle) range:range];
    }
    
    if (color) {
        [self addAttribute:(id)kCTUnderlineColorAttributeName value:color range:range];
    }
}

- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle
{
    [self wmg_setStrikeThroughStyle:strikeThroughStyle inRange:[self wmg_stringRange]];
}

- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle color:(UIColor *)color
{
    [self wmg_setStrikeThroughStyle:strikeThroughStyle color:color inRange:[self wmg_stringRange]];
}

- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle inRange:(NSRange)range
{
    [self wmg_setStrikeThroughStyle:strikeThroughStyle color:WMGHEXCOLOR(0x999999) inRange:range];
}

- (void)wmg_setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle color:(UIColor *)color inRange:(NSRange)range
{
    if (strikeThroughStyle != WMGTextStrikeThroughStyleNone) {
        [self addAttribute:WMGTextStrikethroughStyleAttributeName value:@(strikeThroughStyle) range:range];
    }
    
    if (color) {
        [self addAttribute:WMGTextStrikethroughColorAttributeName value:color range:range];
    }
}

- (void)wmg_setAlignment:(WMGTextAlignment)alignment
{
    [self wmg_setAlignment:alignment lineBreakMode:NSLineBreakByWordWrapping];
}

- (void)wmg_setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [self wmg_setAlignment:alignment lineBreakMode:lineBreakMode lineHeight:0];
}

- (void)wmg_setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineheight
{
    CTLineBreakMode nativeLineBreakMode = kCTLineBreakByTruncatingTail;
    switch(lineBreakMode) {
        case NSLineBreakByWordWrapping:
            nativeLineBreakMode = kCTLineBreakByWordWrapping;
            break;
        case NSLineBreakByCharWrapping:
            nativeLineBreakMode = kCTLineBreakByCharWrapping;
            break;
        case NSLineBreakByClipping:
            nativeLineBreakMode = kCTLineBreakByClipping;
            break;
        case NSLineBreakByTruncatingHead:
            nativeLineBreakMode = kCTLineBreakByTruncatingHead;
            break;
        case NSLineBreakByTruncatingTail:
            nativeLineBreakMode = kCTLineBreakByTruncatingTail;
            break;
        case NSLineBreakByTruncatingMiddle:
            nativeLineBreakMode = kCTLineBreakByTruncatingMiddle;
            break;
    }
    
    CTTextAlignment nativeTextAlignment;
    switch(alignment) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        case WMGTextAlignmentRight:
            nativeTextAlignment = kCTRightTextAlignment;
            break;
        case WMGTextAlignmentCenter:
            nativeTextAlignment = kCTCenterTextAlignment;
            break;
        case WMGTextAlignmentJustified:
            nativeTextAlignment = kCTJustifiedTextAlignment;
            break;
        case WMGTextAlignmentLeft:
        default:
            nativeTextAlignment = kCTLeftTextAlignment;
            break;
#pragma clang diagnostic pop
    }
    
    CTParagraphStyleSetting settings[] = {
        kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &nativeLineBreakMode,
        kCTParagraphStyleSpecifierAlignment, sizeof(CTTextAlignment), &nativeTextAlignment
    };
    CTParagraphStyleRef p = CTParagraphStyleCreate(settings, 2);
    [self addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)p range:[self wmg_stringRange]];
    CFRelease(p);
}

- (void)wmg_setTextParagraphStyle:(WMGTextParagraphStyle *)paragraphStyle fontSize:(CGFloat)fontSize
{
    CTParagraphStyleRef p = [paragraphStyle ctParagraphStyleWithFontSize:fontSize];
    [self addAttribute:(NSString *)kCTParagraphStyleAttributeName value:(__bridge id)p range:[self wmg_stringRange]];
    CFRelease(p);
}

#pragma mark

- (NSRange)wmg_stringRange
{
    return NSMakeRange(0, [self length]);
}

- (NSRange)wmg_effectiveRangeWithRange:(NSRange)range
{
    NSInteger stringLength = self.length;
    
    if (range.location == NSNotFound ||
        range.location > stringLength)
    {
        range.location = 0;
    }
    
    if (range.location + range.length > stringLength)
    {
        range.length = stringLength - range.location;
    }
    
    return range;
}

@end
