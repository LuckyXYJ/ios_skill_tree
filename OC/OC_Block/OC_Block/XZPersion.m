//
//  XZPersion.m
//  OC_Block
//
//  Created by xyj on 2018/5/5.
//  Copyright © 2022 xyj All rights reserved.
//

#import "XZPersion.h"

@implementation XZPersion

int age_ = 10;

- (void)test
{
    __block NSString *str = @"123456";
    void (^block)(void) = ^{
//        NSLog(@"-------%@", self.name);
//        self.name = @"addd";
        NSLog(@"-------%@", str);
        str = @"addd";
    };
    block();
    self.block = block;
//    NSLog(@"-------%@", self.name);
    NSLog(@"-------%@", str);
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"释放");
}

@end
