//
//  XYJPermenantThread1.h
//  runloop_PermenantThread
//
//  Created by xyj on 2018/6/13.
//  Copyright © 2018 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^XYJPermenantThreadTask)(void);

@interface XYJPermenantThread : NSObject

/**
 开启线程
 */
//- (void)run;

/**
 在当前子线程执行一个任务
 */
- (void)executeTask:(XYJPermenantThreadTask)task;

/**
 结束线程
 */
- (void)stop;

@end

