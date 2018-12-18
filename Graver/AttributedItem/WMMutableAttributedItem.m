//
//  WMMutableAttributedItem.m
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
    

#import "WMMutableAttributedItem.h"
#import "UIImage+Graver.h"
#import "WMGImage.h"
#import "WMGTextAttachment+Event.h"
#import "WMGraverMacroDefine.h"

@interface WMMutableAttributedItem ()
{
    struct {
        unsigned int needsRebuild:1;
    } _flags;
    
    NSMutableAttributedString *_textStorage;
}
@property (nonatomic, strong, readwrite) NSMutableAttributedString *resultString;
@property (nonatomic, strong, readwrite) NSMutableArray <WMGTextAttachment *> *arrayAttachments;

@end

@implementation WMMutableAttributedItem

+ (instancetype)itemWithText:(NSString *)text
{
    WMMutableAttributedItem *t = [[WMMutableAttributedItem alloc] initWithText:text];
    return t;
}

+ (instancetype)itemWithImageName:(NSString *)imgname{
    return [WMMutableAttributedItem itemWithImageName:imgname size:CGSizeMake(15, 15)];
}

+ (instancetype)itemWithImageName:(NSString *)imgname size:(CGSize)size
{
    WMMutableAttributedItem *text = [WMMutableAttributedItem itemWithText:nil];
    [text appendImageWithName:imgname size:size];
    return text;
}

- (id)initWithText:(NSString *)text
{
    self = [super init];
    if (self) {
        _textStorage = [[NSMutableAttributedString alloc] initWithString:!IsStrEmpty(text) ? text : @""];
        [_textStorage wmg_setFont:[UIFont systemFontOfSize:11]];
        [_textStorage wmg_setColor:WMGHEXCOLOR(0x666666)];
        
        _resultString = nil;
        _arrayAttachments = [NSMutableArray array];
        
        _flags.needsRebuild = YES;
    }
    return self;
}

- (NSAttributedString *)resultString
{
    [self rebuildIfNeeded];
    return _resultString;
}

- (NSArray <WMGTextAttachment *> *)arrayAttachments
{
    return _arrayAttachments;
}

- (WMMutableAttributedItem *)appendText:(NSString *)text
{
    WMMutableAttributedItem *item = [WMMutableAttributedItem itemWithText:text];
    return [self appendAttributedItem:item];
}

- (WMMutableAttributedItem *)appendAttributedItem:(WMMutableAttributedItem *)item
{
    if (item && item.resultString) {
        
        for (WMGTextAttachment *att in item.arrayAttachments) {
            att.position += _textStorage.length;
            [_arrayAttachments addObject:att];
        }
        
        [_textStorage appendAttributedString:item.resultString];
        [self setNeedsRebuild];
    }
    
    return self;
}

- (WMMutableAttributedItem *)appendSeparatorLine
{
    return [self appendSeparatorLineWithColor:WMGHEXCOLOR(0xc4c4c4)];
}

- (WMMutableAttributedItem *)appendSeparatorLineWithColor:(UIColor *)lineColor
{
    UIImage *image = [UIImage wmg_imageWithColor:lineColor size:CGSizeMake(1, 7)];
    WMGTextAttachment *att = [WMGTextAttachment textAttachmentWithContents:image type:WMGAttachmentTypeStaticImage size:CGSizeMake(0.5, 7)];
    att.retriveFontMetricsAutomatically = NO;
    UIFont *font = [UIFont systemFontOfSize:11];
    att.baselineFontMetrics = WMGFontMetricsMakeFromUIFont(font);
    
    CGFloat lineHeight = WMGFontMetricsGetLineHeight(att.baselineFontMetrics);
    CGFloat inset = (lineHeight - 7) / 2;
    att.edgeInsets = UIEdgeInsetsMake(inset - 1, 3, inset - 1, 3);
    
    return [self appendAttachment:att];
}

- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl
{
    return [self appendImageWithUrl:imgUrl size:CGSizeMake(11, 11)];
}

- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl size:(CGSize)size
{
    if (IsStrEmpty(imgUrl)) {
        return self;
    }
    
    WMGImage *image = [WMGImage imageWithUrl:imgUrl];
    image.size = size;
    
    WMGTextAttachment *att = [WMGTextAttachment textAttachmentWithContents:image type:WMGAttachmentTypeStaticImage size:size];
    
    return [self appendAttachment:att];
}

- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl placeholder:(NSString *)placeholder
{
    return [self appendImageWithUrl:imgUrl size:CGSizeMake(11, 11) placeholder:placeholder];
}

