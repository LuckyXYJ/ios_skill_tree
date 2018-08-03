//
//  ViewController.m
//  MultiThread-ReadWrite
//
//  Created by xyj on 2018/8/3.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>

@interface ViewController ()
@property (strong, nonatomic) dispatch_queue_t queue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
//    queue.maxConcurrentOperationCount = 5;
    
//    dispatch_semaphore_create(5);
    
    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 10; i++) {
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_async(self.queue, ^{
            [self read];
        });
        
        dispatch_barrier_async(self.queue, ^{
            [self write];
        });
    }
}


- (void)read {
    sleep(1);
    NSLog(@"read");
}

- (void)write
{
    sleep(1);
    NSLog(@"write");
}

@end

//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    self.queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);
//
//    for (int i = 0; i < 10; i++) {
//        [self read];
//        [self read];
//        [self read];
//        [self write];
//    }
//}
//
//
//- (void)read {
//    dispatch_async(self.queue, ^{
//        sleep(1);
//        NSLog(@"read");
//    });
//}
//
//- (void)write
//{
//    dispatch_barrier_async(self.queue, ^{
//        sleep(1);
//        NSLog(@"write");
//    });
//}
//
//
//@end
