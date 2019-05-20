//
//  XZViewController.m
//  OpenGLES_GLSL三角形变换
//
//  Created by xyj on 2019/5/19.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "XZViewController.h"
#import "XZView.h"
@interface XZViewController ()

@property(nonatomic,strong)XZView *cView;


@end

@implementation XZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cView = (XZView *)self.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
