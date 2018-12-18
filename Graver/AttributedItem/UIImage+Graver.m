//
//  UIImage+Graver.m
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
    

#import "UIImage+Graver.h"
#import "WMMutableAttributedItem.h"
#import "UIBezierPath+Graver.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "WMGraverMacroDefine.h"

const WMGCornerRadius WMGCornerRadiusZero = {0.0, 0.0, 0.0, 0.0};

@implementation UIImage (Graver)

- (UIImage *)wmg_roundedImageWithRadius:(NSInteger)radius
{
    if (!self.size.height || !self.size.width) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [self drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    return UIGraphicsGetImageFromCurrentImageContext();
}

+ (UIImage *)wmg_roundedImageWithSize:(CGSize)size color:(UIColor *)color radius:(CGFloat)radius
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, size.width, size.height));
    
    // Build a context that's the same dimensions as the new size
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                newRect.size.width * 4,
                                                rgbColorSpace,
                                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbColorSpace);
    
    // Default white background color.
    CGRect rect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    CGPathRef clippath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath;
    CGContextAddPath(bitmap, clippath);
    CGContextClip(bitmap);
    
    CGContextSetFillColorWithColor(bitmap, color.CGColor);
    CGContextFillRect(bitmap, rect);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

+ (UIImage *)wmg_imageWithColor:(UIColor *)color
{
    return [self wmg_imageWithColor:color size:CGSizeMake(1, 1)];
}

+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size
{
    return [self wmg_imageWithColor:color size:size borderWidth:0 borderColor:nil cornerRadius:0];
}

+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor borderRadius:(WMGCornerRadius)radius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    if (!WMGCornerRadiusIsValid(radius))
    {
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        if(width > 0)
        {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
            CGContextAddPath(context, path.CGPath);
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, width);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
    }
    else
    {
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        CGContextFillRect(context, rect);
        
        UIBezierPath *path = [UIBezierPath wmg_bezierPathWithRect:rect cornerRadius:radius lineWidth:width];
        [path setUsesEvenOddFillRule:YES];
        [path addClip];
        CGContextAddPath(context, path.CGPath);
        
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, rect);
        
        CGContextAddPath(context, path.CGPath);
        
        if (width > 0.0)
        {
            CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
            CGContextSetLineWidth(context, width);
            CGContextDrawPath(context, kCGPathFillStroke);
        }
        else
        {
            CGContextDrawPath(context, kCGPathFill);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)wmg_imageWithColor:(UIColor *)color size:(CGSize)size borderWidth:(CGFloat)width borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)radius
{
    return [self wmg_imageWithColor:color size:size borderWidth:width borderColor:borderColor borderRadius:WMGCornerPerfectRadius(radius)];
}

