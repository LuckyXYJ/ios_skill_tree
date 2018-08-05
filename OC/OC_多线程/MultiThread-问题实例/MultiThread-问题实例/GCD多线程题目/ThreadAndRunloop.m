//
//  ThreadAndRunloop.m
//  MultiThread-问题实例
//
//  Created by xyj on 2018/6/24.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "ThreadAndRunloop.h"

@implementation ThreadAndRunloop

- (void)threadAndRunloopDemo {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
        
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
        NSLog(@"end");
    }];
    [thread start];
    
    [self performSelector:@selector(test2) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)test2
{
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"1");
        // 这句代码的本质是往Runloop中添加定时器
        [self performSelector:@selector(test) withObject:nil];
        NSLog(@"3");
        
        //        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
        
    });
}

- (void)test
{
    NSLog(@"2");
}

@end
