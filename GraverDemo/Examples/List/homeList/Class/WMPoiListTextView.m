//
//  WMPoiListTextView.m
//  WMCoreText
//
//  Created by yan on 2018/11/26.
//  Copyright © 2018年 sankuai. All rights reserved.
//

#import "WMPoiListTextView.h"
#import <NSAttributedString+GCalculateAndDraw.h>
#import <WMGImage.h>
#import <WMGTextDrawer.h>
#import <WMGTextLayout.h>
#import <WMGTextAttachment.h>
#import <WMGraverMacroDefine.h>

@interface WMPoiListTextView ()<WMGTextDrawerDelegate,WMGTextLayoutDelegate>

@property (nonatomic, strong) NSRecursiveLock *lock;
@property (nonatomic, strong) NSMutableArray <WMGTextAttachment *> *arrayAttachments;
@property (nonatomic, strong) WMGTextDrawer *textDrawer;

@end

@implementation WMPoiListTextView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _textDrawer = [[WMGTextDrawer alloc] init];
        _textDrawer.delegate = self;
        _textDrawer.textLayout.delegate = self;
        
        _lock = [[NSRecursiveLock alloc] init];
        _arrayAttachments = [NSMutableArray array];
        _drawerDates = [NSMutableArray array];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    if (!CGRectEqualToRect(frame, self.frame))
    {
        [super setFrame:frame];
        [self setNeedsDisplayAsync];
    }
}


- (void)setDrawerDates:(NSArray<WMGVisionObject *> *)drawerDates {
    if (_drawerDates != drawerDates) {
        _drawerDates = drawerDates;
        [self setNeedsDisplayAsync];
    }
}


- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
{
    [super drawInRect:rect withContext:context asynchronously:asynchronously userInfo:userInfo];
    
    NSUInteger initialDrawingCount = self.drawingCount;
    if (self.drawerDates.count <= 0) {
        return YES;
    }
    
    [self.drawerDates enumerateObjectsUsingBlock:^(WMGVisionObject * _Nonnull drawerData, NSUInteger idx, BOOL * _Nonnull stop) {
        self.textDrawer.frame = drawerData.frame;
        self.textDrawer.textLayout.attributedString = drawerData.value;
        CGRect visibleRect = CGRectNull;
        [self.textDrawer drawInContext:context visibleRect:visibleRect replaceAttachments:YES shouldInterruptBlock:^BOOL{
            return initialDrawingCount != self.drawingCount ? YES : NO;
        }];
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
                WMGImage *ctImage = (WMGImage *)att.contents;
                if ([ctImage isKindOfClass:[WMGImage class]]) {
                    
                    // TODO: 图片下载流程
                    __weak typeof(self)weakSelf = self;
                    [ctImage wmg_loadImageWithUrl:ctImage.downloadUrl options:0 progress:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        __strong typeof(weakSelf) strongSelf = weakSelf;
                        [strongSelf.lock lock];
                        if ([strongSelf.arrayAttachments containsObject:att]) {
                            [strongSelf.arrayAttachments removeObject:att];
                            i--;
                            [strongSelf setNeedsDisplay];
                        }
                        [strongSelf.lock unlock];
                    }];
                }
            }
        }
    }
    [_lock unlock];
}

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
            WMGImage *ctImage = (WMGImage *)att.contents;
            
            if (ctImage.image) {
                UIGraphicsPushContext(context);
                [ctImage.image drawInRect:frame];
                UIGraphicsPopContext();
            }
            else
            {
                if (!IsStrEmpty(ctImage.placeholderName)) {
                    UIGraphicsPushContext(context);
                    UIImage *image = [UIImage imageNamed:ctImage.placeholderName];
                    [image drawInRect:frame];
                    UIGraphicsPopContext();
                }
            }
            
            if (!IsStrEmpty(ctImage.downloadUrl))
            {
                att.layoutFrame = frame;
                [_lock lock];
                [_arrayAttachments addObject:att];
                [_lock unlock];
            }
        }
    }
}

#pragma mark - WMGTextLayoutDelegate

- (CGFloat)textLayout:(WMGTextLayout *)textLayout maximumWidthForTruncatedLine:(CTLineRef)lineRef atIndex:(NSUInteger)index {
    return WMGTextLayoutMaximumWidth;
}

@end