- (UIImage *)wmg_drawItem:(WMMutableAttributedItem *)item atPosition:(CGPoint)point
{
    if (!self.size.height || !self.size.width) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, FALSE, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    CGRect rect = CGRectMake(point.x, point.y, self.size.width - point.x, self.size.height - point.y);
    
    [item.resultString wmg_drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)wmg_drawItem:(WMMutableAttributedItem *)item numberOfLines:(NSUInteger)numberOfLines atPosition:(CGPoint)point
{
    if (!self.size.height || !self.size.width) {
        return self;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, FALSE, self.scale);
    
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    CGRect rect = CGRectMake(point.x, point.y, self.size.width - point.x, self.size.height - point.y);
    
    [item.resultString wmg_drawInRect:rect numberOfLines:numberOfLines context:UIGraphicsGetCurrentContext()];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)wmg_drawImage:(UIImage *)image atPosition:(CGPoint)point
{
    if (!self.size.height || !self.size.width) {
        return self;
    }
    UIGraphicsBeginImageContextWithOptions(self.size, FALSE, self.scale);
    [self drawInRect:CGRectMake(0,0,self.size.width,self.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    
    [image drawInRect:rect];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)wmg_blurImageWithBlurPercent:(CGFloat)percent
{
    // hack, helps w/ our colors when blurring
    NSData *imageData = UIImageJPEGRepresentation(self, 1); // convert to jpeg
    UIImage *destImage = [UIImage imageWithData:imageData];
    
    if (percent < 0.f || percent > 1.f) {
        percent = 0.5f;
    }
    
    int boxSize = (int)(percent * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = destImage.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    
    vImage_Error error;
    
    void *pixelBuffer;
    
    //create vImage_Buffer with data from CGImageRef
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //create vImage_Buffer for output
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        WMGLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // Create a third buffer for intermediate processing
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //perform convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        WMGLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        WMGLog(@"error from convolution %ld", error);
    }
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        WMGLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGImageRelease(imageRef);
    
    return returnImage;
}

- (UIImage *)wmg_greyImage
{
    CGFloat scale = [self scale];
    
    CGSize size = [self size];
    int width = size.width *scale;
    int height = size.height *scale;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[1] + 0.59 * rgbaPixel[2] + 0.11 * rgbaPixel[3];
            
            rgbaPixel[0] = rgbaPixel[0] * 0.7;
            
            // set the pixels to gray
            rgbaPixel[1] = gray;
            rgbaPixel[2] = gray;
            rgbaPixel[3] = gray;
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image scale:scale orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

- (UIImage *)wmg_roundedImage
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIImage *image = nil;
    CGRect rect = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithOvalInRect:rect] addClip];
    [self drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)wmg_roundedImageWithCornerRadius:(CGFloat)cornerRadius cornerType:(UIRectCorner)rectCornerType
{
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    cornerRadius = MAX(0, MIN(MIN(w, h)/2, cornerRadius));
    
    UIImage *image = nil;
    CGRect rect = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    [[UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:rectCornerType cornerRadii:CGSizeMake(cornerRadius, cornerRadius)] addClip];
    [self drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)wmg_roundedImageWithCornerRadius:(WMGCornerRadius)radius
{
    if (!WMGCornerRadiusIsValid(radius)) {
        return self;
    }
    
    CGFloat w = self.size.width;
    CGFloat h = self.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    UIImage *image = nil;
    CGRect rect = CGRectMake(0., 0., w, h);
    UIGraphicsBeginImageContextWithOptions(self.size, NO, scale);
    UIBezierPath *topLeftCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(radius.topLeft, radius.topLeft)];
    [topLeftCornerPath addClip];
    
    UIBezierPath *topRightCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight cornerRadii:CGSizeMake(radius.topRight, radius.topRight)];
    [topRightCornerPath addClip];
    
    UIBezierPath *bottomLeftCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomLeft cornerRadii:CGSizeMake(radius.bottomLeft, radius.bottomLeft)];
    [bottomLeftCornerPath addClip];
    
    UIBezierPath *bottomRightCornerPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerBottomRight cornerRadii:CGSizeMake(radius.bottomRight, radius.bottomRight)];
    [bottomRightCornerPath addClip];
    
    [self drawInRect:rect];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)wmg_thumbnailImage:(NSInteger)thumbnailSize transparentBorder:(NSUInteger)borderSize cornerRadius:(NSUInteger)cornerRadius resizeMode:(UIViewContentMode)contentMode interpolationQuality:(CGInterpolationQuality)quality
{
    UIImage *resizedImage = [self wmg_resizedImageWithContentMode:contentMode
                                                            bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                              interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage wmg_croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage wmg_transparentBorderImage:borderSize] : croppedImage;
    
    return [transparentBorderImage wmg_roundedCornerImage:cornerRadius borderSize:borderSize];
}

- (UIImage *)wmg_cropImageWithCroppedSize:(CGSize)croppedSize contentMode:(UIViewContentMode)contentMode interpolationQuality:(CGInterpolationQuality)quality
{
    UIImage *resizedImage = [self wmg_resizedImageWithContentMode:contentMode
                                                            bounds:croppedSize
                                              interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - croppedSize.width) / 2),
                                 round((resizedImage.size.height - croppedSize.height) / 2),
                                 croppedSize.width,
                                 croppedSize.height);
    UIImage *croppedImage = [resizedImage wmg_croppedImage:cropRect];
    
    return croppedImage;
}

- (UIImage *)wmg_resizedImageToSize:(CGSize)size
{
    CGImageRef imgRef = self.CGImage;
    // the below values are regardless of orientation : for UIImages from Camera, width>height (landscape)
    CGSize  srcSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef)); // not equivalent to self.size (which is dependant on the imageOrientation)!
    
    /* Don't resize if we already meet the required destination size. */
    if (CGSizeEqualToSize(srcSize, size)) {
        return self;
    }
    
    CGFloat scaleRatio = size.width / srcSize.width;
    UIImageOrientation orient = self.imageOrientation;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(srcSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(srcSize.width, srcSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, srcSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeTranslation(0.0, srcSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI_2);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            size = CGSizeMake(size.height, size.width);
            transform = CGAffineTransformMakeTranslation(srcSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    /////////////////////////////////////////////////////////////////////////////
    // The actual resize: draw the image on a new context, applying a transform matrix
    UIGraphicsBeginImageContextWithOptions(size, NO, self.scale);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (!context) {
        return nil;
    }
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -srcSize.height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -srcSize.height);
    }
    
    CGContextConcatCTM(context, transform);
    
    // we use srcSize (and not dstSize) as the size to specify is in user space (and we use the CTM to apply a scaleRatio)
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, srcSize.width, srcSize.height), imgRef);
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)wmg_resizedImageWithContentMode:(UIViewContentMode)contentMode
                                       bounds:(CGSize)bounds
                         interpolationQuality:(CGInterpolationQuality)quality
{
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    CGSize newSize ;
    if (contentMode == UIViewContentModeScaleAspectFill) {
        ratio = MAX(horizontalRatio, verticalRatio);
        newSize = CGSizeMake(roundf(self.size.width * ratio), roundf(self.size.height * ratio));
    }
    else if (contentMode == UIViewContentModeScaleAspectFit){
        ratio = MIN(horizontalRatio, verticalRatio);
        newSize = CGSizeMake(roundf(self.size.width * ratio), roundf(self.size.height * ratio));
    }
    else if (contentMode == UIViewContentModeScaleToFill){
        newSize = CGSizeMake(roundf(self.size.width * horizontalRatio), roundf(self.size.height * verticalRatio));
    }
    else{
        return self;
    }
    
    return [self wmg_resizedImage:newSize interpolationQuality:quality];
}

