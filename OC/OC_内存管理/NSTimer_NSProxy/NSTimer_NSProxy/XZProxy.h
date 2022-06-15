//
//  XZProxy.h
//  NSTimer_NSProxy
//
//  Created by xyj on 2018/8/9.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZProxy : NSProxy
+ (instancetype)proxyWithTarget:(id)target;
@property (weak, nonatomic) id target;
@end
