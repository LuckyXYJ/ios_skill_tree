//
//  OSUnfairLockDemo.m
//  MultiThread-Sync
//
//  Created by xyj on 2018/7/4.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "OSUnfairLockDemo.h"
#import <os/lock.h>

@interface OSUnfairLockDemo()
// Low-level lock
// ll lock
// lll
// Low-level lock的特点等不到锁就休眠
@property (assign, nonatomic) os_unfair_lock moneyLock;
@property (assign, nonatomic) os_unfair_lock ticketLock;
@end

@implementation OSUnfairLockDemo

- (instancetype)init
{
    if (self = [super init]) {
        self.moneyLock = OS_UNFAIR_LOCK_INIT;
        self.ticketLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

// 死锁：永远拿不到锁
- (void)__saleTicket
{
    os_unfair_lock_lock(&_ticketLock);
    
    [super __saleTicket];
    
    os_unfair_lock_unlock(&_ticketLock);
}

- (void)__saveMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __saveMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney
{
    os_unfair_lock_lock(&_moneyLock);
    
    [super __drawMoney];
    
    os_unfair_lock_unlock(&_moneyLock);
}

@end
