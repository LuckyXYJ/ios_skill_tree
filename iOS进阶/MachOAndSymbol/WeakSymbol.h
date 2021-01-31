//
//  WeakSymbol.h
//  TestSymbol
//
//  Created by xyj on 2021/1/31.
//


// weak def
void weak_function(void)  __attribute__((weak));
// weak 本地符号
void weak_hidden_function(void) __attribute__((weak, visibility("hidden")));



