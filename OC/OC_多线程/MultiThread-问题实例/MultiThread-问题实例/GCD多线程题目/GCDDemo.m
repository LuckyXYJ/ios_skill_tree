//
//  GCDDemo.m
//  MultiThread-问题实例
//
//  Created by xyj on 2018/6/24.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "GCDDemo.h"

@implementation GCDDemo

// dispatch_sync和dispatch_async用来控制是否要开启新的线程

/**
 队列的类型，决定了任务的执行方式（并发、串行）
 1.并发队列
 2.串行队列
 3.主队列（也是一个串行队列）
 */

// 1 崩溃
- (void)gcdDemo01
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_sync(queue, ^{
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
    
    // dispatch_sync立马在当前线程同步执行任务
}

// 132
- (void)gcdDemo02
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        NSLog(@"执行任务2");
    });
    
    NSLog(@"执行任务3");
    
    // dispatch_async不要求立马在当前线程同步执行任务
}

// 152 崩溃
- (void)gcdDemo03
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");
        });
    
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}

// 15234
- (void)gcdDemo04
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("myqueu2", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queue2 = dispatch_queue_create("myqueu2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue2, ^{ // 1
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}

// 15234
- (void)gcdDemo05
{
    // 问题：以下代码是在主线程执行的，会不会产生死锁？不会！
    NSLog(@"执行任务1");
    
    dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{ // 0
        NSLog(@"执行任务2");
        
        dispatch_sync(queue, ^{ // 1
            NSLog(@"执行任务3");
        });
        
        NSLog(@"执行任务4");
    });
    
    NSLog(@"执行任务5");
}


@end
