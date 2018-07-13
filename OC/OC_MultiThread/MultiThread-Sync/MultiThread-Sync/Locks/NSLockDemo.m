//
//  NSLockDemo.m
//  MultiThread-Sync
//
//  Created by xyj on 2018/7/13.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "NSLockDemo.h"

@interface NSLockDemo()
@property (strong, nonatomic) NSLock *ticketLock;
@property (strong, nonatomic) NSLock *moneyLock;
@end

@implementation NSLockDemo


- (instancetype)init
{
    if (self = [super init]) {
        self.ticketLock = [[NSLock alloc] init];
        self.moneyLock = [[NSLock alloc] init];
    }
    return self;
}

// 死锁：永远拿不到锁
- (void)__saleTicket
{
    [self.ticketLock lock];
    
    [super __saleTicket];
    
    [self.ticketLock unlock];
}

- (void)__saveMoney
{
    [self.moneyLock lock];
    
    [super __saveMoney];
    
    [self.moneyLock unlock];
}

- (void)__drawMoney
{
    [self.moneyLock lock];
    
    [super __drawMoney];
    
    [self.moneyLock unlock];
}

@end
