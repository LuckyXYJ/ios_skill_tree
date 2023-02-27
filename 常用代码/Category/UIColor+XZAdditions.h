//
//  UIColor+XZAdditions.h
//  workers
//
//  Created by ios on 2020/12/13.
//  Copyright © 2020年 cnabc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (XZAdditions)
+ (UIColor *)xz_colorWithHexString:(NSString *)string;

+ (UIColor *)xz_colorWithHexString:(NSString *)string darkColorWithHexString:(NSString *)darkString;

+ (UIColor *)xz_colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;

+ (UIColor *)xz_colorWithHexString:(NSString *)string darkColorWithHexString:(NSString *)darkString alpha:(CGFloat)alpha;

+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue;

+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue darkColorWithHex:(NSInteger)darkHexValue;

+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue darkColorWithHex:(NSInteger)darkHexValue alpha:(CGFloat)alphaValue;

+ (UIColor *)xz_whiteColorWithAlpha:(CGFloat)alphaValue;

+ (UIColor *)xz_blackColorWithAlpha:(CGFloat)alphaValue;
@end
