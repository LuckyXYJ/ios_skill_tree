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
