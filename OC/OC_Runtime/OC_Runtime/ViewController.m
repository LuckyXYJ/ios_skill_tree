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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
