//
//  ResolveMethod.m
//  OC_Runtime
//
//  Created by xyj on 2018/5/13.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "ResolveMethod.h"
#import <objc/runtime.h>
#import "ReceiveMethod.h"

@implementation ResolveMethod

void c_other(id self, SEL _cmd)
{
    NSLog(@"c_other - %@ - %@", self, NSStringFromSelector(_cmd));
}

- (void)other
{
    NSLog(@"other - %s", __func__);
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 第一个参数是object_getClass(self)
        class_addMethod(object_getClass(self), sel, (IMP)c_other, "v16@0:8");
        
        return YES;
    }
    return [super resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 动态添加test方法的实现
//        class_addMethod(self, sel, (IMP)c_other, "v16@0:8");
        
        // 获取其他方法
        Method method = class_getInstanceMethod(self, @selector(other));
        // 动态添加test方法的实现
        class_addMethod(self, sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
        
        

        // 返回YES代表有动态添加方法
        return YES;
    }
    
    BOOL b = [super resolveInstanceMethod:sel];
    return YES;
}

+ (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(test1)) {
        // objc_msgSend([[ReceiveMethod alloc] init], aSelector)
        return [[ReceiveMethod alloc] init];
    }
    
    id d = [super forwardingTargetForSelector:aSelector];
    return d;
}


// 方法签名：返回值类型、参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    NSMethodSignature *a = [super methodSignatureForSelector:aSelector];
    return a;
}
//
//// NSInvocation封装了一个方法调用，包括：方法调用者、方法名、方法参数
////    anInvocation.target 方法调用者
////    anInvocation.selector 方法名
////    [anInvocation getArgument:NULL atIndex:0]
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    
    NSLog(@"1234");
}

//typedef struct objc_method *Method;
//


//struct objc_method == struct method_t
//struct method_t *otherMethod = (struct method_t *)class_getInstanceMethod(self, @selector(other));




@end
