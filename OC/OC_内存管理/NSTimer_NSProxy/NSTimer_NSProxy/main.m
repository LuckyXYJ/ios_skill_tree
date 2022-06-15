//
//  main.m
//  NSTimer_NSProxy
//
//  Created by xyj on 2018/8/9.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "XZProxy.h"
#import "XZProxy1.h"
#import "ViewController.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        ViewController *vc = [[ViewController alloc] init];
        
        XZProxy *proxy1 = [XZProxy proxyWithTarget:vc];
        
        XZProxy1 *proxy2 = [XZProxy1 proxyWithTarget:vc];
        
        NSLog(@"%d %d",
              [proxy1 isKindOfClass:[ViewController class]],
              
              [proxy2 isKindOfClass:[ViewController class]]);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
