//
//  main.m
//  Copy_自定义
//
//  Created by xyj on 2018/8/17.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZPerson.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        XZPerson *p1 = [[XZPerson alloc] init];
        p1.age = 20;
        p1.weight = 50;

        XZPerson *p2 = [p1 copy];
//        p2.age = 30;

        NSLog(@"%@", p1);
        NSLog(@"%@", p2);

        [p2 release];
        [p1 release];
        
        //        NSString *str;
        //        [str copy];
        //        [str mutableCopy];
        
        //        NSArray, NSMutableArray;
        //        NSDictionary, NSMutableDictionary;
        //        NSString, NSMutableString;
        //        NSData, NSMutableData;
        //        NSSet, NSMutableSet;
    }
    return 0;
}
