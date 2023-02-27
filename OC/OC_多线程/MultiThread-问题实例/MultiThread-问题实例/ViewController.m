//
//  ViewController.m
//  MultiThread-问题实例
//
//  Created by xyj on 2018/6/22.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"

#import "GCDDemo.h"

#import "ThreadAndRunloop.h"

@interface ViewController ()

@property(nonatomic, strong)GCDDemo *gcdDemo;
@property(nonatomic, strong)ThreadAndRunloop *runloopDemo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view, typically from a nib.
    _gcdDemo = [[GCDDemo alloc]init];
    _runloopDemo = [[ThreadAndRunloop alloc]init];
}

- (IBAction)test1:(id)sender {
    [_gcdDemo gcdDemo01];
}

- (IBAction)test2:(id)sender {
    [_gcdDemo gcdDemo02];
}

- (IBAction)test3:(id)sender {
    [_gcdDemo gcdDemo03];
}

- (IBAction)test4:(id)sender {
    [_gcdDemo gcdDemo04];
}

- (IBAction)test5:(id)sender {
    [_gcdDemo gcdDemo05];
}

- (IBAction)test6:(id)sender {
    [_runloopDemo threadAndRunloopDemo];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


@end
