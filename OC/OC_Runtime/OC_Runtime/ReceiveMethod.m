//
//  ReceiveMethod.m
//  OC_Runtime
//
//  Created by xyj on 2018/5/15.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "ReceiveMethod.h"

@implementation ReceiveMethod

- (void)test
{
    NSLog(@"%s", __func__);
}

- (int)testAction:(int)num
{
    NSLog(@"%s", __func__);
    
    return num * 2;
}

@end
