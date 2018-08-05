//
//  OSSpinLockDemo2.m
//  MultiThread-Sync
//
//  Created by xyj on 2018/7/2.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "OSSpinLockDemo2.h"
#import <libkern/OSAtomic.h>

@implementation OSSpinLockDemo2

static OSSpinLock moneyLock_;
+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moneyLock_ = 0;
    });
}

- (void)__drawMoney
{
    OSSpinLockLock(&moneyLock_);
    
    [super __drawMoney];
    
    OSSpinLockUnlock(&moneyLock_);
}

- (void)__saveMoney
{
    OSSpinLockLock(&moneyLock_);
    
    [super __saveMoney];
    
    OSSpinLockUnlock(&moneyLock_);
}

- (void)__saleTicket
{
//    static NSString *str = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        str = [NSString stringWithFormat:@"123"];
//    });
    
    static OSSpinLock ticketLock = OS_SPINLOCK_INIT;
    
    OSSpinLockLock(&ticketLock);
    
    [super __saleTicket];
    
    OSSpinLockUnlock(&ticketLock);
}

@end