- (WMMutableAttributedItem *)appendImageWithUrl:(NSString *)imgUrl size:(CGSize)size placeholder:(NSString *)placeholder
{
    if (IsStrEmpty(imgUrl) && IsStrEmpty(placeholder)) {
        return self;
    }
    
    WMGImage *image = [[WMGImage alloc] init];
    image.downloadUrl = imgUrl;
    image.image = [UIImage imageNamed:placeholder];
    image.size = size;
    
    WMGTextAttachment *att = [WMGTextAttachment textAttachmentWithContents:image type:WMGAttachmentTypeStaticImage size:size];
    
    return [self appendAttachment:att];
}

- (WMMutableAttributedItem *)appendImageWithName:(NSString *)imgname
{
    return [self appendImageWithName:imgname size:CGSizeMake(15, 15)];
}

- (WMMutableAttributedItem *)appendImageWithName:(NSString *)imgname size:(CGSize)size
{
    UIImage *image = [UIImage imageNamed:imgname];
    return [self appendImageWithImage:image size:size];
}

- (WMMutableAttributedItem *)appendImageWithImage:(UIImage *)image
{
    return [self appendImageWithImage:image size:image.size];
}

- (WMMutableAttributedItem *)appendImageWithImage:(UIImage *)image size:(CGSize)size
{
    WMGTextAttachment *att = [WMGTextAttachment textAttachmentWithContents:image type:WMGAttachmentTypeStaticImage size:size];
    
    return [self appendAttachment:att];
}

- (WMMutableAttributedItem *)appendWhiteSpaceWithWidth:(CGFloat)width
{
    WMGTextAttachment *att = [WMGTextAttachment textAttachmentWithContents:nil type:WMGAttachmentTypePlaceholder size:CGSizeMake(width, 1)];
    
    return [self appendAttachment:att];
}

- (WMMutableAttributedItem *)appendAttachment:(WMGTextAttachment *)att
{
    if (att.type == WMGAttachmentTypeStaticImage ||
        att.type == WMGAttachmentTypePlaceholder) {
        att.position = _textStorage.length;
        att.length = 1;
    }
    
    [self setNeedsRebuild];
    NSAttributedString *str = [NSAttributedString wmg_attributedStringWithTextAttachment:att];
    [_textStorage appendAttributedString:str];
    [_arrayAttachments addObject:att];
    return self;
}

- (void)setNeedsRebuild
{
    _flags.needsRebuild = YES;
}

- (void)rebuildIfNeeded
{
    if (_flags.needsRebuild) {
        [self _rebuild];
    }
}

- (void)_rebuild
{
    _flags.needsRebuild = NO;
    
    if (_textStorage.length > 0 && !IsStrEmpty(_textStorage.string))
    {
        NSMutableAttributedString *s = [[NSMutableAttributedString alloc] initWithString:_textStorage.string];
        
        // 直接设置的字体、颜色、下划线样式
        for (NSString * key in @[(NSString *)kCTFontAttributeName,
                                 (NSString *)kCTForegroundColorAttributeName,
                                 /*(NSString *)kCTBackgroundColorAttributeName,*/
                                 (NSString *)kCTParagraphStyleAttributeName,
                                 (NSString *)kCTKernAttributeName,
                                 (NSString *)kCTUnderlineStyleAttributeName,
                                 (NSString *)kCTUnderlineColorAttributeName,
                                 (NSString *)kCTLigatureAttributeName,
                                 (NSString *)NSStrikethroughStyleAttributeName,
                                 (NSString *)NSStrikethroughColorAttributeName,
                                 (NSString *)kCTRunDelegateAttributeName,
                                 WMGTextAttachmentAttributeName,
                                 WMGTextDefaultForegroundColorAttributeName,
                                 WMGTextStrikethroughStyleAttributeName,
                                 WMGTextStrikethroughColorAttributeName
                                 ])
        {
            [_textStorage enumerateAttribute:key inRange:NSMakeRange(0, _textStorage.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
                if (value && (range.location != NSNotFound))
                {
                    [s addAttribute:key value:value range:range];
                }
            }];
        }
        
        [s enumerateAttribute:WMGTextAttachmentAttributeName inRange:NSMakeRange(0, s.length) options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            
            if (value && [value isKindOfClass:[WMGTextAttachment class]]) {
                WMGTextAttachment *att = (WMGTextAttachment *)value;
                if (att.retriveFontMetricsAutomatically &&
                    WMGFontMetricsEqual(att.baselineFontMetrics, WMGFontMetricsZero)) {
                    
                    __block WMGFontMetrics earlyMetrics = WMGFontMetricsZero;
                    
                    // 先找前面，再找后面
                    if (range.location > 0 && range.location != NSNotFound) {
                        
                        //前面
                        [s enumerateAttribute:(NSString *)kCTFontAttributeName inRange:NSMakeRange(0, range.location - 1) options:NSAttributedStringEnumerationReverse usingBlock:^(id  _Nullable bValue, NSRange range, BOOL * _Nonnull stop) {
                            
                            if (bValue) {
                                CTFontRef font = (__bridge CTFontRef)bValue;
                                earlyMetrics = WMGFontMetricsMakeFromCTFont(font);
                                *stop = YES;
                            }
                        }];
                        
                        if (WMGFontMetricsEqual(earlyMetrics, WMGFontMetricsZero)) {
                            // 后面
                            [s enumerateAttribute:(NSString *)kCTFontAttributeName inRange:NSMakeRange(NSMaxRange(range), s.length - NSMaxRange(range)) options:0 usingBlock:^(id  _Nullable aValue, NSRange range, BOOL * _Nonnull stop) {
                                
                                if (aValue) {
                                    CTFontRef font = (__bridge CTFontRef)aValue;
                                    earlyMetrics = WMGFontMetricsMakeFromCTFont(font);
                                    *stop = YES;
                                }
                            }];
                            
                            if (WMGFontMetricsEqual(earlyMetrics, WMGFontMetricsZero))
                            {
                                UIFont *font = [UIFont systemFontOfSize:11];
                                earlyMetrics = WMGFontMetricsMakeFromUIFont(font);
                            }
                            att.baselineFontMetrics = earlyMetrics;
                        }
                        else
                        {
                            att.baselineFontMetrics = earlyMetrics;
                        }
                    }
                    // 直接找后面
                    else
                    {
                        // 后面
                        [s enumerateAttribute:(NSString *)kCTFontAttributeName inRange:NSMakeRange(NSMaxRange(range), s.length - NSMaxRange(range)) options:0 usingBlock:^(id  _Nullable dbValue, NSRange range, BOOL * _Nonnull stop) {
                            
                            if (dbValue) {
                                CTFontRef font = (__bridge CTFontRef)dbValue;
                                earlyMetrics = WMGFontMetricsMakeFromCTFont(font);
                                *stop = YES;
                            }
                        }];
                        
                        if (WMGFontMetricsEqual(earlyMetrics, WMGFontMetricsZero))
                        {
                            UIFont *font = [UIFont systemFontOfSize:11];
                            earlyMetrics = WMGFontMetricsMakeFromUIFont(font);
                        }
                        
                        att.baselineFontMetrics = earlyMetrics;
                    }
                }
            }
        }];
        
        _resultString = s;
    }
}

