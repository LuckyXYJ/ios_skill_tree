## LLVM

官网:https://llvm.org/

The LLVM Project is a collection of modular and reusable compiler and toolchain technologies.

LLVM项目是模块化、可重用的编译器以及工具链技术的集合

美国计算机协会 (ACM) 将其2012 年软件系统奖项颁给了LLVM，之前曾经获得此奖项的软件和技术包括:Java、Apache、 Mosaic、the World Wide Web、Smalltalk、UNIX、Eclipse等等

## 传统的编译器架构

![image-20220706141952910](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220706141952910.png)

## LLVM架构

![image-20220706142028626](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220706142028626.png)

不同的前端后端使用统一的中间代码LLVM Intermediate Representation (LLVM IR)

如果需要支持一种新的编程语言，那么只需要实现一个新的前端

如果需要支持一种新的硬件设备，那么只需要实现一个新的后端

优化阶段是一个通用的阶段，它针对的是统一的LLVM IR，不论是支持新的编程语言，还是支持新的硬件设备，都不需要对优化阶段做修改

相比之下，GCC的前端和后端没分得太开，前端后端耦合在了一起。所以GCC为了支持一门新的语言，或者为了支持一个新的目标平台，就 变得特别困难

LLVM现在被作为实现各种静态和运行时编译语言的通用基础结构(GCC家族、Java、.NET、Python、Ruby、Scheme、Haskell、D等) 	

## Clang

LLVM项目的一个子项目

基于LLVM架构的C/C++/Objective-C编译器前端

官网:http://clang.llvm.org/

相比于GCC，Clang具有如下优点

- 编译速度快:在某些平台上，Clang的编译速度显著的快过GCC(Debug模式下编译OC速度比GGC快3倍)
- 占用内存小:Clang生成的AST所占用的内存是GCC的五分之一左右 
- 模块化设计:Clang采用基于库的模块化设计，易于 IDE 集成及其他用途的重用 
- 诊断信息可读性强:在编译过程中，Clang 创建并保留了大量详细的元数据 (metadata)，有利于调试和错误报告 
- 设计清晰简单，容易理解，易于扩展增强

## Clang与LLVM

![image-20220706142400456](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220706142400456.png)