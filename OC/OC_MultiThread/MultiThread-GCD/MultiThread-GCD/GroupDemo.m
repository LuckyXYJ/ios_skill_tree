//
//  GroupDemo.m
//  MultiThread-GCD
//
//  Created by xyj on 2018/6/27.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "GroupDemo.h"

@implementation GroupDemo

- (void)groutTest {
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 创建并发队列
    dispatch_queue_t queue1 = dispatch_queue_create("my_queue", DISPATCH_QUEUE_SERIAL);
    
    // 添加异步任务
    dispatch_group_async(group, queue1, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务1-%d-%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue1, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务2-%d-%@", i, [NSThread currentThread]);
        }
    });
    
    // 等前面的任务执行完毕后，会自动执行这个任务
//    dispatch_group_notify(group, queue, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            for (int i = 0; i < 5; i++) {
//                NSLog(@"任务3-%@", [NSThread currentThread]);
//            }
//        });
//    });
    
//    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
//        for (int i = 0; i < 5; i++) {
//            NSLog(@"任务3-%@", [NSThread currentThread]);
//        }
//    });
    
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务3-%d-%@", i, [NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"任务4-%d-%@", i, [NSThread currentThread]);
        }
    });
}

@end
