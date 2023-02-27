//
//  XZMethod.m
//  Runtime应用
//
//  Created by xyj on 2018/5/29.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "XZMethod.h"

@implementation XZMethod

- (void)run
{
    NSLog(@"%s", __func__);
}

- (void)test
{
    NSLog(@"%s", __func__);
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
    }
    return self;
}

@end
