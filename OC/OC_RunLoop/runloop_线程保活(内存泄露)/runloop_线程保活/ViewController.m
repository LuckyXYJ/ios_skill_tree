//
//  ViewController.m
//  runloop_线程保活
//
//  Created by xyj on 2018/6/6.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "XZThread.h"

@interface ViewController ()
@property (strong, nonatomic) XZThread *thread;

@property (assign, nonatomic, getter=isStoped) BOOL stopped;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.thread = [[XZThread alloc] initWithTarget:self selector:@selector(run) object:nil];
//    [self.thread start];
    
    __weak typeof(self) weakSelf = self;
    
    self.stopped = NO;
    self.thread = [[XZThread alloc] initWithBlock:^{
        NSLog(@"%@----begin----", [NSThread currentThread]);

        // 往RunLoop里面添加Source\Timer\Observer
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (!weakSelf.isStoped) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }

        NSLog(@"%@----end----", [NSThread currentThread]);

        // NSRunLoop的run方法是无法停止的，它专门用于开启一个永不销毁的线程（NSRunLoop）
        //        [[NSRunLoop currentRunLoop] run];
        /*
         it runs the receiver in the NSDefaultRunLoopMode by repeatedly invoking runMode:beforeDate:.
         In other words, this method effectively begins an infinite loop that processes data from the run loop’s input sources and timers
         */

    }];
    [self.thread start];
    
    
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 100, 40)];
    btn2.backgroundColor = [UIColor blueColor];
    [btn2 setTitle:@"test" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 100, 40)];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitle:@"jump" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(100, 150, 100, 40)];
    btn1.backgroundColor = [UIColor blueColor];
    [btn1 setTitle:@"back" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(100, 250, 100, 40)];
    btn3.backgroundColor = [UIColor blueColor];
    [btn3 setTitle:@"stop" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.f green:arc4random()%255/255.f blue:arc4random()%255/255.f alpha:1];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
//}

// 子线程需要执行的任务
- (void)test
{
    NSLog(@"--- test ----");
    [self performSelector:@selector(testPrint) onThread:self.thread withObject:nil waitUntilDone:NO];
    
}

- (void)testPrint {
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

- (void)jump {
    ViewController *vc = [[ViewController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:NO completion:nil];
}

- (void)back {
    
//    self.thread = nil;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)stop {
    // 在子线程调用stop
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:NO];
}

// 用于停止子线程的RunLoop
- (void)stopThread
{
    // 设置标记为NO
    self.stopped = YES;
    
    // 停止RunLoop
    CFRunLoopStop(CFRunLoopGetCurrent());
    NSLog(@"%s %@", __func__, [NSThread currentThread]);
}

// 这个方法的目的：线程保活
- (void)run {
    NSLog(@"--- start --- %s %@", __func__, [NSThread currentThread]);
    
    // 往RunLoop里面添加Source\Timer\Observer
//    [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] run];
//    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    
//    while (!self.isStoped) {
//        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//    }
//
    NSLog(@"%s ----end----", __func__);
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

@end
