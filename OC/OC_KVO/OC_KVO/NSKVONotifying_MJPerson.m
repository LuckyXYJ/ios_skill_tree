//
//  NSKVONotifying_MJPerson.m
//  OC_KVO
//
//  Created by xyj on 2018/4/13.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "NSKVONotifying_MJPerson.h"

@implementation NSKVONotifying_MJPerson

- (void)setAge:(int)age
{
    _NSSetIntValueAndNotify();
}

// 屏幕内部实现，隐藏了NSKVONotifying_MJPerson类的存在
- (Class)class
{
    return [MJPerson class];
}

- (void)dealloc
{
    // 收尾工作
}

- (BOOL)_isKVOA
{
    return YES;
}


@end
