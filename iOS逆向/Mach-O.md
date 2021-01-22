## Mach-O

Mach-O是Mach object的缩写，是Mac/iOS上用于存储程序、库的标准格式

可以在**xun**的源码中找到Mach-O的定义，地址：https://opensource.apple.com/tarballs/xnu/

常见的**Mach-O**文件**类型**

- MH_OBJECT
  - 目标文件（.o）
  - 静态库文件(.a），静态库其实就是N个.o合并在一起
- MH_EXECUTE：可执行文件
  - .app/xx
- MH_DYLIB：动态库文件
  - .dylib
  - .framework/xx
- MH_DYLINKER：动态链接编辑器
  - /usr/lib/dyld
- MH_DSYM：存储着二进制文件符号信息的文件
  - .dSYM/Contents/Resources/DWARF/xx（常用于分析APP的崩溃信息）

## Mach-O的基本结构

一个Mach-O文件包含3个主要区域

1. Header : 文件类型、目标架构类型等
2. Load commands: 描述文件在虚拟内存中的逻辑结构、布局
3. Raw segment data :在Load commands中定义的Segment的原始数据

[Mach-O Programming Topics](https://developer.apple.com/library/content/documentation/DeveloperTools/Conceptual/MachOTopics/0-Introduction/introduction.html)

## 查看Mach-O的结构

- 命令行工具
  - file：查看Mach-O的文件类型`file  文件路径`
- otool：查看Mach-O特定部分和段的内容
- lipo：常用于多架构Mach-O文件的处理
  - 查看架构信息：`lipo  -info  文件路径`
  - 导出某种特定架构：`lipo  文件路径  -thin  架构类型  -output  输出文件路径`
  - 合并多种架构：`lipo  文件路径1  文件路径2  -output  输出文件路径`
- GUI工具
  - MachOView（https://github.com/gdbinit/MachOView）

## Universal Binary（通用二进制文件）


同时适用于多种架构的二进制文件

包含了多种不同架构的独立的二进制文件

因为需要储存多种架构的代码，通用二进制文件通常比单一平台二进制的程序要**大**

由于两种架构有共同的一些资源，所以并不会达到单一版本的两倍之多

由于执行过程中，只调用一部分代码，运行起来**也不需要额外的内存**

因为文件比原来的要大，也被称为“**胖二进制文件**”（Fat Binary）

## dyld和Mach-O

dyld用于加载以下类型的Mach-O文件;

- MH_EXECUTE
- MH_DYLIB
- MH_BUNDLE

APP的可执行文件、动态库都是由dyld负责加载的







