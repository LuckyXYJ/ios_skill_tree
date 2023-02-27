//
//  ViewController.m
//  XZApp
//
//  Created by xyj on 2021/01/26.
//

#import "ViewController.h"
#import <XZOneFramework/XZOneFramework.h>

@implementation ViewController
//
void global_object();
- (void)viewDidLoad {
    [super viewDidLoad];
    global_object();
    XZOneObject *one = [XZOneObject new];
    [one testOneObject];
}

 
@end
