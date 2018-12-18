//
//  WMGTextParagraphStyle.m
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
    

#import "WMGTextParagraphStyle.h"
#import "UIDevice+Graver.h"

@interface WMGTextParagraphStyle ()
{
    struct {
        unsigned int didUpdateAttribute: 1;
    } _delegateHas;
    
    BOOL isNeedChaneSpace;
}

@end

@implementation WMGTextParagraphStyle

+ (instancetype)defaultParagraphStyle
{
    WMGTextParagraphStyle *style = [[WMGTextParagraphStyle alloc] init];
    
    style->_lineSpacing = 5;
    style->_allowsDynamicLineSpacing = YES;
    style->_lineBreakMode = NSLineBreakByWordWrapping;
    style->_alignment = NSTextAlignmentLeft;
    
    return style;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIDevice *device = [UIDevice currentDevice];
        if ([device wmg_isRetina4Inch]||[device wmg_isIPhone6]) {
            isNeedChaneSpace = YES;
        } else {
            isNeedChaneSpace = NO;
        }
    }
    return self;
}

- (void)setDelegate:(id<WMGTextParagraphStyleDelegate>)delegate
{
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateHas.didUpdateAttribute = [delegate respondsToSelector:@selector(paragraphStyleDidUpdated:)];
    }
}

- (NSParagraphStyle *)nsParagraphStyleWithFontSize:(NSInteger)fontSize
{
    CGFloat minLineHeight = fontSize + self.lineSpacing;
    CGFloat maxLineHeight = self.maximumLineHeight;
    
    if (!maxLineHeight) {
        maxLineHeight = self.allowsDynamicLineSpacing ? minLineHeight : minLineHeight;
    }
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    
    style.lineBreakMode = self.lineBreakMode;
    style.alignment = self.alignment;
    style.baseWritingDirection = NSWritingDirectionLeftToRight;
    style.minimumLineHeight = minLineHeight;
    style.maximumLineHeight = maxLineHeight;
    if (isNeedChaneSpace) {
        style.lineSpacing = 1;
    } else {
        style.lineSpacing = 2;
    }
    style.firstLineHeadIndent = self.firstLineHeadIndent;
    style.paragraphSpacingBefore = self.paragraphSpacingBefore;
    style.paragraphSpacing = self.paragraphSpacingAfter;
    
    return style;
}

- (CTParagraphStyleRef)ctParagraphStyleWithFontSize:(NSInteger)fontSize
{
    CGFloat minLineHeight = fontSize + self.lineSpacing;
    CGFloat maxLineHeight = self.maximumLineHeight;
    
    if (!maxLineHeight) {
        maxLineHeight = self.allowsDynamicLineSpacing ? minLineHeight : minLineHeight;
    }
    
    CTLineBreakMode lineBreakMode = (CTLineBreakMode)self.lineBreakMode;
    CTTextAlignment textAlignment = NSTextAlignmentToCTTextAlignment(self.alignment);
    CTWritingDirection writingDirection = kCTWritingDirectionLeftToRight;
    
    NSInteger space = 2;
    if (isNeedChaneSpace) {
        space = 1;
    }
    CGFloat minLineSpacing = space;
    CGFloat maxLineSpacing = space;
    
    CTParagraphStyleSetting settings[] = {
        kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode,
        kCTParagraphStyleSpecifierAlignment    , sizeof(CTTextAlignment), &textAlignment,
        kCTParagraphStyleSpecifierBaseWritingDirection, sizeof(CTWritingDirection), &writingDirection,
        kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &(CGFloat){minLineHeight},
        kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &(CGFloat){maxLineHeight},
        kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &(CGFloat){minLineSpacing},
        kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &(CGFloat){maxLineSpacing},
        kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &(CGFloat){self.paragraphSpacingBefore},
        kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &(CGFloat){self.paragraphSpacingAfter},
        kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &(CGFloat){self.firstLineHeadIndent},
    };
    CTParagraphStyleRef p = CTParagraphStyleCreate(settings, 10);
    
    return p;
}

- (void)setAllowsDynamicLineSpacing:(BOOL)allowsDynamicLineSpacing
{
    if (_allowsDynamicLineSpacing != allowsDynamicLineSpacing) {
        _allowsDynamicLineSpacing = allowsDynamicLineSpacing;
        [self propertyUpdated];
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing
{
    if (_lineSpacing != lineSpacing) {
        _lineSpacing = lineSpacing;
        [self propertyUpdated];
    }
}

- (void)setMaximumLineHeight:(CGFloat)maximumLineHeight
{
    if (_maximumLineHeight != maximumLineHeight) {
        _maximumLineHeight = maximumLineHeight;
        [self propertyUpdated];
    }
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if (_lineBreakMode != lineBreakMode) {
        _lineBreakMode = lineBreakMode;
        [self propertyUpdated];
    }
}

- (void)setAlignment:(NSTextAlignment)alignment
{
    if (_alignment != alignment) {
        _alignment = alignment;
        [self propertyUpdated];
    }
}

- (void)setFirstLineHeadIndent:(CGFloat)firstLineHeadIndent
{
    if (_firstLineHeadIndent != firstLineHeadIndent) {
        _firstLineHeadIndent = firstLineHeadIndent;
        [self propertyUpdated];
    }
}

- (void)setParagraphSpacingBefore:(CGFloat)paragraphSpacingBefore
{
    if (_paragraphSpacingBefore != paragraphSpacingBefore) {
        _paragraphSpacingBefore = paragraphSpacingBefore;
        [self propertyUpdated];
    }
}

- (void)setParagraphSpacingAfter:(CGFloat)paragraphSpacingAfter
{
    if (_paragraphSpacingAfter != paragraphSpacingAfter) {
        _paragraphSpacingAfter = paragraphSpacingAfter;
        [self propertyUpdated];
    }
}

- (void)propertyUpdated
{
    if (_delegateHas.didUpdateAttribute) {
        [_delegate paragraphStyleDidUpdated:self];
    }
}
@end
