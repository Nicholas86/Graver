//
//  NSAttributedString+GCalculateAndDraw.m
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
    

#import "NSAttributedString+GCalculateAndDraw.h"
#import "NSMutableAttributedString+GTextProperty.h"
#import "WMGTextDrawer.h"
#import "WMGTextLayout.h"
#import "WMGTextLayoutFrame.h"
#import "NSObject+Graver.h"

@implementation NSAttributedString (GCalculateAndDraw)

static NSString * const kThreadTextDrawerKey = @"com.meituan.waimai.thread-wmgtextdrawer";
+ (WMGTextDrawer *)textDrawerForCurrentThread
{
    NSThread *currentThread = [NSThread currentThread];
    WMGTextDrawer *drawer = [currentThread wmg_objectWithAssociatedKey:(__bridge void *)(kThreadTextDrawerKey)];
    if (!drawer)
    {
        drawer = [[WMGTextDrawer alloc] init];
        [currentThread wmg_setObject:drawer forAssociatedKey:(__bridge void *)(kThreadTextDrawerKey) associationPolicy:OBJC_ASSOCIATION_RETAIN];
    }
    return drawer;
}

+ (WMGTextDrawer *)wmg_sharedTextDrawer
{
    return [self textDrawerForCurrentThread];
}

- (WMGTextDrawer *)wmg_sharedTextDrawer
{
    return [[self class] wmg_sharedTextDrawer];
}

#pragma mark - Size

- (CGSize)wmg_size
{
    return [self wmg_sizeConstrainedToSize:CGSizeMake(WMGTextLayoutMaximumWidth, WMGTextLayoutMaximumHeight)];
}

- (CGSize)wmg_sizeConstrainedToSize:(CGSize)size
{
    return [self wmg_sizeConstrainedToSize:size numberOfLines:0];
}

- (CGSize)wmg_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines
{
    return [self wmg_sizeConstrainedToSize:size numberOfLines:numberOfLines derivedLineCount:NULL];
}

- (CGSize)wmg_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger *)derivedLineCount
{
    return [self wmg_sizeConstrainedToSize:size numberOfLines:numberOfLines derivedLineCount:derivedLineCount baselineMetrics:WMGFontMetricsNull];
}

- (CGSize)wmg_sizeConstrainedToSize:(CGSize)size numberOfLines:(NSInteger)numberOfLines derivedLineCount:(NSInteger *)derivedLineCount baselineMetrics:(WMGFontMetrics)metrics
{
    size.width = MIN(WMGTextLayoutMaximumWidth, size.width);
    size.height = MIN(WMGTextLayoutMaximumHeight, size.height);
    
    WMGTextLayout *layout = [NSAttributedString wmg_sharedTextDrawer].textLayout;
    layout.attributedString = self;
    layout.size = size;
    layout.maximumNumberOfLines = numberOfLines;
    layout.baselineFontMetrics = metrics;
    
    CGSize textSize = layout.layoutFrame.layoutSize;
    
    layout.maximumNumberOfLines = 0;
    if (derivedLineCount)
    {
        *derivedLineCount = [layout.layoutFrame.arrayLines count];
    }
    
    size.width = MAX(textSize.width, CGSizeZero.width);
    size.width = MIN(textSize.width, size.width);
    
    size.height = MAX(textSize.height, CGSizeZero.height);
    size.height = MIN(textSize.height, size.height);
    
    return size;
}

- (CGSize)wmg_sizeConstrainedToWidth:(CGFloat)width
{
    return [self wmg_sizeConstrainedToSize:CGSizeMake(width, WMGTextLayoutMaximumHeight)];
}

- (CGSize)wmg_sizeConstrainedToWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines
{
    return [self wmg_sizeConstrainedToSize:CGSizeMake(width, WMGTextLayoutMaximumHeight) numberOfLines:numberOfLines];
}

- (CGFloat)wmg_heightConstrainedToWidth:(CGFloat)width
{
    WMGTextLayout * layout = [NSAttributedString wmg_sharedTextDrawer].textLayout;
    
    layout.maximumNumberOfLines = 0;
    layout.attributedString = self;
    layout.size = CGSizeMake(width, WMGTextLayoutMaximumHeight);
    
    return layout.layoutFrame.layoutSize.height;
}

#pragma mark - Draw in Rect

- (CGSize)wmg_drawInRect:(CGRect)rect
{
    return [self wmg_drawInRect:rect context:UIGraphicsGetCurrentContext()];
}

- (CGSize)wmg_drawInRect:(CGRect)rect context:(CGContextRef)ctx
{
    return [self wmg_drawInRect:rect numberOfLines:0 context:ctx];
}

- (CGSize)wmg_drawInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines context:(CGContextRef)ctx
{
    return [self wmg_drawInRect:rect numberOfLines:numberOfLines baselineMetrics:WMGFontMetricsNull context:ctx];
}

