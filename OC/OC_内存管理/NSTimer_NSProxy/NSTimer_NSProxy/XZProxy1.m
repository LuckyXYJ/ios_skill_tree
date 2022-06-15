//
//  XZProxy1.m
//  NSTimer_NSProxy
//
//  Created by xyj on 2018/8/9.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "XZProxy1.h"

@implementation XZProxy1

+ (instancetype)proxyWithTarget:(id)target
{
    XZProxy1 *proxy = [[XZProxy1 alloc] init];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return self.target;
}

@end
