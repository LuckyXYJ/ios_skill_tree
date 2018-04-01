# OC
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
```

### 一个Person对象、一个Student对象占用多少内存空间？

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

### OC对象的分类

Objective-C中的对象，简称OC对象，主要可以分为3种

- instance对象（实例对象）
- class对象（类对象）
- meta-class对象（元类对象） 