- (CGSize)wmg_drawInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines baselineMetrics:(WMGFontMetrics)metrics context:(CGContextRef)ctx
{
    WMGTextDrawer *drawer = [NSAttributedString wmg_sharedTextDrawer];
    
    drawer.textLayout.maximumNumberOfLines = numberOfLines;
    drawer.textLayout.baselineFontMetrics = metrics;
    
    drawer.textLayout.attributedString = self;
    drawer.frame = rect;
    
    [drawer drawInContext:ctx];
    
    CGSize layoutSize = drawer.textLayout.layoutFrame.layoutSize;
    
    return layoutSize;
}

- (CGSize)wmg_drawInRect:(CGRect)rect numberOfLines:(NSInteger)numberOfLines baselineMetrics:(WMGFontMetrics)metrics context:(CGContextRef)ctx textDrawer:(WMGTextDrawer *)textDrawer
{
    WMGTextDrawer *t = textDrawer;
    if (!t) {
        t = [NSAttributedString wmg_sharedTextDrawer];
    }
    t.textLayout.maximumNumberOfLines = numberOfLines;
    t.textLayout.baselineFontMetrics = metrics;
    
    t.textLayout.attributedString = self;
    t.frame = rect;
    [t drawInContext:ctx];
    
    CGSize layoutSize = t.textLayout.layoutFrame.layoutSize;
    
    return layoutSize;
}

#pragma mark - Size Based Drawing

- (void)wmg_drawWithWidth:(CGFloat)width frameBlock:(WMGTextDrawingFrameBlock)frameBlock
{
    [self wmg_drawWithWidth:width numberOfLines:0 context:UIGraphicsGetCurrentContext() frameBlock:frameBlock];
}

- (void)wmg_drawWithWidth:(CGFloat)width numberOfLines:(NSInteger)numberOfLines context:(CGContextRef)ctx frameBlock:(WMGTextDrawingFrameBlock)frameBlock
{
    if (!frameBlock) return;
    
    WMGTextDrawer *drawer = [NSAttributedString wmg_sharedTextDrawer];
    
    drawer.textLayout.maximumNumberOfLines = numberOfLines;
    drawer.textLayout.heightSensitiveLayout = NO;
    
    {
        [drawer.textLayout setAttributedString:self];
        
        if (!width) width = WMGTextLayoutMaximumWidth;
        
        [drawer setFrame:CGRectMake(0, 0, width, 1)];
        
        CGSize size = [drawer.textLayout.layoutFrame layoutSize];
        CGRect frame = frameBlock(size);
        
        [drawer setFrame:frame];
        
        [drawer drawInContext:ctx];
    }
    
    drawer.textLayout.heightSensitiveLayout = YES;
    drawer.textLayout.maximumNumberOfLines = 0;
}

- (WMGTextLayout *)wmg_layoutToWidth:(CGFloat)width maxNumberOfLines:(NSInteger)lines
{
    return [self wmg_layoutToWidth:width maxNumberOfLines:lines layoutSize:CGSizeZero];
}

- (WMGTextLayout *)wmg_layoutToWidth:(CGFloat)width maxNumberOfLines:(NSInteger)lines layoutSize:(CGSize)layoutSize
{
    WMGTextLayout *layout = [NSAttributedString wmg_sharedTextDrawer].textLayout;
    
    layout.maximumNumberOfLines = lines;
    layout.attributedString = self;
    if (!CGSizeEqualToSize(layoutSize, CGSizeZero)) {
        layout.size = layoutSize;
    } else {
        layout.size = CGSizeMake(width, WMGTextLayoutMaximumHeight);
    }
    [layout.layoutFrame layoutSize];
    return layout;
}

@end

#pragma mark -

@implementation NSString (TextDrawing)

#pragma mark - Size

static NSCache *WMGStringLayoutSizeCache;
- (CGSize)wmg_cacheSizeWithFont:(UIFont *)font
{
    NSValue *sizeValue = nil;
    NSString *cacheKey = [NSString stringWithFormat:@"%lud-%lud", (unsigned long)[self hash], (unsigned long)[font hash]];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        WMGStringLayoutSizeCache = [[NSCache alloc] init];
    });
    sizeValue = [WMGStringLayoutSizeCache objectForKey:cacheKey];
    if (sizeValue) {
        return [sizeValue CGSizeValue];
    } else {
        CGSize size = [self wmg_sizeWithFont:font];
        [WMGStringLayoutSizeCache setObject:[NSValue valueWithCGSize:size] forKey:cacheKey];
        return size;
    }
}

- (CGSize)wmg_sizeWithFont:(UIFont *)font
{
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:self];
    [s wmg_setFont:font];
    return [s wmg_size];
}

- (CGSize)wmg_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    return [self wmg_sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)wmg_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self wmg_sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode numberOfLines:0];
}

- (CGSize)wmg_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode numberOfLines:(NSInteger)numberOfLines
{
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:self];
    [s wmg_setFont:font];
    [s wmg_setAlignment:WMGTextAlignmentLeft lineBreakMode:lineBreakMode];
    return [s wmg_sizeConstrainedToSize:size numberOfLines:numberOfLines derivedLineCount:NULL baselineMetrics:WMGFontMetricsMakeFromUIFont(font)];
}

