//
//  WMGTextLayoutLine.m
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
    

#import "WMGTextLayoutLine.h"
#import "WMGTextLayout.h"
#import "WMGTextLayout+Coordinate.h"
#import "NSMutableAttributedString+GTextProperty.h"

extern NSString * const WMGTextStrikethroughStyleAttributeName;

@interface WMGTextLayoutLine ()
{
    CTLineRef _lineRef;
    CGFloat _lineWidth;
}
@property (nonatomic, strong, readwrite) NSArray *strikeThroughFrames;
@end

@implementation WMGTextLayoutLine

- (void)dealloc
{
    if (_lineRef) {
        CFRelease(_lineRef);
        _lineRef = NULL;
    }
}

- (id)initWithCTLine:(CTLineRef)lineRef baselineOrigin:(CGPoint)baselineOrigin textLayout:(WMGTextLayout *)textLayout
{
    return [self initWithCTLine:lineRef truncatedLine:NULL baselineOrigin:baselineOrigin textLayout:textLayout];
}

- (id)initWithCTLine:(CTLineRef)lineRef truncatedLine:(CTLineRef)truncatedLineRef baselineOrigin:(CGPoint)baselineOrigin textLayout:(WMGTextLayout *)textLayout
{
    if (self = [self init])
    {
        if (lineRef)
        {
            _truncated = (truncatedLineRef != NULL);
            _lineRef = CFRetain(truncatedLineRef ? : lineRef);
            
            CGFloat a, d, l;
            _lineWidth = CTLineGetTypographicBounds(_lineRef, &a, &d, &l);
            
            CFRange range = CTLineGetStringRange(lineRef);
            _originStringRange = NSMakeRange(range.location, range.length);
            
            CFRange truncatedRange = CTLineGetStringRange(_lineRef);
            _truncatedStringRange = NSMakeRange(truncatedRange.location, truncatedRange.length);
            
            if (truncatedLineRef) {
                _originStringRange.length = truncatedRange.length;
            }
            
            _originalFontMetrics = WMGFontMetricsMake(ABS(a), ABS(d), ABS(l));
            
            _fontMetrics = WMGFontMetricsMake(ABS(a), ABS(d), ABS(l));
            if (textLayout.baselineFontMetrics.leading != NSNotFound &&
                textLayout.baselineFontMetrics.leading) {
                // 暂时写死基准的3倍
                _fontMetrics.leading = MIN(_fontMetrics.leading, 3 * textLayout.baselineFontMetrics.leading);
            }
            
            _originalBaselineOrigin = baselineOrigin;
            // 基线调整
            double baselineOriginY = baselineOrigin.y;
            if (textLayout.baselineFontMetrics.descent != NSNotFound) {
                baselineOriginY -= (_fontMetrics.descent - textLayout.baselineFontMetrics.descent);
            }
            
            if (textLayout.baselineFontMetrics.leading != NSNotFound &&
                textLayout.baselineFontMetrics.leading) {
                baselineOriginY -= (_fontMetrics.leading - textLayout.baselineFontMetrics.leading);
            }
            
            //12.3
            double lineHeight = _fontMetrics.ascent + _fontMetrics.descent + _fontMetrics.leading;
            // 13
            double ceilResult = ceil(lineHeight) - lineHeight;
            // 14
            ceilResult += 1;
            
            baselineOriginY -= ceilResult;
            
            _baselineOrigin = CGPointMake(baselineOrigin.x, floor(baselineOriginY));
            
            // CoreText Coordinate Convert to UI Coordinate
            _originalBaselineOrigin = [textLayout wmg_UIPointFromCTPoint:_originalBaselineOrigin];
            _baselineOrigin = [textLayout wmg_UIPointFromCTPoint:_baselineOrigin];
            
            if (textLayout.baselineFontMetrics.ascent == NSNotFound && textLayout.retriveFontMetricsAutomatically) {
                textLayout.baselineFontMetrics = _fontMetrics;
            }
            
            // 删除线
            NSMutableArray *array = [NSMutableArray array];
            [textLayout.attributedString enumerateAttribute:WMGTextStrikethroughStyleAttributeName inRange:_originStringRange options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
                if (value) {
                    WMGTextStrikeThroughStyle style = [value unsignedIntegerValue];
                    CGFloat start = [self offsetXForCharacterAtIndex:range.location];
                    CGFloat end = [self offsetXForCharacterAtIndex:NSMaxRange(range)];
                    
                    [array addObject:[NSValue valueWithCGRect:CGRectMake(start, self->_baselineOrigin.y - 3, end - start, (style == WMGTextStrikeThroughStyleSingle) ? 1 : 2)]];
                }
            }];
            self.strikeThroughFrames = array;
            
            // 背景色 边框等识别
            
            
        }
    }
    return self;
}

