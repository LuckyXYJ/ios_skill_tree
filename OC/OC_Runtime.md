## Runtime

OC是一门动态性比较强的编程语言，允许很多操作推迟到程序运行时再进行

OC的动态性就是由Runtime来支撑和实现的，Runtime是一套C语言的API，封装了很多动态性相关的函数

平时编写的OC代码，底层都是转换成了Runtime API进行调用

## isa指针

在arm64架构之前，isa就是一个普通的指针，存储着Class、Meta-Class对象的内存地址

从arm64架构开始，对isa进行了优化，变成了一个共用体（union）结构，还使用位域来存储更多的信息

![image-20220605101522274](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605101522274.png)

**nonpointer**

0，代表普通的指针，存储着Class、Meta-Class对象的内存地址；1，代表优化过，使用位域存储更多的信息

**has_assoc**

是否有设置过关联对象，如果没有，释放时会更快

**has_cxx_dtor**

是否有C++的析构函数（.cxx_destruct），如果没有，释放时会更快

**shiftcls**

存储着Class、Meta-Class对象的内存地址信息

**magic**

用于在调试时分辨对象是否未完成初始化

**weakly_referenced**

是否有被弱引用指向过，如果没有，释放时会更快

**deallocating**

对象是否正在释放

**extra_rc**

里面存储的值是引用计数器减1

**has_sidetable_rc**

引用计数器是否过大无法存储在isa中；如果为1，那么引用计数会存储在一个叫SideTable的类的属性中

## cache_t 方法缓存

Class内部结构中有个方法缓存（cache_t），用散列表（哈希表）来缓存曾经调用过的方法，可以提高方法的查找速度

![image-20220605103359536](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605103359536.png)

缓存查找

objc-cache.mm

bucket_t * cache_t::find(cache_key_t k, id receiver)

## objc_msgSend

OC中的方法调用，其实都是转换为objc_msgSend函数的调用

objc_msgSend的执行流程可以分为3大阶段

- 消息发送
- 动态方法解析
- 消息转发

## 消息发送

![image-20220605123625460](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605123625460.png)

如果是从class_rw_t中查找方法

- 已经排序的，二分查找
- 没有排序的，遍历查找

receiver通过**isa指针**找到receiverClass

receiverClass通过**superclass指针**找到superClass

## 动态方法解析

![image-20220605123907793](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605123907793.png)

开发者可以实现以下方法，来动态添加方法实现

- +resolveInstanceMethod:
- +resolveClassMethod:

动态解析过后，会重新走“消息发送”的流程

“从receiverClass的cache中查找方法”这一步开始执行