#pragma mark - Draw at Point

- (CGSize)wmg_drawAtPoint:(CGPoint)point withFont:(UIFont *)font
{
    return [self wmg_drawAtPoint:point withFont:font forWidth:WMGTextLayoutMaximumWidth lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)wmg_drawAtPoint:(CGPoint)point withFont:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    CGRect textRect = CGRectMake(point.x,point.y,width,font.lineHeight);
    return [self wmg_drawInRect:textRect withFont:font lineBreakMode:lineBreakMode];
}

#pragma mark - Draw in Rect

- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font
{
    return [self wmg_drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    return [self wmg_drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:NSTextAlignmentLeft];
}

- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    return [self wmg_drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment inContext:UIGraphicsGetCurrentContext()];
}

- (CGSize)wmg_drawInRect:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment inContext:(CGContextRef)context
{
    return [self wmg_drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment numberOfLines:0 inContext:context];
}

- (CGSize)wmg_drawInRect:(CGRect)rect
                 withFont:(UIFont *)font
            lineBreakMode:(NSLineBreakMode)lineBreakMode
                alignment:(NSTextAlignment)alignment
            numberOfLines:(NSInteger)numberOfLines
                inContext:(CGContextRef)context
{
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:self];
    [s addAttribute:(NSString *)kCTForegroundColorFromContextAttributeName
              value:(id)[NSNumber numberWithBool:YES]
              range:NSMakeRange(0, [self length])];
    [s addAttribute:(NSString *)kCTParagraphStyleAttributeName
              value:[self paragraphStyleWithLineBreakMode:lineBreakMode textAlignment:alignment lineHeight:rect.size.height]
              range:NSMakeRange(0, [self length])];
    [s wmg_setFont:font];
    return [s wmg_drawInRect:rect numberOfLines:numberOfLines baselineMetrics:WMGFontMetricsMakeFromUIFont(font) context:context];
}

- (CGSize)wmg_drawInRect:(CGRect)rect
                 withFont:(UIFont *)font
            lineBreakMode:(NSLineBreakMode)lineBreakMode
                alignment:(NSTextAlignment)alignment
            numberOfLines:(NSInteger)numberOfLines
                inContext:(CGContextRef)context
               textDrawer:(WMGTextDrawer *)textDrawer
{
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:self];
    [s addAttribute:(NSString *)kCTForegroundColorFromContextAttributeName
              value:(id)[NSNumber numberWithBool:YES]
              range:NSMakeRange(0, [self length])];
    [s addAttribute:(NSString *)kCTParagraphStyleAttributeName
              value:[self paragraphStyleWithLineBreakMode:lineBreakMode textAlignment:alignment lineHeight:rect.size.height]
              range:NSMakeRange(0, [self length])];
    [s wmg_setFont:font];
    return [s wmg_drawInRect:rect numberOfLines:numberOfLines baselineMetrics:WMGFontMetricsMakeFromUIFont(font) context:context textDrawer:textDrawer];
}

#pragma mark - Size Based Drawing

- (void)wmg_drawWithWidth:(CGFloat)width font:(UIFont *)font frameBlock:(WMGTextDrawingFrameBlock)frameBlock
{
    [self wmg_drawWithWidth:width font:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentLeft numberOfLines:0 context:UIGraphicsGetCurrentContext() frameBlock:frameBlock];
}

- (void)wmg_drawWithWidth:(CGFloat)width
                      font:(UIFont *)font
             lineBreakMode:(NSLineBreakMode)lineBreakMode
                 alignment:(NSTextAlignment)alignment
             numberOfLines:(NSInteger)numberOfLines
                   context:(CGContextRef)context
                frameBlock:(WMGTextDrawingFrameBlock)frameBlock
{
    NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:self];
    [s addAttribute:(NSString *)kCTForegroundColorFromContextAttributeName
              value:(id)[NSNumber numberWithBool:YES]
              range:NSMakeRange(0, [self length])];
    [s addAttribute:(NSString *)kCTParagraphStyleAttributeName
              value:[self paragraphStyleWithLineBreakMode:lineBreakMode textAlignment:alignment lineHeight:font.lineHeight]
              range:NSMakeRange(0, [self length])];
    [s wmg_setFont:font];
    
    [s wmg_drawWithWidth:width numberOfLines:numberOfLines context:context frameBlock:frameBlock];
}

- (id)paragraphStyleWithLineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment lineHeight:(CGFloat)lineHeight
{
    CGFloat maxLineHeight = lineHeight;
    
    CTParagraphStyleSetting settings[] = {
        kCTParagraphStyleSpecifierLineBreakMode, sizeof(CTLineBreakMode), &lineBreakMode,
        kCTParagraphStyleSpecifierAlignment    , sizeof(CTTextAlignment), &textAlignment,
        kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maxLineHeight,
    };
    CTParagraphStyleRef defaultParagraphStyle = CTParagraphStyleCreate(settings, 3);
    return (__bridge_transfer id)(defaultParagraphStyle);
}

@end
