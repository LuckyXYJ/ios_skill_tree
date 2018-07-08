//
//  ViewController.m
//  MultiThread-Sync
//
//  Created by xyj on 2018/7/2.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "XZBaseDemo.h"
#import "OSSpinLockDemo.h"
#import "OSSpinLockDemo2.h"
#import "OSUnfairLockDemo.h"
#import "MutexDemo.h" // pthread_mutex_t默认锁
#import "MutexDemo2.h" // pthread_mutex_t递归锁


@interface ViewController ()
@property (strong, nonatomic) XZBaseDemo *demo;

@property (strong, nonatomic) NSThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    XZBaseDemo *demo = [[MutexDemo2 alloc] init];
    [demo ticketTest];
    [demo moneyTest];
    [demo otherTest];
}

@end
