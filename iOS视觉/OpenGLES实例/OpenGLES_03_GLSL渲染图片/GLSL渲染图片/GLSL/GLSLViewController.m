//
//  GLSLViewController.m
//  GLSL
//
//  Created by xyj on 2019/4/26.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "GLSLViewController.h"
#import "GLSLView.h"
@interface GLSLViewController ()

@property(nonnull,strong)GLSLView *myView;

@end

@implementation GLSLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myView = (GLSLView *)self.view;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
