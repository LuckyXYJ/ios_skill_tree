//
//  ViewController.m
//  runloop_PermenantThread
//
//  Created by xyj on 2018/6/11.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "XZPermenantThread.h"
#import "XYJPermenantThread.h"

@interface ViewController ()
//@property (strong, nonatomic) XZPermenantThread *thread;
@property (strong, nonatomic) XYJPermenantThread *thread;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.thread = [[XZPermenantThread alloc] init];
    self.thread = [[XYJPermenantThread alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}

- (IBAction)stop {
    [self.thread stop];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
