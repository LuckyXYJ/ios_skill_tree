//
//  WeakSymbol.m
//  TestSymbol
//
//  Created by xyj on 2021/1/31.
//

#import "WeakSymbol.h"
#import <Foundation/Foundation.h>
// 全局符号 -》导出符号
void weak_function(void) {
    NSLog(@"weak_function");
}

void weak_hidden_function(void) {
    NSLog(@"weak_hidden_function");
}
