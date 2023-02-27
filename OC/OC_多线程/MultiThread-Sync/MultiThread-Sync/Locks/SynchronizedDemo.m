//
//  SynchronizedDemo.m
//  MultiThread-Sync
//
//  Created by xyj on 2018/7/23.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "SynchronizedDemo.h"

@implementation SynchronizedDemo

- (void)__drawMoney
{
    @synchronized([self class]) {
        [super __drawMoney];
    }
}

- (void)__saveMoney
{
    @synchronized([self class]) { // objc_sync_enter
        [super __saveMoney];
    } // objc_sync_exit
}

- (void)__saleTicket
{
    static NSObject *lock;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [[NSObject alloc] init];
    });
    
    @synchronized(lock) {
        [super __saleTicket];
    }
}

- (void)otherTest
{
    @synchronized([self class]) {
        NSLog(@"123");
        [self otherTest];
    }
}
@end
