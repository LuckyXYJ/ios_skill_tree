//
//  main.m
//  OC_Block
//
//  Created by xyj on 2018/5/3.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

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
    int age;
};

int age_ = 10;
static int height_ = 10;


void (^block)(void);

void test()
{
    int age = 10;
    static int height = 10;
    
    block = ^{
        // age的值捕获进来（capture）
        NSLog(@"age is %d, height is %d", age, height);
    };
    
    age = 20;
    height = 20;
}

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
//        ^{
//            NSLog(@"this is a block!");
//            NSLog(@"this is a block!");
//            NSLog(@"this is a block!");
//            NSLog(@"this is a block!");
//        }();
        
        int age = 20;
        
        void (^block1)(int, int) =  ^(int a , int b){
            NSLog(@"this is a block! -- %d", age);
            NSLog(@"this is a block!");
            NSLog(@"this is a block!");
            NSLog(@"this is a block!");
        };
        
        
        
        struct __main_block_impl_0 *blockStruct = (__bridge struct __main_block_impl_0 *)block1;
        
        
        
        block1(10, 10);
        
        
        test();
        block();
        
        
        void (^block2)(void) = ^{
            NSLog(@"age is %d, height is %d", age_, height_);
        };

        age_ = 20;
        height_ = 20;

        block2();
        
        
        claTest();
    }
    return 0;
}

