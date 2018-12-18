//
//  UIImage+Graver.h
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
    

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 WMGCornerRadius
 
 定义圆角的左上，右上，左下，右下四个位置的圆角半径值
 */
typedef struct WMGCornerRadius {
    CGFloat topLeft, topRight, bottomLeft, bottomRight;
} WMGCornerRadius;

/**
 创建一个WMGCornerRadius，指定不同位置的圆角半径
 @param topLeft     左上位置的圆角半径
 @param topRight    右上位置的圆角半径
 @param bottomLeft  左下位置的圆角半径
 @param bottomRight 右下位置的圆角半径
 @return 返回WMGCornerRadius，指定不同位置的圆角半径
 */
UIKIT_STATIC_INLINE WMGCornerRadius WMGCornerRadiusMake(CGFloat topLeft, CGFloat topRight, CGFloat bottomLeft, CGFloat bottomRight) {
    WMGCornerRadius radius = {topLeft, topRight, bottomLeft, bottomRight};
    return radius;
}

UIKIT_STATIC_INLINE BOOL WMGCornerRadiusEqual(WMGCornerRadius r1, WMGCornerRadius r2)
{
    return r1.topLeft == r2.topLeft && r1.topRight == r2.topRight && r1.bottomLeft == r2.bottomLeft && r1.bottomRight == r2.bottomRight;
}

UIKIT_STATIC_INLINE BOOL WMGCornerRadiusIsPerfect(WMGCornerRadius r)
{
    return r.topLeft == r.topRight && r.bottomLeft == r.bottomRight && r.topLeft == r.bottomLeft;
}

UIKIT_STATIC_INLINE WMGCornerRadius WMGCornerPerfectRadius(CGFloat r)
{
    return WMGCornerRadiusMake(r, r, r, r);
}

UIKIT_STATIC_INLINE BOOL WMGCornerRadiusIsValid(WMGCornerRadius r)
{
    return r.topLeft > 0.0 || r.topRight > 0.0 || r.bottomLeft > 0.0 || r.bottomRight > 0.0;
}

extern const WMGCornerRadius WMGCornerRadiusZero;

@class WMMutableAttributedItem;

@interface UIImage (Graver)

/**
 * 创建一张图片
 *
 * @param color         图片颜色
 * @param size          图片size
 * @param width         border宽度
 * @param borderColor   border颜色
 * @param radius        圆角半径 CGFloat
 *
 * @discussion          该方法可以创建一站矩形纯色图片，带边框、带圆角、底色透明，边框带线条的各种样式
 *
 * @return UIImage
 */
+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius;

/**
 * 创建一张图片
 *
 * @param color         图片颜色
 * @param size          图片size
 * @param width         border宽度
 * @param borderColor   border颜色
 * @param radius        圆角半径 WMGCornerRadius
 *
 * @discussion          根据WMGCornerRadius结构体可以指定任一一个角的弧度，也可指定每个角都有不同的弧度
 * @return UIImage
 */
+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor borderRadius:(WMGCornerRadius)radius;

/**
 * 创建一张纯色图片
 *
 * @param color         图片颜色
 * @return UIImage
 */
+ (UIImage *)wmg_imageWithColor:(UIColor *)color;

/**
 * 创建一张图片
 *
 * @param color         图片颜色
 * @param size          图片size
 *
 * @return UIImage
 */
+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 * 将一张图片绘制到另一张图片的指定位置
 *
 * @param image         图片
 * @param point         指定绘制位置
 *
 * @return UIImage
 */
- (UIImage *)wmg_drawImage:(UIImage *)image atPosition:(CGPoint)point;

/**
 * 将一个AttributedItem绘制到一张图片的指定位置
 *
 * @param item         WMMutableAttributedItem
 * @param point        指定绘制位置
 *
 * @return UIImage
 */
- (UIImage *)wmg_drawItem:(WMMutableAttributedItem *)item atPosition:(CGPoint)point;

/**
 * 将一个AttributedItem绘制到一张图片的指定位置
 *
 * @param item          WMMutableAttributedItem
 * @param numberOfLines 可指定按几行绘制
 * @param point         指定绘制位置
 *
 * @return UIImage
 */
- (UIImage *)wmg_drawItem:(WMMutableAttributedItem *)item numberOfLines:(NSUInteger)numberOfLines atPosition:(CGPoint)point;

/**
 * 图片模糊处理
 *
 * @param percent  非法值按照0.5模糊处理 percent : 0.0 ~ 1.0
 *
 * @return UIImage
 */
- (UIImage *)wmg_blurImageWithBlurPercent:(CGFloat)percent;

/**
 * 图片灰化处理
 *
 * @return UIImage
 */
- (UIImage *)wmg_greyImage;

/**
 * 圆角图片创建
 *
 * @param size  大小
 * @param color 颜色
 * @param radius  圆角
 *
 * @return UIImage
 */
+ (UIImage *)wmg_roundedImageWithSize:(CGSize)size color:(UIColor *)color radius:(CGFloat)radius;

/**
 * 圆角处理
 *
 * @return UIImage
 */
- (UIImage *)wmg_roundedImage;

/**
 * 圆角处理
 *
 * @param radius 指定圆角弧度
 *
 * @return UIImage
 */
- (UIImage *)wmg_roundedImageWithRadius:(NSInteger)radius;

/**
 * 圆角处理
 *
 * @param cornerRadius    指定圆角弧度
 * @param rectCornerType  指定圆角位置
 *
 * @return UIImage
 */
- (UIImage *)wmg_roundedImageWithCornerRadius:(CGFloat)cornerRadius cornerType:(UIRectCorner)rectCornerType;

/**
 * 圆角处理
 *
 * @param radius    WMGCornerRadius类型指定圆角弧度
 *
 * @return UIImage
 */
- (UIImage *)wmg_roundedImageWithCornerRadius:(WMGCornerRadius)radius;

/**
 * 获取一张 图片的缩略图
 *
 * @param thumbnailSize    缩略图size
 * @param borderSize       边框size
 * @param cornerRadius     圆角
 * @param contentMode      内容模式
 * @param quality          质量参数
 *
 * @return UIImage
 */
- (UIImage *)wmg_thumbnailImage:(NSInteger)thumbnailSize transparentBorder:(NSUInteger)borderSize cornerRadius:(NSUInteger)cornerRadius resizeMode:(UIViewContentMode)contentMode interpolationQuality:(CGInterpolationQuality)quality;

/**
 * 图片裁剪
 *
 * @param croppedSize      裁剪size
 * @param contentMode      内容模式
 * @param quality          质量参数
 *
 * @return UIImage
 */
- (UIImage *)wmg_cropImageWithCroppedSize:(CGSize)croppedSize contentMode:(UIViewContentMode)contentMode interpolationQuality:(CGInterpolationQuality)quality;

/**
 * 将一张图片调整到指定size，生成一张新图片
 *
 * @param size      size
 *
 * @return UIImage
 */
- (UIImage *)wmg_resizedImageToSize:(CGSize)size;

@end

