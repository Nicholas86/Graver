//
//  WMGTextAttachment.m
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
    

#import "WMGTextAttachment.h"
#import "WMGTextLayoutRun.h"
#import "WMGTextAttachment+Event.h"

NSString * const WMGTextAttachmentAttributeName = @"WMGTextAttachmentAttributeName";
NSString * const WMGTextAttachmentReplacementCharacter = @"\uFFFC";

@implementation WMGTextAttachment
@synthesize type = _type, size = _size, edgeInsets = _edgeInsets, contents = _contents, position = _position, length = _length, baselineFontMetrics = _baselineFontMetrics;

- (instancetype)init
{
    self = [super init];
    if (self) {
        _retriveFontMetricsAutomatically = YES;
        _baselineFontMetrics = WMGFontMetricsZero;
        
        _edgeInsets = UIEdgeInsetsMake(0, 1, 0, 1);
    }
    return self;
}

+ (instancetype)textAttachmentWithContents:(id)contents type:(WMGAttachmentType)type size:(CGSize)size
{
    WMGTextAttachment *att = [[WMGTextAttachment alloc] init];
    att.contents = contents;
    att.type = type;
    att.size = size;
    
    return att;
}

- (UIEdgeInsets)edgeInsets
{
    if (_retriveFontMetricsAutomatically) {
        CGFloat lineHeight = WMGFontMetricsGetLineHeight(_baselineFontMetrics);
        CGFloat inset = (lineHeight - self.size.height) / 2;
        
        return UIEdgeInsetsMake(inset, _edgeInsets.left, inset, _edgeInsets.right);
    }
    
    return _edgeInsets;
}

- (CGSize)placeholderSize
{
    return CGSizeMake(self.size.width + self.edgeInsets.left + self.edgeInsets.right, self.size.height + self.edgeInsets.top + self.edgeInsets.bottom);
}

#pragma mark - Event

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    _target = target;
    _selector = action;
    
    _responseEvent = (_target && _selector) && [_target respondsToSelector:_selector];
}

- (void)handleEvent:(id)sender
{
    if (_target && _selector) {
        if ([_target respondsToSelector:_selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_target performSelector:_selector withObject:sender];
#pragma clang diagnostic pop
        }
    }
}

@end

@implementation NSAttributedString (GTextAttachment)

- (void)wmg_enumerateTextAttachmentsWithBlock:(void (^)(WMGTextAttachment *, NSRange, BOOL *))block
{
    [self wmg_enumerateTextAttachmentsWithOptions:0 block:block];
}

- (void)wmg_enumerateTextAttachmentsWithOptions:(NSAttributedStringEnumerationOptions)options block:(void (^)(WMGTextAttachment *, NSRange, BOOL *))block
{
    if (!block) return;
    
    [self enumerateAttribute:WMGTextAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:options usingBlock:^(WMGTextAttachment * attachment, NSRange range, BOOL *stop) {
        if (attachment && [attachment isKindOfClass:[WMGTextAttachment class]]) {
            block(attachment, range, stop);
        }
    }];
}

+ (instancetype)wmg_attributedStringWithTextAttachment:(WMGTextAttachment *)attachment
{
    return [self wmg_attributedStringWithTextAttachment:attachment attributes:@{}];
}

+ (instancetype)wmg_attributedStringWithTextAttachment:(WMGTextAttachment *)attachment attributes:(NSDictionary *)attributes
{
    // Core Text 通过runDelegate确定非文字（attachment）区域的大小
    CTRunDelegateRef runDelegate = [WMGTextLayoutRun textLayoutRunWithAttachment:attachment];
    // 设置CTRunDelegateRef 和 文本颜色， 由于占位的“*”不需要显示，故设为透明色
    NSMutableDictionary *placeholderAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [placeholderAttributes addEntriesFromDictionary:[NSDictionary dictionaryWithObjectsAndKeys:(__bridge id)runDelegate, (NSString*)kCTRunDelegateAttributeName, [UIColor clearColor].CGColor,(NSString*)kCTForegroundColorAttributeName, attachment, WMGTextAttachmentAttributeName, nil]];
    CFRelease(runDelegate);
    
    // 所有表情文本（如“[哈哈]”）替换为一个占位符，并通过CTRunDelegateRef控制大小
    NSString *str = WMGTextAttachmentReplacementCharacter;
    NSAttributedString *result = [[[self class] alloc] initWithString:str attributes:placeholderAttributes];
    
    return result;
}

@end
