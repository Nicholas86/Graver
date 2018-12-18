//
//  WMGTextLayoutRun.m
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
    

#import "WMGTextLayoutRun.h"
#import "WMGAttachment.h"

@implementation WMGTextLayoutRun

+ (CTRunDelegateRef)textLayoutRunWithAttachment:(id<WMGAttachment>)att
{
    CTRunDelegateCallbacks callbacks;
    callbacks.version = kCTRunDelegateCurrentVersion;
    callbacks.dealloc = wmg_embeddedObjectDeallocCallback;
    callbacks.getAscent = wmg_embeddedObjectGetAscentCallback;
    callbacks.getDescent = wmg_embeddedObjectGetDescentCallback;
    callbacks.getWidth = wmg_embeddedObjectGetWidthCallback;
    return CTRunDelegateCreate(&callbacks, (void *)CFBridgingRetain(att));
}

void wmg_embeddedObjectDeallocCallback(void* context)
{
    CFBridgingRelease(context);
}

CGFloat wmg_embeddedObjectGetAscentCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachment)])
    {
        return [(__bridge id <WMGAttachment>)context baselineFontMetrics].ascent;
    }
    return 20;
}

CGFloat wmg_embeddedObjectGetDescentCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachment)])
    {
        return [(__bridge id <WMGAttachment>)context baselineFontMetrics].descent;
    }
    return 5;
}

CGFloat wmg_embeddedObjectGetWidthCallback(void* context)
{
    if ([(__bridge id)context conformsToProtocol:@protocol(WMGAttachment)])
    {
        return [(__bridge id <WMGAttachment>)context placeholderSize].width;
    }
    return 25;
}

@end
