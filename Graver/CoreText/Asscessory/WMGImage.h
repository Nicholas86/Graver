//
//  WMGImage.h
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
    

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIImage+Graver.h"
#import <SDWebImage/SDWebImageManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMGImage : NSObject

// 网络图片的下载URL string
@property (nonatomic, copy, nullable) NSString *downloadUrl;

// 本地占位图片名字
@property (nonatomic, copy) NSString *placeholderName;

// 肯能是最终展示的本地图片、可能是展示的placeholder图片、也可能是下载的网络图片
@property (nonatomic, strong) UIImage *image;

// 下载图片的size
@property (nonatomic, assign) CGSize size;

// 对图片的圆角说明
@property (nonatomic, assign) WMGCornerRadius radius;

// 为图片添加的border宽度
@property (nonatomic, assign) CGFloat borderWidth;

// 图片的模糊处理
@property (nonatomic, assign) CGFloat blurPercent;

// 图片展示的内容模式
@property (nonatomic, assign) UIViewContentMode contentMode;

// 如果涉及点击效果，代表高亮颜色
@property (nonatomic, strong, nullable) UIColor *highlightColor;

// 如果涉及点击效果，代表高亮展示的图片
@property (nonatomic, strong, nullable) UIImage *highlightImage;

/**
 * 根据指定图片名称创建WMGImage
 *
 * @param imgname 图片名称
 *
 */
+ (nullable WMGImage *)imageWithNamed:(NSString *)imgname;

/**
 * 根据指定图片创建WMGImage
 *
 * @param image 图片
 *
 */
+ (nullable WMGImage *)imageWithImage:(UIImage *)image;

/**
 * 根据指定图片url创建WMGImage
 *
 * @param imgUrl 图片url
 *
 */
+ (nullable WMGImage *)imageWithUrl:(NSString *)imgUrl;

/**
 * 根据图片的url下载图片
 *
 * @param urlStr 图片url
 * @param options 详见SDWebImage
 * @param progressBlock 详见SDWebImage
 * @param completion 详见SDWebImage
 *
 */
- (void)wmg_loadImageWithUrl:(NSString *)urlStr options:(SDWebImageOptions)options progress:(nullable SDWebImageDownloaderProgressBlock)progressBlock completed:(SDExternalCompletionBlock)completion;

@end

NS_ASSUME_NONNULL_END
