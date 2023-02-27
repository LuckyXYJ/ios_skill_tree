## Module(模块)

Module(模块)-最小的代码单元。一个Module是机器代码和数据的最小单位，可以独立于其他代码单位进行链接。通常，Module是通过编译单个源文件生成的目标文件。

在静态链接的时候，也就是静态库链接到主项目或者动态库时，最后生成可执行文件或者动态库时。静态链接器可以把多个Module链接优化成一个，来减少本来多个Module直接调用的问题。

module.modulemap 用来描述头文件与module之间映射的关系

module生成命令

```
# -fmodules：允许使用module语言来表示头文件
# -fmodule-map-file：module map的路径。如不指明默认module.modulemap
# -fmodules-cache-path：编译后的module缓存路径
clang  -fmodules -fmodule-map-file=Cat.modulemap -fmodules-cache-path=../prebuilt -c use.c -o use.o
```

## module.modulemap文件

```
module Charts {
  umbrella header "Charts-umbrella.h"

  export *
  module * { export * }
}
```

- module:定义一个module 
- export：导出当前代表的头文件使用的头文件
- export * ：匹配目录下所有的头文件 
- module * ：目录下所有的头文件都当作一个子module
- explicit : 显式声明一个module的名称

## swift库使用OC代码

在项目中swift使用OC代码通过桥联文件即可，但是在swift中却无法使用桥联文件

解决方案：

1. oc的头文件放到modulemap下
2. oc的头文件放到私有的modulemap下
3. 协议的方式 投机取巧

## Swift静态库的合并

难点：.swiftmodule 文件（Swift的头文件）

1. libtool 合并静态库本身
2. 用到的头文件和Swift头文件和modulemap文件通过目录的形式放到一起、
3. OC要用合并的静态库：clang: other c flags ：-fmodule-map-file <modulemap path>
4. Swift要用合并的静态库 : SwiftC :other swift flags 显式告诉SwiftC <modulemap dir>

## OC映射到Swift方式

1. 宏
2. <工程名称>.
3. 文件