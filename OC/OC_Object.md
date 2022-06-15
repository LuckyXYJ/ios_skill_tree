## OC的本质
oc代码，底层是由c/c++实现

Objective-C的面向对象都是基于C\C++的数据结构实现的

![image-20220531152830996](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220531152830996.png)

可以将Objective-C代码转换为C\C++代码

```
xcrun  -sdk  iphoneos  clang  -arch  arm64  -rewrite-objc OC源文件 -o 输出的CPP文件
// 如果需要链接其他框架，使用-framework参数。比如-framework UIKit
```

## OC对象的本质

NSObject的底层实现

```
@interface NSObject <NSObject> {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"
    Class isa  OBJC_ISA_AVAILABILITY;
#pragma clang diagnostic pop
}

// 以上OC代码转为C++代码后，
struct NSObject_IMPL {
	Class isa;
};
```

```
@interface Person : NSObject
{
    @public
    int _age;
}
@property (nonatomic, assign) int height;
@end

// 以上OC代码转为C++代码后，
struct Person_IMPL {
	struct NSObject_IMPL NSObject_IVARS;
	int _age;
	int _height;
};

// Student
@interface Student : Person
{
    int _no;
//    int _sex;
}
@end
```

### 一个Person对象、一个Student对象占用多少内存空间？

Person 8+4+4

Student 16+4 = 20。内存对齐后占用2

```
// 创建一个实例对象，至少需要多少内存？
#import <objc/runtime.h>
class_getInstanceSize([NSObject class]);

// 创建一个实例对象，实际上分配了多少内存？
#import <malloc/malloc.h>
malloc_size((__bridge const void *)obj);
```



#### 内存对齐

1、数据成员对⻬规则：每个数据成员存储的起始位置要从该成员大小或者成员的子成员大小的整数倍开始

2、结构体作为成员：如果一个结构里有某些结构体成员,则结构体成员要从其内部最大元素大小的整数倍地址开始存储.

3、结构体的总⼤⼩,也就是sizeof的结果,.必须是其内部最⼤成员的整数倍.不⾜的要补⻬

(x + (8-1)) & ~(8-1)

(x + (8-1)) >> 3 << 3

#### 结构体内存

结构体指针大小 8
结构体大小 根据结构体内部数据计算
结构体的总大小,也就是sizeof的结果,必须是其内部最大成员的整数倍.不足的要补⻬

#### 内存占用也可以通过以下方式查看

Debug -> Debug Workfllow -> View Memory （Shift + Command + M）

## OC对象的分类

Objective-C中的对象，简称OC对象，主要可以分为3种

- instance对象（实例对象）
- class对象（类对象）
- meta-class对象（元类对象） 

### instance对象

![image-20220531175925368](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220531175925368.png)

object1、object2是NSObject的instance对象（实例对象）

它们是不同的两个对象，分别占据着两块不同的内存

instance对象就是通过类alloc出来的对象，每次调用alloc都会产生新的instance对象

instance对象在内存中存储的信息包括

- isa指针
- 其他成员变量

### class对象

![image-20220531175849847](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220531175849847.png)

nobjectClass1 ~ objectClass5都是NSObject的class对象（类对象）

每个类在内存中有且只有一个class对象

class对象在内存中存储的信息主要包括

- isa指针
- superclass指针
- 类的属性信息（@property）、
- 类的对象方法信息（instance method）
- 类的协议信息（protocol）、
- 类的成员变量信息（ivar）

### meta-class对象

![image-20220531180004913](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220531180004913.png)

objectMetaClass是NSObject的meta-class对象（元类对象）

每个类在内存中有且只有一个meta-class对象

meta-class对象和class对象的内存结构是一样的，但是用途不一样，在内存中存储的信息主要包括

- isa指针
- superclass指针
- 类的类方法信息（class method）
- ......

注意：以下代码获取的objectClass是class对象，并不是meta-class对象

```
Class objClass = [[NSObject class] class];
```

查看Class是否为meta-class

```
BOOL result = class_isMetaClass([NSObject class]);
```

## 对象内指针

![image-20220531220610504](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220531220610504.png)

### isa指针

instance的isa指向class

当调用对象方法时，通过instance的isa找到class，最后找到对象方法的实现进行调用

class的isa指向meta-class

当调用类方法时，通过class的isa找到meta-class，最后找到类方法的实现进行调用

从64bit开始，isa需要进行一次位运算，才能计算出真实地址

### class对象的superclass指针

当Student的instance对象要调用Person的对象方法时，会先通过isa找到Student的class，然后通过superclass找到Person的class，最后找到对象方法的实现进行调用

当Student的class要调用Person的类方法时，会先通过isa找到Student的meta-class，然后通过superclass找到Person的meta-class，最后找到类方法的实现进行调用
