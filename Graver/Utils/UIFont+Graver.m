//
//  UIFont+Graver.m
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
    

#import "UIFont+Graver.h"

static CTFontDescriptorRef arialUniDescFallback = nil;
static CTFontDescriptorRef emojiDescFallback = nil;
static CTFontDescriptorRef dingbatsDescFallback = nil;
static CTFontDescriptorRef chineseDescFallback = nil;
static CTFontDescriptorRef lastResortDescFallback = nil;

static NSDictionary *cachedFontDescriptors = nil;
static NSString *systemFontName = nil;

@implementation UIFont (Graver)

+ (CTFontRef)wmg_newSystemCTFontOfSize:(CGFloat)fontSize
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return CTFontCreateUIFontForLanguage(kCTFontSystemFontType, fontSize, NULL);
#pragma clang diagnostic pop
}

+ (CTFontRef)wmg_newBoldSystemCTFontOfSize:(CGFloat)fontSize
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return CTFontCreateUIFontForLanguage(kCTFontEmphasizedSystemFontType, fontSize, NULL);
#pragma clang diagnostic pop
}

+ (CTFontRef)wmg_newCTFontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    @synchronized(self) {
        if (!cachedFontDescriptors)
        {
            [self wmg_createFontDescriptors];
        }
    }
    
    CTFontDescriptorRef desc = (CTFontDescriptorRef)CFBridgingRetain([cachedFontDescriptors objectForKey:fontName]);
    if(!desc)
    {
        desc = [self wmg_newFontDescriptorForName:fontName];
    }
    else
    {
        CFRetain(desc);
    }
    
    CTFontRef font = CTFontCreateWithFontDescriptor((CTFontDescriptorRef)desc, fontSize, NULL);
    
    CFRelease(desc);
    
    // 调用方负责内存释放，此处静态分析ignore
    return font;
}

+ (CTFontRef)wmg_newBoldCTFontForCTFont:(CTFontRef)ctFont
{
    return [self wmg_newCTFontWithCTFont:ctFont symbolicTraits:kCTFontBoldTrait];
}

+ (CTFontRef)wmg_newItalicCTFontForCTFont:(CTFontRef)ctFont
{
    return [self wmg_newCTFontWithCTFont:ctFont symbolicTraits:kCTFontItalicTrait];
}

+ (CTFontRef)wmg_newCTFontWithCTFont:(CTFontRef)ctFont symbolicTraits:(CTFontSymbolicTraits)symbolicTraits
{
    if (!ctFont) return NULL;
    if (!symbolicTraits) return CFRetain(ctFont);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    if ((symbolicTraits & kCTFontItalicTrait) != 0)
    {
        // 由于字体fallback的原因，直接使用 italicTrait 无法将中文变为斜体
        symbolicTraits &= ~kCTFontItalicTrait;
        
        // 使用 transform 来实现倾斜效果, c = [0, 1]
        transform.c = 0.22;
    }
    
    return CTFontCreateCopyWithSymbolicTraits(ctFont, CTFontGetSize(ctFont), &transform, symbolicTraits, symbolicTraits);
}

