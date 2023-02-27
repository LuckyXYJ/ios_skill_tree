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
    void (^block)(void) = ^{
        NSLog(@"-------%d", [self name]);
    };
    block();
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
    }
    return self;
}

@end
