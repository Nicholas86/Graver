//
//  WMGMixedView.m
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
    

#import "WMGMixedView.h"
#import "WMGTextDrawer.h"
#import "WMGTextDrawer+Event.h"
#import "WMGTextDrawer+Private.h"
#import "WMGTextLayout.h"
#import "WMGTextLayoutFrame.h"
#import "WMGImage.h"
#import "WMGActiveRange.h"
#import "WMGTextActiveRange.h"

#import "WMGAttachment.h"
#import "WMGTextAttachment.h"
#import "WMGTextAttachment+Event.h"
#import "WMGraverMacroDefine.h"

NSString * const WMGMixedViewAttributedItemKey  = @"waimai-graver-mixedview-attributeditem-key";
NSString * const WMGMixedViewTextHorizontalAlignmentKey = @"waimai-graver-mixedview-horizontalalignment-key";
NSString * const WMGMixedViewTextVerticalAlignmentKey = @"waimai-graver-mixedview-verticalalignment-key";

@interface WMGMixedView ()<WMGTextDrawerDelegate, WMGTextDrawerEventDelegate, WMGTextLayoutDelegate>
{
    BOOL _pendingAttachmentUpdates;
}
@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) WMGTextDrawer *textDrawer;
@property (nonatomic, strong) NSMutableArray <WMGTextAttachment *> *arrayAttachments;
@end


@implementation WMGMixedView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _textDrawer = [[WMGTextDrawer alloc] init];
        _textDrawer.delegate = self;
        _textDrawer.eventDelegate = self;
        
        _lock = [[NSRecursiveLock alloc] init];
        _arrayAttachments = [NSMutableArray array];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, self.frame))
    {
        [super setFrame:frame];
        
        [self setNeedsDisplayAsync];
        
        _pendingAttachmentUpdates = YES;
    }
}

- (void)setHorizontalAlignment:(WMGTextHorizontalAlignment)horizontalAlignment
{
    if (_horizontalAlignment != horizontalAlignment) {
        _horizontalAlignment = horizontalAlignment;
        [self setNeedsDisplayAsync];
    }
}

- (void)setVerticalAlignment:(WMGTextVerticalAlignment)verticalAlignment
{
    if (_verticalAlignment != verticalAlignment) {
        _verticalAlignment = verticalAlignment;
        [self setNeedsDisplayAsync];
    }
}

- (void)setAttributedItem:(WMMutableAttributedItem *)attributedItem
{
    if (_attributedItem != attributedItem)
    {
        _attributedItem = attributedItem;
        
        [self setNeedsDisplayAsync];
        
        _pendingAttachmentUpdates = YES;
    }
}

- (void)setNumerOfLines:(NSUInteger)numerOfLines
{
    if (_textDrawer.textLayout.maximumNumberOfLines != numerOfLines) {
        _textDrawer.textLayout.maximumNumberOfLines = numerOfLines;
        _pendingAttachmentUpdates = YES;
        [self setNeedsDisplay];
    }
}

#pragma mark - Drawing

- (NSDictionary *)currentDrawingUserInfo
{
    NSDictionary *dic = [super currentDrawingUserInfo];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    if (dic) {
        [userInfo addEntriesFromDictionary:dic];
    }
    
    if (_attributedItem.resultString)
    {
        [userInfo setValue:_attributedItem.resultString forKey:WMGMixedViewAttributedItemKey];
    }
    
    [userInfo setValue:@(_horizontalAlignment) forKey:WMGMixedViewTextHorizontalAlignmentKey];
    [userInfo setValue:@(_verticalAlignment) forKey:WMGMixedViewTextVerticalAlignmentKey];
    
    return userInfo;
}

- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
{
    [super drawInRect:rect withContext:context asynchronously:asynchronously userInfo:userInfo];
    
    NSUInteger initialDrawingCount = self.drawingCount;
    
    NSAttributedString *attributedString = userInfo[WMGMixedViewAttributedItemKey];
    
    if (!attributedString) return YES;
    
    _textDrawer.frame = rect;
    _textDrawer.textLayout.attributedString = attributedString;
    
    WMGTextLayoutFrame *layoutFrame = [_textDrawer.textLayout layoutFrame];
    CGSize layoutSize = [layoutFrame layoutSize];
    
    WMGTextHorizontalAlignment horizontalAlignment = [userInfo[WMGMixedViewTextHorizontalAlignmentKey] unsignedIntegerValue];
    WMGTextVerticalAlignment verticalAlignment = [userInfo[WMGMixedViewTextVerticalAlignmentKey] unsignedIntegerValue];
    
    if (horizontalAlignment == WMGTextHorizontalAlignmentRight) {
        CGPoint point = _textDrawer.drawOrigin;
        point.x = rect.size.width - layoutSize.width;
        _textDrawer.drawOrigin = point;
    }
    else if (horizontalAlignment == WMGTextHorizontalAlignmentCenter){
        CGPoint point = _textDrawer.drawOrigin;
        point.x = (rect.size.width - layoutSize.width) / 2;
        _textDrawer.drawOrigin = point;
    }
    
    if (verticalAlignment == WMGTextVerticalAlignmentBottom) {
        CGPoint point = _textDrawer.drawOrigin;
        point.y = rect.size.height - layoutSize.height;
        _textDrawer.drawOrigin = point;
    }
    else if (verticalAlignment == WMGTextVerticalAlignmentCenter){
        CGPoint point = _textDrawer.drawOrigin;
        point.y = (rect.size.height - layoutSize.height) / 2;
        _textDrawer.drawOrigin = point;
    }
    else if (verticalAlignment == WMGTextVerticalAlignmentCenterCompatibility){
        CGFloat offset = 1;
        CGPoint point = _textDrawer.drawOrigin;
        point.y = (rect.size.height - layoutSize.height) / 2;
        point.y -= offset;
        _textDrawer.drawOrigin = point;
    }
    
    CGRect visibleRect = CGRectNull;
    
    [_textDrawer drawInContext:context visibleRect:visibleRect replaceAttachments:_pendingAttachmentUpdates shouldInterruptBlock:^BOOL{
        if (initialDrawingCount != self.drawingCount)
        {
            WMGLog(@"<WMGTextDrawer> Interrupted");
            return YES;
        }
        return NO;
    }];
    
    return YES;
}

- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success
{
    if (!success) {
        return;
    }
    
    [_lock lock];
    // 三个点： 锁重入、for循环遍历移除元素、多线程同步访问共享数据区
    for (__block int i = 0; i < _arrayAttachments.count; i++) {
        if (i >= 0) {
            WMGTextAttachment *att = [_arrayAttachments objectAtIndex:i];
            
            if (att.type == WMGAttachmentTypeStaticImage){
                WMGImage *gImage = (WMGImage *)att.contents;
                if ([gImage isKindOfClass:[WMGImage class]]) {
                    
//                    [gImage wmg_loadImageWithUrl:gImage.downloadUrl options:0 progress:NULL completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//
//                        [_lock lock];
//                        if ([_arrayAttachments containsObject:att]) {
//                            [_arrayAttachments removeObject:att];
//                            i--;
//                            [self setNeedsDisplay];
//                        }
//                        [_lock unlock];
//                    }];
                }
            }
        }
    }
    [_lock unlock];
}

#pragma mark - Event Handling

- (BOOL)shouldDisableGestureRecognizerInLocation:(CGPoint)location
{
    for (WMGTextAttachment *att in _attributedItem.arrayAttachments) {
        if (att.type == WMGAttachmentTypeStaticImage && [att responseEvent]) {
            if (CGRectContainsPoint(att.layoutFrame, location)) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textDrawer touchesBegan:touches withEvent:event];
    
    if (!_textDrawer.pressingActiveRange)
    {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textDrawer touchesEnded:touches withEvent:event];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textDrawer touchesMoved:touches withEvent:event];
    
    if (!_textDrawer.pressingActiveRange)
    {
        [super touchesMoved:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_textDrawer touchesCancelled:touches withEvent:event];
    [super touchesCancelled:touches withEvent:event];
}

#pragma mark - WMGTextDrawerDelegate

- (void)textDrawer:(WMGTextDrawer *)textDrawer replaceAttachment:(WMGTextAttachment *)att frame:(CGRect)frame context:(CGContextRef)context
{
    if (att.type == WMGAttachmentTypeStaticImage)
    {
        if ([att.contents isKindOfClass:[NSString class]]) {
            UIGraphicsPushContext(context);
            UIImage *image = [UIImage imageNamed:(NSString *)att.contents];
            [image drawInRect:frame];
            UIGraphicsPopContext();
        }
        else if ([att.contents isKindOfClass:[UIImage class]]) {
            UIGraphicsPushContext(context);
            [(UIImage *)att.contents drawInRect:frame];
            UIGraphicsPopContext();
        }
        else if ([att.contents isKindOfClass:[WMGImage class]]){
            WMGImage *gImage = (WMGImage *)att.contents;
            
            if (gImage.image) {
                UIGraphicsPushContext(context);
                [gImage.image drawInRect:frame];
                UIGraphicsPopContext();
            }
            else
            {
                if (!IsStrEmpty(gImage.placeholderName)) {
                    UIGraphicsPushContext(context);
                    UIImage *image = [UIImage imageNamed:gImage.placeholderName];
                    [image drawInRect:frame];
                    UIGraphicsPopContext();
                }
            }
            
            if (!IsStrEmpty(gImage.downloadUrl))
            {
                att.layoutFrame = frame;
                [_lock lock];
                [_arrayAttachments addObject:att];
                [_lock unlock];
            }
        }
    }
}

#pragma mark - WMGTextDrawerEventDelegate

- (UIView *)contextViewForTextDrawer:(WMGTextDrawer *)textDrawer
{
    return self;
}

- (NSArray *)activeRangesForTextDrawer:(WMGTextDrawer *)textDrawer
{
    NSMutableArray *arrayActiveRanges = [NSMutableArray array];
    for (WMGTextAttachment *att in _attributedItem.arrayAttachments) {
        WMGTextActiveRange *range = [WMGTextActiveRange activeRange:NSMakeRange(att.position, att.length) type:WMGActiveRangeTypeAttachment text:@""];
        range.bindingData = att;
        [arrayActiveRanges addObject:range];
    }
    
    return arrayActiveRanges;
}

- (void)textDrawer:(WMGTextDrawer *)textDrawer didPressActiveRange:(id<WMGActiveRange>)activeRange
{
    if (activeRange.type == WMGActiveRangeTypeAttachment) {
        WMGTextAttachment *att = (WMGTextAttachment *)activeRange.bindingData;
        [att handleEvent:self];
    }
}

- (BOOL)textDrawer:(WMGTextDrawer *)textDrawer shouldInteractWithActiveRange:(id<WMGActiveRange>)activeRange
{
    return YES;
}

#pragma mark - WMGTextLayoutDelegate

- (CGFloat)textLayout:(WMGTextLayout *)textLayout maximumWidthForTruncatedLine:(CTLineRef)lineRef atIndex:(NSUInteger)index
{
    return WMGTextLayoutMaximumWidth;
}

@end
