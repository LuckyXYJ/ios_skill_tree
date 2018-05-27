//
//  ForwardMethod.m
//  OC_Runtime
//
//  Created by xyj on 2018/5/15.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "ForwardMethod.h"
#import "ReceiveMethod.h"
#import <objc/runtime.h>

@implementation ForwardMethod

- (void)knowSelectot {
    
    NSLog(@"%s===%s", __func__, _cmd);
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (aSelector == @selector(test)) {
        // objc_msgSend([[ReceiveMethod alloc] init], aSelector)
        return [[ReceiveMethod alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

// 方法签名：返回值类型、参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == @selector(test1)) {
        return [[[ReceiveMethod alloc] init] methodSignatureForSelector:@selector(testAction:)];
//        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    return [super methodSignatureForSelector:aSelector];
}
//
//// NSInvocation封装了一个方法调用，包括：方法调用者、方法名、方法参数
////    anInvocation.target 方法调用者
////    anInvocation.selector 方法名
////    [anInvocation getArgument:NULL atIndex:0]
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    
    if (anInvocation.selector != @selector(test1)) {
        [super forwardInvocation:anInvocation];
        return;
    }

//    anInvocation.target = [[ReceiveMethod alloc] init];
//
    anInvocation.selector = @selector(testAction:);
//    [anInvocation invoke];
    
    NSLog(@"%@", anInvocation);
    NSLog(@"%s", anInvocation.selector);
    NSLog(@"%@", anInvocation.target);

    // 参数顺序：receiver、selector、other arguments
    int a = 12;
    [anInvocation setArgument:&a atIndex:2];
    int age;
    [anInvocation getArgument:&age atIndex:2];
    
    [anInvocation invokeWithTarget:[[ReceiveMethod alloc] init]];
    
    int ret;
    [anInvocation getReturnValue:&ret];
    
    NSLog(@"%d", ret);
    
//    [anInvocation invokeWithReceiveMethodTarget:[[ReceiveMethod alloc] init]];
}

- (void)doesNotRecognizeSelector:(SEL)aSelector {
    
    NSLog(@"%s", aSelector);
}

@end
