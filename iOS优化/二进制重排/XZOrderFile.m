//
//  XZOrderFile.m
//  xxxxxxxx
//
//  Created by xingzhe on 2021/4/10.
//  Copyright © 2021 cnabc. All rights reserved.
//

#import "XZOrderFile.h"
#include <stdint.h>
#include <stdio.h>
#include <sanitizer/coverage_interface.h>
#import <dlfcn.h>
#import <libkern/OSAtomic.h>

@implementation XZOrderFile



void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                                    uint32_t *stop) {
  static uint64_t N;  // Counter for the guards.
  if (start == stop || *start) return;  // Initialize only once.
  printf("INIT: %p %p\n", start, stop);
  for (uint32_t *x = start; x < stop; x++)
    *x = ++N;
}

static OSQueueHead symbolHead = OS_ATOMIC_QUEUE_INIT;

typedef struct{
    void *pc;
    void *next;
} SYMNode;

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {

    void *PC = __builtin_return_address(0);
    
    SYMNode * node = malloc(sizeof(SYMNode));
    *node = (SYMNode){PC,NULL};

    OSAtomicEnqueue(&symbolHead, node, offsetof(SYMNode, next));
}

+(void)creatOrderFile {
    //定义数组
    NSMutableArray *symbolNames = [NSMutableArray array];
    
    while (YES) {
       SYMNode * node = OSAtomicDequeue(&symbolHead, offsetof(SYMNode, next));
        if (node == NULL) {
            break;
        }
        Dl_info info = {0};
        dladdr(node->pc, &info);

        NSString * name = @(info.dli_sname);
        free(node);
        
        BOOL isObjc = [name hasPrefix:@"+["]||[name hasPrefix:@"-["];
        NSString * symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
        [symbolNames addObject:symbolName];
    }
    //反向数组
    NSEnumerator * enumerator = [symbolNames reverseObjectEnumerator];
    
    //创建一个新数组
    NSMutableArray * funcs = [NSMutableArray arrayWithCapacity:symbolNames.count];
    NSString * name;
    //去重!
    while (name = [enumerator nextObject]) {
        if (![funcs containsObject:name]) {//数组中不包含name
            [funcs addObject:name];
        }
    }
    [funcs removeObject:[NSString stringWithFormat:@"%s",__FUNCTION__]];
    //数组转成字符串
    NSString * funcStr = [funcs componentsJoinedByString:@"\n"];
    
    NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"xzOrder.order"];

    //文件内容
    NSData * fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    BOOL success = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
    
    NSLog(success?@"成功":@"失败");
}

@end
