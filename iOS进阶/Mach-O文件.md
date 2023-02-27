## Mach-O文件

mach-o是存储程序和库文件的文件格式，对应系统通过二进制接口ABI来运行该文件。保存了在编译和链接过程中产生的机器代码和数据，从而为静态链接和动态链接的代码提供了单一文件格式

mach-o = 文件配置 + 二进制代码

Mach-O 文件是可读可写的

![image-20221206152902873](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20221206152902873.png)

__TEXT段：只读区域 包含可执⾏代码和常量数据。

__DATA段：读/写 包含初始化和未初始化数据和⼀些动态链接专属数据。

### mach-o文件组成，有两部分：：header 和data。

- header：代表了⽂件的映射，描述了⽂件的内容以及⽂件所有内容所在的位置。包含三种类型。 Mach header，segment，sections
  - header内的section描述了对应的⼆进制信息。
  - Mach header属于header的⼀部分，它包含了整个⽂件的信息和segment信息。
  - Segments(segment commands): 指定操作系统应该将Segments加载到内存中的 什么位置，以及为该Segments分配的字节数。还指定⽂件中的哪些字节属于该 Segments，以及⽂件包含多少 sections。Mac上始终是4096字节或4 KB的倍 数，其中4096字节是最⼩⼤⼩。iOS上是8 KB。Segments名称的约定是使⽤全⼤ 写字⺟，后跟双下划线（例如__TEXT）。
  - 所有sections都在每个segment之后⼀个接⼀个地描述。sections⾥⾯定 义其名称，在内存中的地址，⼤⼩，⽂件中section数据的偏移量和segment名 称。Section的名称约定是使⽤全⼩写字⺟，再加上双下划线（例如__text）。
- data：紧跟header之后，由多个⼆进制组成

### 查看Mach-O文件信息命令

查看mach-header 

- objdump --macho -private-header ${MACH_PATH} //简单信息
- objdump --macho -private-headers ${MACH_PATH} //详细信息
- otool -h ${MACH_PATH} //简单信息
- otool -l ${MACH_PATH} //详细信息
- otool显示的是原始信息，不便阅读。objdump相对详细	

查看 __TEXT

- objdump --macho -d ${MACH_PATH}

查看符号表

- objdump --macho --syms ${MACH_PATH}

查看导出符号

- objdump --macho --exports-tire ${MACH_PATH}

查看间接符号表

- objdump --macho --indirect-symbols ${MACH_PATH}	

查看重定位符号表

- objdump --macho --reloc ${MACH_PATH}

### nm命令

```
nm -pa a.o
```

1. ` -a`: 显示符号表所有内容
2. ` -g`: 显示全局符号
3. ` -p`: 不排序，显示符号表本来的顺序
4. ` -r`: 逆转顺序
5. ` -u`: 显示未定义符号
6. ` -m`: 显示N_SECT类型的符号（Mach-O符号）

## 编译

iOS编译过程：

- 载入源文件，.h / .m / .cpp等
- 预处理：替换宏，删除注释，展开头文件，产生.i文件
- 编译：将.i文件转换为汇编语言，产生.s文件
- 汇编：将汇编文件转换为机器码文件，产生.o文件
- 链接：对.o文件中引用其他库的地方进行引用，生成最后的可执行文件。本质就是把多个⽬标⽂件组合成⼀个⽂件

## dyld加载流程

dyld（the dynamic link editor）是苹果的动态链接器，是苹果操作系统的重要组成部分，在app被编译打包成可执行文件格式的Mach-O文件后，交由dyld负责链接，加载程序

dyld链接流程：

1. 加载libSystem
2. Runtime向dyld注册回调函数
3. 加载新的image
4. 执行map_images、load_images
5. Imageloader加载image。回到 3、4，直至加载完全
6. 调用main函数



















