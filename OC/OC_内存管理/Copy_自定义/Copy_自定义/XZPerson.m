//
//  XZPerson.m
//  Copy_自定义
//
//  Created by xyj on 2018/8/17.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "XZPerson.h"

@implementation XZPerson

- (id)copyWithZone:(NSZone *)zone
{
    XZPerson *person = [[XZPerson allocWithZone:zone] init];
    person.age = self.age;
//    person.weight = self.weight;
    return person;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"age = %d, weight = %f", self.age, self.weight];
}

@end
