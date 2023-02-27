//
//  viewController.m
//  OpenGLES_光照
//
//  Created by xyj on 2019/5/22.
//  Copyright © 2019年 xyj. All rights reserved.
//


#import "ViewController.h"
#import "GLView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    GLView *view = [[GLView alloc]init];
    view.frame = self.view.bounds;
    [self.view insertSubview:view atIndex:0];
    
}




@end

