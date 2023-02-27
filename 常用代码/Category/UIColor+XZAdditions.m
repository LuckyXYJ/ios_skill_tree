//
//  UIColor+XZAdditions.m
//  workers
//
//  Created by ios on 2020/12/13.
//  Copyright © 2020年 cnabc. All rights reserved.
//

#import "UIColor+XZAdditions.h"

@implementation UIColor (XZAdditions)
+ (UIColor *)xz_colorWithHexString:(NSString *)string {
    return [UIColor xz_colorWithHexString:string alpha:1.];
}

+ (UIColor *)xz_colorWithHexString:(NSString *)string alpha:(CGFloat)alpha {
    UIColor *color = nil;
    NSString *trimString = string;
    
    NSRange range = [string rangeOfString:@"0X" options:NSCaseInsensitiveSearch];
    if (range.location != NSNotFound) {
        trimString = [string substringFromIndex:2];
    }
    
    if ([trimString isEqualToString:string]) {
        range = [string rangeOfString:@"#"];
        if (range.location != NSNotFound) {
            trimString = [string substringFromIndex:1];
        }
    }
    
    uint32_t rgb;
    NSScanner *scanner = [NSScanner scannerWithString:trimString];
    [scanner scanHexInt:&rgb];
    
    CGFloat red, green, blue;
    
    if (trimString.length == 8) {
        CGFloat newAlpha = (rgb & 0xFF000000) >> 24;
        alpha = newAlpha / 255.f;
    }
    
    red = (rgb & 0xFF0000) >> 16;
    green = (rgb & 0x00FF00) >> 8;
    blue = (rgb & 0x0000FF);
    
    color = [UIColor colorWithRed:(red / 255.f) green:(green / 255.f) blue:(blue / 255.f) alpha:alpha];
    return color;
}

+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue {
    return [UIColor xz_colorWithHex:hexValue alpha:1.0];
}

+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor *)xz_whiteColorWithAlpha:(CGFloat)alphaValue {
    return [UIColor xz_colorWithHex:0xffffff alpha:alphaValue];
}

+ (UIColor *)xz_blackColorWithAlpha:(CGFloat)alphaValue {
    return [UIColor xz_colorWithHex:0x000000 alpha:alphaValue];
}


+ (UIColor *)xz_colorWithHexString:(NSString *)string darkColorWithHexString:(NSString *)darkString {
    __block UIColor *showColor = [self xz_colorWithHexString:string];
       if (@available(iOS 13.0, *)) {
           showColor = [UIColor colorWithDynamicProvider:^UIColor * (UITraitCollection * dynamicProvider) {
               if (dynamicProvider.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return  [self xz_colorWithHexString:darkString];
               } else {
                   return [self xz_colorWithHexString:string];
               }
           }];
       }
       return showColor;
}


+ (UIColor *)xz_colorWithHexString:(NSString *)string darkColorWithHexString:(NSString *)darkString alpha:(CGFloat)alpha {
    __block UIColor *showColor = [self xz_colorWithHexString:string alpha:alpha];
       if (@available(iOS 13.0, *)) {
           showColor = [UIColor colorWithDynamicProvider:^UIColor * (UITraitCollection * dynamicProvider) {
               if (dynamicProvider.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return  [self xz_colorWithHexString:darkString alpha:alpha];
               } else {
                   return [self xz_colorWithHexString:string alpha:alpha];
               }
           }];
       }
       return showColor;
}


+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue darkColorWithHex:(NSInteger)darkHexValue {
    __block UIColor *showColor = [self xz_colorWithHex:hexValue];
       if (@available(iOS 13.0, *)) {
           showColor = [UIColor colorWithDynamicProvider:^UIColor * (UITraitCollection * dynamicProvider) {
               if (dynamicProvider.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return  [self xz_colorWithHex:darkHexValue];
               } else {
                   return [self xz_colorWithHex:hexValue];
               }
           }];
       }
       return showColor;
}


+ (UIColor *)xz_colorWithHex:(NSInteger)hexValue darkColorWithHex:(NSInteger)darkHexValue alpha:(CGFloat)alphaValue {
    __block UIColor *showColor = [self xz_colorWithHex:hexValue alpha:alphaValue];
       if (@available(iOS 13.0, *)) {
           showColor = [UIColor colorWithDynamicProvider:^UIColor * (UITraitCollection * dynamicProvider) {
               if (dynamicProvider.userInterfaceStyle == UIUserInterfaceStyleDark) {
                   return  [self xz_colorWithHex:darkHexValue alpha:alphaValue];
               } else {
                   return [self xz_colorWithHex:hexValue alpha:alphaValue];
               }
           }];
       }
       return showColor;
}
@end
