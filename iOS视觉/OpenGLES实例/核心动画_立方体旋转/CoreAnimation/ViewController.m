//
//  ViewController.m
//  CoreAnimation
//
//  Created by xyj on 2019/04/24.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "CCViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//固定图层
- (IBAction)PushViewController:(id)sender {
    CCViewController *CV = [[CCViewController
                             alloc]init];
    [self presentViewController:CV animated:YES completion:nil];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
