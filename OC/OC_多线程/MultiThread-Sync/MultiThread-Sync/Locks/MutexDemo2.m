//
//  MutexDemo2.m
//  MultiThread-Sync
//
//  Created by xyj on 2018/7/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "MutexDemo2.h"
#import <pthread.h>

@interface MutexDemo2()
@property (assign, nonatomic) pthread_mutex_t mutex;
@end

@implementation MutexDemo2

- (void)__initMutex:(pthread_mutex_t *)mutex
{
    // 递归锁：允许同一个线程对一把锁进行重复加锁
    
    // 初始化属性
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr);
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);
    // 初始化锁
    pthread_mutex_init(mutex, &attr);
    // 销毁属性
    pthread_mutexattr_destroy(&attr);
}

- (instancetype)init
{
    if (self = [super init]) {
        [self __initMutex:&_mutex];
    }
    return self;
}

/**
 线程1：otherTest（+-）
        otherTest（+-）
         otherTest（+-）
 
 线程2：otherTest（等待）
 */

- (void)otherTest
{
    pthread_mutex_lock(&_mutex);
    
    NSLog(@"%s", __func__);
    
    static int count = 0;
    if (count < 10) {
        count++;
        [self otherTest];
    }
    
    pthread_mutex_unlock(&_mutex);
}

//- (void)otherTest2
//{
//    pthread_mutex_lock(&_mutex2);
//
//    NSLog(@"%s", __func__);
//
//    pthread_mutex_unlock(&_mutex2);
//}

- (void)dealloc
{
    pthread_mutex_destroy(&_mutex);
}

@end
