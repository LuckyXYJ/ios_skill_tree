//
//  ViewController.m
//  MultiThread-GCD
//
//  Created by xyj on 2018/6/27.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "GroupDemo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    GroupDemo *demo = [[GroupDemo alloc]init];
    
    [demo groutTest];
    
    
}


@end
