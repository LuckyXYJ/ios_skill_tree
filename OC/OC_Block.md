## Block本质

block本质上也是一个OC对象，它内部也有个isa指针

block是封装了**函数调用**以及**函数调用环境**的**OC对象**

block的底层结构如下图所示

![image-20220601203643653](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601203643653.png)

## Block变量捕获

| **变量类型** | **捕获到block 内部** | **访问方式** |
| ------------ | ----------------------------- | ------------ |
| 局部auto变量 | √                         | 值传递         |
| 局部static变量 | √                             | 指针传递     |
| 全局变量     | ×                             | 直接访问     |

### Auto变量的捕获

![image-20220601204042313](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601204042313.png)

## block类型

block有3种类型，可以通过调用class方法或者isa指针查看具体类型，最终都是继承自NSBlock类型

```
__NSGlobalBlock__ （ _NSConcreteGlobalBlock ）

__NSStackBlock__ （ _NSConcreteStackBlock ）

__NSMallocBlock__ （ _NSConcreteMallocBlock ）
```

| **block ** **类型** | **环境**                    |
| ------------------- | --------------------------- |
| \_\_NSGlobalBlock__ | 没有访问auto变量            |
| \__NSStackBlock__   | 访问了auto变量              |
| \__NSMallocBlock__  | \__NSStackBlock__调用了copy |

每一种类型的block调用copy后的结果如下所示

![image-20220601205102084](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601205102084.png)

## Block 的copy

在ARC环境下，编译器会根据情况自动将栈上的block复制到堆上，比如以下情况

- block作为函数返回值时
- 将block赋值给__strong指针时
- block作为Cocoa API中方法名含有usingBlock的方法参数时
- block作为GCD API的方法参数时

MRC下block属性的建议写法

```
@property (copy, nonatomic) void (^block)(void);
```

ARC下block属性的建议写法

```
@property (strong, nonatomic) void (^block)(void);

@property (copy, nonatomic) void (^block)(void);
```

## 访问对象类型的auto变量

当block内部访问了对象类型的auto变量时

**如果block是在栈上**，将不会对auto变量产生强引用

**如果block被拷贝到堆上**

- 会调用block内部的copy函数
- copy函数内部会调用_Block_object_assign函数_
- Block_object_assign函数会根据auto变量的修饰符（\__strong、\__weak、__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用

**如果block从堆上移除**

- 会调用block内部的dispose函数
- dispose函数内部会调用_Block_object_dispose函数_
- Block_object_dispose函数会自动释放引用的auto变量（release）

![image-20220601205629873](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601205629873.png)

## __weak问题解决

在使用clang转换OC为C++代码时，可能会遇到以下问题

cannot create __weak reference in file using manual reference

解决方案：支持ARC、指定运行时系统版本，比如

xcrun -sdk iphoneos clang -arch arm64 -rewrite-objc -fobjc-arc -fobjc-runtime=ios-8.0.0 main.m

## __block修饰符

__block可以用于解决block内部无法修改auto变量值的问题

__block不能修饰全局变量、静态变量（static）

编译器会将__block变量包装成一个对象

![image-20220601205841942](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601205841942.png)

## __Block的内存管理

当block在栈上时，并不会对__block变量产生强引用

当block被**copy到堆时**

- 会调用block内部的copy函数
- copy函数内部会调用_Block_object_assign函数_
- Block_object_assign函数会对__block变量形成强引用（retain）

![image-20220601210012513](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601210012513.png)

当block**从堆中移除时**

- 会调用block内部的dispose函数
- dispose函数内部会调用_Block_object_dispose函数_
- Block_object_dispose函数会自动释放引用的__block变量（release）

![image-20220601224842718](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601224842718.png)

## block的forwarding指针

![image-20220601224935611](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601224935611.png)

## 对象类型的auto变量，__block变量

当block在**栈上**时，对它们都不会产生强引用

当block**拷贝到堆上**时，都会通过copy函数来处理它们

__block变量（假设变量名叫做a）

```
_Block_object_assign((void*)&dst->a, (void*)src->a, 8/*BLOCK_FIELD_IS_BYREF*/);
```

对象类型的auto变量（假设变量名叫做p）

```
_Block_object_assign((void*)&dst->p, (void*)src->p, 3/*BLOCK_FIELD_IS_OBJECT*/);
```

当block**从堆上移除**时，都会通过dispose函数来释放它们

__block变量（假设变量名叫做a）

```
_Block_object_dispose((void*)src->a, 8/*BLOCK_FIELD_IS_BYREF*/);
```

对象类型的auto变量（假设变量名叫做p）

```
_Block_object_dispose((void*)src->p, 3/*BLOCK_FIELD_IS_OBJECT*/);
```

## 被__block修饰的对象类型

当__block变量在栈上时，不会对指向的对象产生强引用

当__block变量被copy到堆时

- 会调用__block变量内部的copy函数_
- _copy函数内部会调用_Block_object_assign函数
- \_Block_object_assign函数会根据所指向对象的修饰符（ \__strong、\__weak、\__unsafe_unretained）做出相应的操作，形成强引用（retain）或者弱引用（注意：这里仅限于ARC时会retain，MRC时不会retain）

如果__block变量从堆上移除

- 会调用__block变量内部的dispose函数_
- _dispose函数内部会调用_Block_object_dispose函数
- _Block_object_dispose函数会自动释放指向的对象（release）

## 解决循环引用问题 - ARC

![image-20220601230342280](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601230342280.png)

## 解决循环引用问题 - MRC

![image-20220601230407473](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601230407473.png)

## \__weak, __strong作用

__weak typeof(self) wself = self;

__strong typeof(self) sself = wself;

__weak弱引用指针，避免循环引用

__strong避免在使用过程中，对象被销毁