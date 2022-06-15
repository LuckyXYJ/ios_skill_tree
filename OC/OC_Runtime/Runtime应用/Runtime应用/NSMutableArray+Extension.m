//
//  NSMutableArray+Extension.m
//  Runtime应用
//
//  Created by xyj on 2018/5/31.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 类簇：NSString、NSArray、NSDictionary，真实类型是其他类型
        Class cls = NSClassFromString(@"__NSArrayM");
        Method method1 = class_getInstanceMethod(cls, @selector(insertObject:atIndex:));
        Method method2 = class_getInstanceMethod(cls, @selector(xz_insertObject:atIndex:));
        method_exchangeImplementations(method1, method2);
    });
}

- (void)xz_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (anObject == nil) return;
    
    [self xz_insertObject:anObject atIndex:index];
}

@end
