//
//  ViewController.m
//  Jailbreak
//
//  Created by xyj on 2018/9/15.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "JailbreakTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.backgroundColor = [UIColor blueColor];
    button.frame = CGRectMake(30, 200, 300, 50);
    [self.view addSubview:button];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([JailbreakTools judge_isJailbreak]) {
        NSLog(@"已越狱");
    }else {
        NSLog(@"未越狱");
    }
}

@end
