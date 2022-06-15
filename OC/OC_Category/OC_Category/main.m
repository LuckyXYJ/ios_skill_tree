//
//  main.m
//  OC_Category
//
//  Created by xyj on 2018/5/2.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJPerson.h"
#import "MJPerson+Test.h"
#import <objc/runtime.h>

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MJPerson *person = [[MJPerson alloc] init];
        person.age = 10;
        person.name = @"jack";
        person.weight = 30;
        
        
//        {
//            MJPerson *temp = [[MJPerson alloc] init];
//
//
//            objc_setAssociatedObject(person, @"temp", temp, OBJC_ASSOCIATION_ASSIGN);
//        }
//
//        NSLog(@"%@", objc_getAssociatedObject(person, @"temp"));
        
        
        MJPerson *person2 = [[MJPerson alloc] init];
        person2.age = 20;
        person2.name = @"rose";
        person2.name = nil;
        person2.weight = 50;
        
        NSLog(@"person - age is %d, name is %@, weight is %d", person.age, person.name, person.weight);
        NSLog(@"person2 - age is %d, name is %@, weight is %d", person2.age, person2.name, person2.weight);
    }
    return 0;
}
