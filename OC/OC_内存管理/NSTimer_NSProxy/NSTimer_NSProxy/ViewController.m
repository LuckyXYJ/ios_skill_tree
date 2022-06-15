//
//  ViewController.m
//  NSTimer_NSProxy
//
//  Created by xyj on 2018/8/9.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "XZProxy.h"
#import "XZProxy1.h"

@interface ViewController ()
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) CADisplayLink *link;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 保证调用频率和屏幕的刷帧频率一致，60FPS
//    self.link = [CADisplayLink displayLinkWithTarget:[XZProxy proxyWithTarget:self] selector:@selector(linkTest)];
//    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XZProxy proxyWithTarget:self] selector:@selector(timerTest) userInfo:nil repeats:YES];
    
    //    __weak typeof(self) weakSelf = self;
    //    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
    //        [weakSelf timerTest];
    //    }];
}

- (void)timerTest
{
    NSLog(@"%s", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self.timer invalidate];
}

@end
