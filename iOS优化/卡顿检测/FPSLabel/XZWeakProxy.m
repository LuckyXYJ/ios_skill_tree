//
//  XZWeakProxy.m
//  BaseProject
//
//  Created by xingyajie on 2021/4/21.
//  Copyright © 2021 ios. All rights reserved.
//

#import "XZWeakProxy.h"

@implementation XZWeakProxy

+ (instancetype)proxyWithTarget:(id)target {
    XZWeakProxy *proxy = [self alloc];
    proxy.target = target;
    return proxy;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end
