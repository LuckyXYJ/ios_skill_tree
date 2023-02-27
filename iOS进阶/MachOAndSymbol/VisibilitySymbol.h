//
//  VisibilitySymbol.h
//  TestSymbol
//
//  Created by xyj on 2021/1/31.
//
// 符号可见性
// -O1 -Oz 生成目标文件
// 符号
// dead code strip 死代码剥离 链接
// strip 剥离符号 mach-o
// 

extern int hidden_y;
extern double default_y;
extern double protected_y;