- (CGRect)originalLineRect
{
    return CGRectIntegral(CGRectMake(_originalBaselineOrigin.x, _originalBaselineOrigin.y - _originalFontMetrics.ascent, _lineWidth, WMGFontMetricsGetLineHeight(_originalFontMetrics)));
}

- (CGRect)lineRect
{
    return CGRectIntegral(CGRectMake(_baselineOrigin.x, _baselineOrigin.y - _fontMetrics.ascent, _lineWidth, WMGFontMetricsGetLineHeight(_fontMetrics)));
}

- (CTLineRef)lineRef
{
    return _lineRef;
}

- (NSInteger)_rangeLocOffset
{
    if (!_lineRef) {
        return 0;
    }
    
    return MAX(_originStringRange.location - _truncatedStringRange.location, 0);
}

- (CGFloat)offsetXForCharacterAtIndex:(NSUInteger)characterIndex
{
    if (!_lineRef) {
        return 0;
    }
    NSInteger locOffset = [self _rangeLocOffset];
    characterIndex -= MIN(characterIndex, locOffset);
    
    CGFloat offset = CTLineGetOffsetForStringIndex(_lineRef, characterIndex, NULL);
    return offset;
}

- (CGPoint)baselineOriginForCharacterAtIndex:(NSUInteger)characterIndex
{
    CGPoint origin = _baselineOrigin;
    if (!_lineRef) {
        return origin;
    }
    
    NSInteger locOffset = [self _rangeLocOffset];
    characterIndex -= MIN(characterIndex, locOffset);
    
    CGFloat offset = CTLineGetOffsetForStringIndex(_lineRef, characterIndex, NULL);
    origin.x += offset;
    return origin;
}

- (NSUInteger)characterIndexForBoundingPosition:(CGPoint)position
{
    NSUInteger index = _originStringRange.location;
    
    if (_lineRef) {
        index = CTLineGetStringIndexForPosition(_lineRef, position);
        index += [self _rangeLocOffset];
    }
    
    return index;
}

- (void)enumerateRunsUsingBlock:(void (^)(NSUInteger idx, NSDictionary * attributes, NSRange characterRange, BOOL *stop))block
{
    if (!_lineRef || !block) {
        return;
    }
    
    NSInteger locOffset = [self _rangeLocOffset];
    
    NSArray * runs = (NSArray *)CTLineGetGlyphRuns(_lineRef);
    [runs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CTRunRef run = (__bridge CTRunRef)obj;
        NSDictionary * attributes = (NSDictionary *)CTRunGetAttributes(run);
        CFRange range = CTRunGetStringRange(run);
        NSRange nsRange = NSMakeRange(range.location, range.length);
        nsRange.location += locOffset;
        block(idx, attributes, nsRange, stop);
    }];
}


- (id)copyWithZone:(NSZone *)zone
{
    WMGTextLayoutLine *line = [[[self class] allocWithZone:zone] init];
    line->_lineRef = _lineRef;
    line->_truncated = _truncated;
    line->_lineWidth = _lineWidth;
    
    line->_originalBaselineOrigin = _originalBaselineOrigin;
    line->_baselineOrigin = _baselineOrigin;
    
    line->_originStringRange = _originStringRange;
    line->_truncatedStringRange = _truncatedStringRange;
    
    line->_originalFontMetrics = _originalFontMetrics;
    line->_fontMetrics = _fontMetrics;
    
    return line;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    WMGTextLayoutLine *line = [[self class] allocWithZone:zone];
    return line;
}

@end