- (void)setFont:(UIFont *)font
{
    [self setNeedsRebuild];
    [_textStorage wmg_setFont:font];
}

- (void)setFontSize:(CGFloat)size fontWeight:(CGFloat)weight boldDisplay:(BOOL)boldDisplay
{
    [self setNeedsRebuild];
    [_textStorage wmg_setFontSize:size fontWeight:weight boldDisplay:boldDisplay];
}

- (void)setCTFont:(CTFontRef)ctFont
{
    [self setNeedsRebuild];
    [_textStorage wmg_setCTFont:ctFont];
}

- (void)setColor:(UIColor *)color
{
    [self setNeedsRebuild];
    [_textStorage wmg_setColor:color];
}

- (void)setAlignment:(WMGTextAlignment)alignment
{
    [self setNeedsRebuild];
    [_textStorage wmg_setAlignment:alignment];
}

- (void)setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [self setNeedsRebuild];
    [_textStorage wmg_setAlignment:alignment lineBreakMode:lineBreakMode];
}

- (void)setAlignment:(WMGTextAlignment)alignment lineBreakMode:(NSLineBreakMode)lineBreakMode lineHeight:(CGFloat)lineheight
{
    [self setNeedsRebuild];
    [_textStorage wmg_setAlignment:alignment lineBreakMode:lineBreakMode lineHeight:lineheight];
}

- (void)setKerning:(CGFloat)kern
{
    [self setNeedsRebuild];
    [_textStorage wmg_setKerning:kern];
}

- (void)setTextLigature:(WMGTextLigature)textLigature
{
    [self setNeedsRebuild];
    [_textStorage wmg_setTextLigature:textLigature];
}

- (void)setUnderlineStyle:(WMGTextUnderlineStyle)underlineStyle
{
    [self setNeedsRebuild];
    [_textStorage wmg_setUnderlineStyle:underlineStyle];
}

- (void)setStrikeThroughStyle:(WMGTextStrikeThroughStyle)strikeThroughStyle
{
    [self setNeedsRebuild];
    [_textStorage wmg_setStrikeThroughStyle:strikeThroughStyle];
}

- (void)setTextParagraphStyle:(WMGTextParagraphStyle *)paragraphStyle
{
    [self setTextParagraphStyle:paragraphStyle fontSize:11];
}

- (void)setTextParagraphStyle:(WMGTextParagraphStyle *)paragraphStyle fontSize:(CGFloat)fontSize
{
    [self setNeedsRebuild];
    [_textStorage wmg_setTextParagraphStyle:paragraphStyle fontSize:fontSize];
}

@end
