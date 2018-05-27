//
//  main.m
//  Runtime-super
//
//  Created by xyj on 2018/5/27.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

// 局部变量分配在栈空间
// 栈空间分配，从高地址到低地址
void test()
{
    long long a = 4; // 0x7ffee638bff8
    long long b = 5; // 0x7ffee638bff0
    long long c = 6; // 0x7ffee638bfe8
    long long d = 7; // 0x7ffee638bfe0
    
    NSLog(@"%p %p %p %p", &a, &b, &c, &d);
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
//        test();
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
