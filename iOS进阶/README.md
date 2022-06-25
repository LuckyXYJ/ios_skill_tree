## iOS基础

### 1、iOS布局

1. iOS中布局方式有哪些？
2. 怎么通过NSLayoutConstraint给视图增加约束？constraintWithItem，constraintsWithVisualFormat
3. translatesAutoresizingMaskIntoConstraints和AutoresizingMask属性关系

### 2、Xcode 多环境配置

1. target，project，scheme分别是什么
2. 如何做多环境配置？target，Configuration，xcconfig文件
3. 手动配置和xcconfig文件优先级？
   1. 手动配置Target Build Setting
   2. Target中配置的xcconfig文件
   3. 手动配置Project Build Setting
   4. Project中配置的xcconfig文件
4. xcode常见宏有哪些？

### 3、iOS中符号

1. 什么是符号？
2. 符号表的种类？Symbol Table，String Table，Indirect Symbol Table
3. 符号区分？按存在空间划分，按照模块划分 ，功能划分
4. 什么是导⼊（Import）符号？导出（Export）符号？
5. strip命令是什么？间接符号不能删除？
6. Strip Style有哪几种选项？

### 4、Mach-O文件

1. mach-O文件是什么？.o文件是什么？
2. mach-O文件的格式是怎么样的？
3. 查看Mach-O文件信息的命令有哪些？
4. iOS生产Mach-O文件的过程
5. dyld加载流程