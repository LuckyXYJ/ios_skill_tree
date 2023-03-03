//
//  main.m
//  OC_Block
//
//  Created by xyj on 2018/5/3.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZPersion.h"

struct __main_block_desc_0 {
    size_t reserved;
    size_t Block_size;
};

struct __block_impl {
    void *isa;
    int Flags;
    int Reserved;
    void *FuncPtr;
};

struct __main_block_impl_0 {
    struct __block_impl impl;
    struct __main_block_desc_0* Desc;
    NSString *name;
    int age;
};

int age_1 = 10;
static int height_1 = 10;

void (^block)(void);

void test()
{
    int age = 10;
    static int height = 10;
    NSString *name = @"小米";

    block = ^{
        // age的值捕获进来（capture）
        NSLog(@"age is %d, height is %d, name is %@", age, height, name);
    };

    age = 20;
    height = 20;
    name = @"大米";
}
//
void claTest()
{
    // __NSGlobalBlock__ : __NSGlobalBlock : NSBlock : NSObject
    void (^block3)(void) = ^{
        NSLog(@"Hello");
    };

    NSLog(@"%@", [block3 class]);
    NSLog(@"%@", [[block3 class] superclass]);
    NSLog(@"%@", [[[block3 class] superclass] superclass]);
    NSLog(@"%@", [[[[block3 class] superclass] superclass] superclass]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        ^{
            NSLog(@"this is a block!");
            NSLog(@"this is a block!");
            NSLog(@"this is a block!");
            NSLog(@"this is a block!");
        }();
        
        int age = 20;
        
        NSString *name = @"lihua";

        void (^block1)(int, int) =  ^(int a , int b){
//            NSLog(@"this is a block! -- %d", age);
//            NSLog(@"this is a block! -- %@", name);
            NSLog(@"this is a block! -- %d", age_1);
            NSLog(@"this is a block!");
        };

        struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)block1;

        age = 10;
        name = @"xiaoming";


        block1(10, 10);


        test();
        block();


        void (^block2)(void) = ^{
            NSLog(@"age is %d, height is %d", age_1, height_1);
        };

        age_1 = 120;
        height_1 = 120;

        block2();

        claTest();
        
        
        XZPersion *ps = [[XZPersion alloc] initWithName:@"小白"];
        [ps test];
    }
    return 0;
}

