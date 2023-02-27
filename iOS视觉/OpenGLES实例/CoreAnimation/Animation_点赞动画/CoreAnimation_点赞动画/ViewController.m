//
//  ViewController.m
//  CoreAnimation_点赞动画
//
//  Created by xyj on 2019/5/30.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "XZLikeButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //添加点赞按钮
    XZLikeButton * btn = [XZLikeButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(200, 150, 30, 130);
    [self.view addSubview:btn];
    [btn setImage:[UIImage imageNamed:@"dislike"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"like_orange"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClick:(UIButton *)button{
    
    if (!button.selected) { // 点赞
        button.selected = !button.selected;
        NSLog(@"点赞");
    }else{ // 取消点赞
        button.selected = !button.selected;
        NSLog(@"取消赞");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