+ (UIFont *)wmg_fontWithCTFont:(CTFontRef)CTFont
{
    NSString *fontName = (NSString *)CFBridgingRelease(CTFontCopyName(CTFont, kCTFontPostScriptNameKey));
    CGFloat fontSize = CTFontGetSize(CTFont);
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (NSString *)wmg_systemFontName
{
    if (systemFontName == nil) {
        systemFontName = [[UIFont systemFontOfSize:12] fontName];
    }
    return systemFontName;
}

#pragma mark

+ (void)wmg_createFontDescriptors
{
    if (arialUniDescFallback)
    {
        CFRelease(arialUniDescFallback);
        arialUniDescFallback = NULL;
    }
    
    if (emojiDescFallback)
    {
        CFRelease(emojiDescFallback);
        emojiDescFallback = NULL;
    }
    
    if (dingbatsDescFallback)
    {
        CFRelease(dingbatsDescFallback);
        dingbatsDescFallback = NULL;
    }
    
    if (chineseDescFallback)
    {
        CFRelease(chineseDescFallback);
        chineseDescFallback = NULL;
    }
    
    if (lastResortDescFallback)
    {
        CFRelease(lastResortDescFallback);
        lastResortDescFallback = NULL;
    }
    
    cachedFontDescriptors = nil;
    
    // Unicode特殊字符 fallback
    CFDictionaryRef arialAttrs = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"ArialMT", kCTFontNameAttribute,
                                                            nil];
    arialUniDescFallback = CTFontDescriptorCreateWithAttributes(arialAttrs);

    // Emoji字符 fallback
    CFDictionaryRef emojiAttrs = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"AppleColorEmoji", kCTFontNameAttribute,
                                                            nil];
    emojiDescFallback = CTFontDescriptorCreateWithAttributes(emojiAttrs);

    NSRange range = NSMakeRange(0x2700, 0x27BF - 0x2700 + 1);
    NSMutableCharacterSet *dingbatsSet = [NSMutableCharacterSet characterSetWithRange:range];
    
    CFDictionaryRef dingBatsAttrs = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                       @"ZapfDingbatsITC", kCTFontNameAttribute,
                                                       dingbatsSet, kCTFontCharacterSetAttribute,
                                                       nil];
    dingbatsDescFallback = CTFontDescriptorCreateWithAttributes(dingBatsAttrs);

    if ([[UIDevice currentDevice] systemVersion].intValue >= 9 )
    {
        CFDictionaryRef pingfangAttrs = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"PingFangSC-Regular", kCTFontNameAttribute,
                                                           nil];
        chineseDescFallback = CTFontDescriptorCreateWithAttributes(pingfangAttrs);
    }
    else
    {
        // 中文字符fallback
        NSRange range = NSMakeRange(0x4E00, 0x9FA5 - 0x4E00 + 1);
        NSMutableCharacterSet * chineseCharacterSet = [NSMutableCharacterSet characterSetWithRange:range];
        
        [chineseCharacterSet addCharactersInRange:NSMakeRange(0x3000, 0x303F - 0x3000 + 1)];
        [chineseCharacterSet addCharactersInRange:NSMakeRange(0xFF00, 0xFFEF - 0xFF00 + 1)];
        CFDictionaryRef heitiAttrs = (__bridge CFDictionaryRef)[NSDictionary dictionaryWithObjectsAndKeys:
                                                           @"STHeitiSC-Light", kCTFontNameAttribute,
                                                           chineseCharacterSet, kCTFontCharacterSetAttribute,
                                                           nil];
        chineseDescFallback = CTFontDescriptorCreateWithAttributes(heitiAttrs);
    }
    
    // 以上fallback未包含的字符，显示为"[?]"
    lastResortDescFallback = CTFontDescriptorCreateWithNameAndSize(CFSTR("LastResort"), 0);
    
    if ([[UIDevice currentDevice] systemVersion].intValue >= 9)
    {
        CTFontDescriptorRef D_SF = [self wmg_newFontDescriptorForName:[self wmg_systemFontName]];
        
        cachedFontDescriptors = [NSDictionary dictionaryWithObjectsAndKeys:
                                 (__bridge id)D_SF, [self wmg_systemFontName],
                                 nil];
        
        CFRelease(D_SF);
    }
    else
    {
        CTFontDescriptorRef D_HelveticaNeue = [self wmg_newFontDescriptorForName:@"HelveticaNeue"];
        
        cachedFontDescriptors = [NSDictionary dictionaryWithObjectsAndKeys:
                                 (__bridge id)D_HelveticaNeue, @"HelveticaNeue",
                                 nil];
        
        CFRelease(D_HelveticaNeue);
    }
}

+ (CTFontDescriptorRef)wmg_newFontDescriptorForName:(NSString *)name
{
    NSArray *cascadeList = @[
                             (__bridge id)emojiDescFallback,          // Emoji
                             (__bridge id)dingbatsDescFallback,       // Dingbats
                             (__bridge id)chineseDescFallback,        // Chinese
                             (__bridge id)arialUniDescFallback,       // Arial
                             ];
    /**
     *   对于以上cascadeList中的字体未包含的Unicode字符，
     *   CoreText会查找系统预设字体列表，若恰好某个包括粗体中文
     *   字形的字体也包含此特殊字符，可能导致此字符之后的中文变成粗体
     */
    
    NSDictionary * attrs = @{
                             (NSString *)kCTFontNameAttribute :          name,
                             (NSString *)kCTFontCascadeListAttribute :   cascadeList,
                             };
    
    return CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attrs);
}

@end