- (UIImage *)wmg_resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality
{
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self wmg_resizedImage:newSize
                         transform:[self wmg_transformForOrientation:newSize]
                    drawTransposed:drawTransposed
              interpolationQuality:quality];
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)wmg_transformForOrientation:(CGSize)newSize
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        default:
            break;
    }
    
    return transform;
}

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)wmg_resizedImage:(CGSize)newSize
                     transform:(CGAffineTransform)transform
                drawTransposed:(BOOL)transpose
          interpolationQuality:(CGInterpolationQuality)quality
{
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                8,
                                                newRect.size.width * 4,
                                                rgbColorSpace,
                                                (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(rgbColorSpace);
    
    // Default white background color.
    CGRect rect = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    CGContextSetFillColorWithColor(bitmap, [UIColor clearColor].CGColor);
    CGContextFillRect(bitmap, rect);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    
    return newImage;
}

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)wmg_croppedImage:(CGRect)bounds
{
    bounds = CGRectMake(bounds.origin.x * self.scale, bounds.origin.y * self.scale, bounds.size.width * self.scale, bounds.size.height * self.scale);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns true if the image has an alpha layer
- (BOOL)wmg_hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)wmg_imageWithAlpha
{
    if ([self wmg_hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}

// Creates a mask that makes the outer edges transparent and everything else opaque
// The size must include the entire mask (opaque part + transparent border)
// The caller is responsible for releasing the returned reference by calling CGImageRelease
- (CGImageRef)wmg_newBorderMask:(NSUInteger)borderSize size:(CGSize)size
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Build a context that's the same dimensions as the new size
    CGContextRef maskContext = CGBitmapContextCreate(NULL,
                                                     size.width,
                                                     size.height,
                                                     8, // 8-bit grayscale
                                                     0,
                                                     colorSpace,
                                                     kCGBitmapByteOrderDefault | kCGImageAlphaNone);
    
    // Start with a mask that's entirely transparent
    CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));
    
    // Make the inner part (within the border) opaque
    CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
    CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));
    
    // Get an image of the context
    CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);
    
    // Clean up
    CGContextRelease(maskContext);
    CGColorSpaceRelease(colorSpace);
    
    // 调用方负责内存释放，此处静态分析ignore
    return maskImageRef;
}

// Returns a copy of the image with a transparent border of the given size added around its edges.
// If the image has no alpha layer, one will be added to it.
- (UIImage *)wmg_transparentBorderImage:(NSUInteger)borderSize {
    // If the image does not have an alpha layer, add one
    UIImage *image = [self wmg_imageWithAlpha];
    
    CGRect newRect = CGRectMake(0, 0, image.size.width + borderSize * 2, image.size.height + borderSize * 2);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(self.CGImage),
                                                0,
                                                CGImageGetColorSpace(self.CGImage),
                                                CGImageGetBitmapInfo(self.CGImage));
    
    // Draw the image in the center of the context, leaving a gap around the edges
    CGRect imageLocation = CGRectMake(borderSize, borderSize, image.size.width, image.size.height);
    CGContextDrawImage(bitmap, imageLocation, self.CGImage);
    CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);
    
    // Create a mask to make the border transparent, and combine it with the image
    CGImageRef maskImageRef = [self wmg_newBorderMask:borderSize size:newRect.size];
    CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
    UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(borderImageRef);
    CGImageRelease(maskImageRef);
    CGImageRelease(transparentBorderImageRef);
    
    return transparentBorderImage;
}

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)wmg_addRoundedRectToPath:(CGRect)rect context:(CGContextRef)context ovalWidth:(CGFloat)ovalWidth ovalHeight:(CGFloat)ovalHeight
{
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
    CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (UIImage *)wmg_roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize
{
    // If the image does not have an alpha layer, add one
    UIImage *image = [self wmg_imageWithAlpha];
    
    // Build a context that's the same dimensions as the new size
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 image.size.width,
                                                 image.size.height,
                                                 CGImageGetBitsPerComponent(image.CGImage),
                                                 0,
                                                 CGImageGetColorSpace(image.CGImage),
                                                 CGImageGetBitmapInfo(image.CGImage));
    
    // Create a clipping path with rounded corners
    CGContextBeginPath(context);
    [self wmg_addRoundedRectToPath:CGRectMake(borderSize, borderSize, image.size.width - borderSize * 2, image.size.height - borderSize * 2)
                            context:context
                          ovalWidth:cornerSize
                         ovalHeight:cornerSize];
    CGContextClosePath(context);
    CGContextClip(context);
    
    // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    
    // Create a CGImage from the context
    CGImageRef clippedImage = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    // Create a UIImage from the CGImage
    UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage];
    CGImageRelease(clippedImage);
    
    return roundedImage;
}

@end
