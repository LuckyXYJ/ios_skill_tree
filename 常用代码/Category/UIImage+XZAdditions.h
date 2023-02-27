//
//  UIImage+XZAdditions.h
//  workers
//
//  Created by ios on 2020/12/12.
//  Copyright © 2020年 cnabc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XZAdditions)

/**
 截图

 @param view 需要截图的view
 */
+ (UIImage *)xz_screenShootWithView:(UIView *)view;

/**
 通过颜色生成图片

 @param color 颜色
 */
+ (UIImage *)xz_imageWithRenderColor:(UIColor *)color renderSize:(CGSize)size;

/**
 *  获取矩形的渐变色的UIImage
 *
 *  @param bounds       UIImage的bounds
 *  @param colors       渐变色数组，可以设置两种颜色
 *  @param gradientType 渐变的方式：0--->从上到下   1--->从左到右  2--->从左上到右下
 *
 *  @return 渐变色的UIImage
 */
+ (UIImage *)gradientImageWithBounds:(CGRect)bounds andColors:(NSArray*)colors andGradientType:(int)gradientType;

/**
 生成高斯模糊图片

 @param radius 模糊半径
 */
- (UIImage *)xz_gaussianBlurImageWithInputRadius:(CGFloat)radius;


/**
 将图片方向调整为适合观看的角度
 */
- (UIImage *)xz_fixOrientation;

/**
 截取部分图像

 @param rect 截图的尺寸
 */
- (UIImage *)xz_captureSubImageWithRect:(CGRect)rect;


/**
 根据size缩放图片

 @param size 目标size
 */
- (UIImage *)xz_scaleZoomToSize:(CGSize)size;
- (UIImage *)xz_thumbnailForMaxWidth:(CGFloat)maxWith maxHeight:(CGFloat)maxHeight;

@end
