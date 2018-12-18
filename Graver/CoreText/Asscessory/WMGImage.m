//
//  WMGImage.m
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
    

#import "WMGImage.h"
#import "WMGraverMacroDefine.h"

@implementation WMGImage

+ (WMGImage *)imageWithNamed:(NSString *)imgname
{
    if (IsStrEmpty(imgname)) {
        return nil;
    }
    WMGImage *ctImage = [[WMGImage alloc] init];
    ctImage.placeholderName = imgname;
    
    return ctImage;
}

+ (WMGImage *)imageWithImage:(UIImage *)image
{
    if (image == nil) {
        return nil;
    }
    WMGImage *ctImage = [[WMGImage alloc] init];
    ctImage.image = image;
    
    return ctImage;
}

+ (WMGImage *)imageWithUrl:(NSString *)imgUrl
{
    if (IsStrEmpty(imgUrl)) {
        return nil;
    }
    WMGImage *ctImage = [[WMGImage alloc] init];
    ctImage.downloadUrl = imgUrl;
    
    return ctImage;
}

- (void)wmg_loadImageWithUrl:(NSString *)urlStr options:(SDWebImageOptions)options progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completion
{
    NSURL *url = [NSURL URLWithString:urlStr];
    
    if (url) {
        __weak typeof(self) wself = self;
        [[SDWebImageManager sharedManager] loadImageWithURL:url options:options progress:progressBlock completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            
            void(^block)(UIImage *, NSError *, SDImageCacheType , BOOL , NSURL *) = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL){
                wself.downloadUrl = nil;
                if (!wself) return;
                if (image) {
                    wself.image = image;
                }
                if (completion && finished) {
                    completion(image, error, cacheType, url);
                }
            };
            
            CGFloat scale = [UIScreen mainScreen].scale;
            
            CGSize imageSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
            UIViewContentMode contentMode = self.contentMode;
            
            CGFloat percent = self.blurPercent / 100.00;
            
            WMGCornerRadius radius = WMGCornerRadiusMake(self.radius.topLeft * scale, self.radius.topRight * scale, self.radius.bottomLeft * scale, self.radius.bottomRight * scale);
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 裁剪处理
                UIImage *newImage = [image wmg_cropImageWithCroppedSize:imageSize contentMode:contentMode interpolationQuality:kCGInterpolationHigh];
                
                // 模糊处理
                if (percent >= 0.01) {
                    newImage = [newImage wmg_blurImageWithBlurPercent:percent];
                }
                
                // 圆角处理
                if (!WMGCornerRadiusEqual(radius, WMGCornerRadiusZero)){
                    newImage = [newImage wmg_roundedImageWithCornerRadius:radius];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    block(newImage, error, cacheType, finished, imageURL);
                });
            });
            
        }];
    } else {
        self.downloadUrl = nil;
        NSError *error = [NSError errorWithDomain:SDWebImageErrorDomain code:-1 userInfo:@{NSLocalizedDescriptionKey : @"Trying to load a nil url"}];
        if (completion) {
            completion(nil, error, SDImageCacheTypeNone, url);
        }
    }
}

@end
