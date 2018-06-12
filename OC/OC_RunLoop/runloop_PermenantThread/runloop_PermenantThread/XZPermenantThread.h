//
//  XZPermenantThread.h
//  runloop_PermenantThread
//
//  Created by xyj on 2018/6/11.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XZPermenantThreadTask)(void);

@interface XZPermenantThread : NSObject

/**
 开启线程
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(XZPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end
