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

### 5、iOS动态库与静态库

1. 什么是库文件，iOS库文件有哪几种类型？.a、.dylib、.framework、.xcframework、.tbd、.swiftmodule
2. xcframework文件与framework文件相比有什么优势？
3. .tdb文件主要是用来做什么的？减少Xcode工程占用的空间⼤⼩
4. 什么是静态库，什么是动态库？有什么区别？

### 6、iOS编译命令

1. 创建静态库，创建静态库
2. ar命令。压缩与解压缩静态库
3. 合并静态库
4. install_name_tool命令，主要用来修改动态库rpath
5. 编译优化设置。release选择-Os,平衡代码⼤⼩和编译性能

### 7、多架构合并

1. 从模拟器包中分离出x86-64？
2. 合并SYTimer-x86_64 和 iOS包（arm64）
3. 合并xcframework

### 8、链接静态库.a生成可执行文件

1. 静态库冲突如何解决

### 9、链接动态库.dylib生成可执行文件

1. 如何修改install_name或者生产dylib时指定install_name

### 10、静动态库相互链接

1. 动-动，动-静，静-动，静-静
2. 动动情况下，反向依赖情况，编译时动态库找不到符号怎么处理？通过 -U <符号 >，来指定⼀个符号的是动态查找符号。
3. 动动情况下，app跨库使用符号？ reexport_framework 或者 -reexport_l 重新将动态库B 通过动态库A导出给app
4. 动静如何隐藏静态库的符号？通过 `-hidden-l<libraryname>`隐藏静态库的全局符号。
5. 静静情况，app并不知道静态库B 的位置和名称。
   1. 通过cocoapods将静态库 B 引入到app中
   2. ⼿动配置静态库B 的位置和名称
6. 静动情况，动态库B的默认路径？动态库B的路径 = App的rpath + 动态库B的install_name
   1. 通过Cocoapods将动态库B 引⼊到App内：
   2. 配置app的rpath，并通过脚本将动态库B引入到app内

### 11、module,apinotes文件及swift库

1. 什么是module文件，如何生成？
2. module.modulemap文件用来做什么？文件格式怎样？module.modulemap 用来描述头文件与module之间映射的关系
3. swift库使用OC代码的方式？modulemap，协议
4. OC映射到Swift方式

### 12、iOS事件传递

