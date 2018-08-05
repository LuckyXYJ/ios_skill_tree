//
//  SemaphoreDemo.m
//  MultiThread-Sync
//
//  Created by xyj on 2018/7/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "SemaphoreDemo.h"

@interface SemaphoreDemo()
@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@property (strong, nonatomic) dispatch_semaphore_t ticketSemaphore;
@property (strong, nonatomic) dispatch_semaphore_t moneySemaphore;
@end

@implementation SemaphoreDemo

- (instancetype)init
{
    if (self = [super init]) {
        self.semaphore = dispatch_semaphore_create(5);
        self.ticketSemaphore = dispatch_semaphore_create(1);
        self.moneySemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)__drawMoney
{
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    
    [super __drawMoney];
    
    dispatch_semaphore_signal(self.moneySemaphore);
}

- (void)__saveMoney
{
    dispatch_semaphore_wait(self.moneySemaphore, DISPATCH_TIME_FOREVER);
    
    [super __saveMoney];
    
    dispatch_semaphore_signal(self.moneySemaphore);
}

- (void)__saleTicket
{
    dispatch_semaphore_wait(self.ticketSemaphore, DISPATCH_TIME_FOREVER);
    
    [super __saleTicket];
    
    dispatch_semaphore_signal(self.ticketSemaphore);
}

- (void)otherTest
{
    for (int i = 0; i < 20; i++) {
        [[[NSThread alloc] initWithTarget:self selector:@selector(test) object:nil] start];
    }
}

// 线程10、7、6、9、8
- (void)test
{
    // 如果信号量的值 > 0，就让信号量的值减1，然后继续往下执行代码
    // 如果信号量的值 <= 0，就会休眠等待，直到信号量的值变成>0，就让信号量的值减1，然后继续往下执行代码
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"test - %@", [NSThread currentThread]);
    
    // 让信号量的值+1
    dispatch_semaphore_signal(self.semaphore);
}

@end
