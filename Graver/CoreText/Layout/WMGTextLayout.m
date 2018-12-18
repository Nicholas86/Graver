//
//  WMGTextLayout.m
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
    

#import "WMGTextLayout.h"
#import "WMGTextLayoutFrame.h"

@interface WMGTextLayout ()
{
    struct {
        unsigned int needsLayout: 1;
    } _flags;
}
@property (nonatomic, strong) WMGTextLayoutFrame *layoutFrame;
@end


@implementation WMGTextLayout

- (instancetype)init
{
    if (self = [super init]) {
        _flags.needsLayout = YES;
        _heightSensitiveLayout = YES;
        _baselineFontMetrics = WMGFontMetricsNull;
    }
    return self;
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
    if (_attributedString != attributedString) {
        @synchronized(self) {
            _attributedString = attributedString;
        }
        [self setNeedsLayout];
    }
}

- (void)setSize:(CGSize)size
{
    if (!CGSizeEqualToSize(_size, size)) {
        _size = size;
        _flags.needsLayout = YES;
    }
}

- (void)setMaximumNumberOfLines:(NSUInteger)maximumNumberOfLines
{
    if (_maximumNumberOfLines != maximumNumberOfLines) {
        _maximumNumberOfLines = maximumNumberOfLines;
        [self setNeedsLayout];
    }
}

- (void)setBaselineFontMetrics:(WMGFontMetrics)baselineFontMetrics
{
    if (!WMGFontMetricsEqual(_baselineFontMetrics, baselineFontMetrics)) {
        _baselineFontMetrics = baselineFontMetrics;
        [self setNeedsLayout];
    }
}

- (void)setNeedsLayout
{
    _flags.needsLayout = YES;
}

#pragma mark - Layout Result

- (WMGTextLayoutFrame *)layoutFrame
{
    if (!_layoutFrame || _flags.needsLayout) {
        @synchronized(self) {
            _layoutFrame = [self _createLayoutFrame];
        }
        _flags.needsLayout = NO;
    }
    return _layoutFrame;
}

- (WMGTextLayoutFrame *)_createLayoutFrame
{
    const NSAttributedString *attributedString = _attributedString;
    
    if (!attributedString) {
        return nil;
    }
    
    CTFrameRef ctFrame = NULL;
    
    {
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0, 0, _size.width, _size.height));
        
        ctFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFRelease(path);
        CFRelease(framesetter);
    }
    
    if (!ctFrame) {
        return nil;
    }
    
    WMGTextLayoutFrame *layoutFrame = [[WMGTextLayoutFrame alloc] initWithCTFrame:ctFrame textLayout:self];
    
    CFRelease(ctFrame);
    
    return layoutFrame;
}

- (BOOL)layoutUpToDate
{
    return !_flags.needsLayout || !_layoutFrame;
}

@end

CGFloat const WMGTextLayoutMaximumWidth  = 2000;
CGFloat const WMGTextLayoutMaximumHeight = 10000000;
