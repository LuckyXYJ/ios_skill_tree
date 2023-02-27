//
//  NSMutableDictionary+Extension.m
//  Runtime应用
//
//  Created by xyj on 2018/5/31.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "NSMutableDictionary+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (Extension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"__NSDictionaryM");
        Method method1 = class_getInstanceMethod(cls, @selector(setObject:forKeyedSubscript:));
        Method method2 = class_getInstanceMethod(cls, @selector(xz_setObject:forKeyedSubscript:));
        method_exchangeImplementations(method1, method2);
        
        Class cls2 = NSClassFromString(@"__NSDictionaryI");
        Method method3 = class_getInstanceMethod(cls2, @selector(objectForKeyedSubscript:));
        Method method4 = class_getInstanceMethod(cls2, @selector(xz_objectForKeyedSubscript:));
        method_exchangeImplementations(method3, method4);
    });
}

- (void)xz_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key
{
    if (!key) return;
    
    [self xz_setObject:obj forKeyedSubscript:key];
}

- (id)xz_objectForKeyedSubscript:(id)key
{
    if (!key) return nil;
    
    return [self xz_objectForKeyedSubscript:key];
}

@end
