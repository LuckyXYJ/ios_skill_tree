//
//  main.m
//  TestSymbol
//
//  Created by xyj on 2020/11/30.
//

#import <Foundation/Foundation.h>
#import "WeakImportSymbol.h"
//#import "XZOneObject.h"

// 全局变量
int global_uninit_value;


int global_init_value = 10;
double default_x __attribute__((visibility("hidden")));

// 静态变量 -> 本地变量
// 导入 导出
static int static_init_value = 9;
static int static_uninit_value;
void weak_function(void) {
    NSLog(@"weak_function");
}
// .o -》 虚拟 -〉NSLog
// 1. 汇编
// 2. 符号归类 -》 重定位符号表
// 3. 重定位符号表 -〉.m/.o 用到的API
// .o -> 链接 -> 一张表 -> exec
// 链接 -》 处理目标文件符号
int main(int argc, char *argv[]) {
    static_uninit_value = 10;
    // 导入了NSLog
    // Foundation 导出了 NSLog
    // 动态库 -> 符号
    // 间接符号表 -> 动态库符号
    
    // 间接符号表
    // oc动态库 -> 体积 ->
    // re导出
    NSLog(@"%d", static_init_value);
    // API
    // 动态库 -》 weak引用
    if (weak_import_function) {
        weak_import_function();
    }
//    XZOneObject *one = [XZOneObject new];
//    [one testOneObject];
//    NSLog(@"%@", one);
  return 0;
}
// 动态库
// 全局符号 -》 导出符号 -〉strip 动态库 不是全局符号的符号
// App -> 本地 + 全局  = 间接符号表中的符号
// 静态库 = .o 合集 + 重定位符号表 = .o 合集 调试符号
// tdb
// App -》静态库 -〉 App -》strip -〉 间接符号表
// App -》动态库 -〉 App -》 间接符号表 strip -〉 动态库
// dead strip
