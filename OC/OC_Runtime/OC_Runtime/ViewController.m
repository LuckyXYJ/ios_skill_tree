//
//  ViewController.m
//  OC_Runtime
//
//  Created by xyj on 2018/5/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "XZPerson.h"
#import "ResolveMethod.h"
#import "ForwardMethod.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%p", [ViewController class]);
    NSLog(@"%p", object_getClass([ViewController class]));
    NSLog(@"%p", [XZPerson class]);
    NSLog(@"%p", object_getClass([XZPerson class]));
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 100, 100, 40);
    [btn addTarget:self action:@selector(clickbutton) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(200, 100, 100, 40);
    [btn1 addTarget:self action:@selector(clickbutton1) forControlEvents:UIControlEventTouchUpInside];
    btn1.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(20, 150, 100, 40);
    [btn2 addTarget:self action:@selector(clickbutton2) forControlEvents:UIControlEventTouchUpInside];
    btn2.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn2];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(200, 150, 100, 40);
    [btn3 addTarget:self action:@selector(clickbutton3) forControlEvents:UIControlEventTouchUpInside];
    btn3.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn3];
}

// 结构题位域，联合体
- (void)clickbutton {
    
    XZPerson *persion = [[XZPerson alloc]init];
    
    NSLog(@"%d", persion.isHandsome);
    NSLog(@"%d", persion.isRich);
    
}

// 动态方法解析
- (void)clickbutton1 {
    
    ResolveMethod *persion = [[ResolveMethod alloc]init];
    
    [persion test];
    [ResolveMethod test];
}

// 消息转发
- (void)clickbutton2 {
    
    ForwardMethod *persion = [[ForwardMethod alloc]init];
    
    [persion test];
    [persion test1];
//    [persion unknowSelector];
//    [ResolveMethod test];
    [persion knowSelectot];
}

// 消息转发
- (void)clickbutton3 {
    
    ForwardMethod *persion = [[ForwardMethod alloc]init];
    
    [persion test];
    [persion test1];
//    [persion unknowSelector];
//    [ResolveMethod test];
    [persion knowSelectot];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
