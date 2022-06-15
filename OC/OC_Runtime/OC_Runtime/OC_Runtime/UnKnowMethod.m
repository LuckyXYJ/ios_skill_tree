//
//  UnKnowMethod.m
//  OC_Runtime
//
//  Created by xyj on 2018/5/17.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "UnKnowMethod.h"

@implementation UnKnowMethod

- (void)run
{
    NSLog(@"run-123");
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    // 本来能调用的方法
    if ([self respondsToSelector:aSelector]) {
        return [super methodSignatureForSelector:aSelector];
    }
    
    // 找不到的方法
    return [NSMethodSignature signatureWithObjCTypes:"v@:"];
}

// 找不到的方法，都会来到这里
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    NSLog(@"找不到%@方法", NSStringFromSelector(anInvocation.selector));
}

@end
