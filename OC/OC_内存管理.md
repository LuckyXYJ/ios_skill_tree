## iOS内存布局

内存由低到高分别为：

- 保留
- 代码段
- 数据段
  - 常量区
  - 全局区
    - .bss，已初始化全局、静态变量
    - .data，未初始化全局、静态变量
- 堆
- 栈
- 内核区

**代码段**：编译后的代码

**数据段**：

- 字符串常量：比如NSString *str = @"123"
- 已初始化数据：已初始化的全局变量、静态变量等
- 未初始化数据：未初始化的全局变量、静态变量等

**栈**：函数调用开销，比如局部变量。分配的内存空间地址越来越小

**堆**：通过alloc、malloc、calloc等动态分配的空间，分配的内存空间地址越来越大

**内核区**：交给系统进行内核处理的区域

## OC对象内存管理

在iOS中，使用**引用计数**来管理OC对象的内存

一个新创建的OC对象引用计数默认是1，当引用计数减为0，OC对象就会销毁，释放其占用的内存空间

调用retain会让OC对象的引用计数+1，调用release会让OC对象的引用计数-1

内存管理的经验总结
当调用alloc、new、copy、mutableCopy方法返回了一个对象，在不需要这个对象时，要调用release或者autorelease来释放它
想拥有某个对象，就让它的引用计数+1；不想再拥有某个对象，就让它的引用计数-1

可以通过以下私有函数来查看自动释放池的情况
extern void _objc_autoreleasePoolPrint(void);

### Tagged Pointer

Tagged Pointer技术，用于优化NSNumber、NSDate、NSString等小对象的存储。将数据直接存储在了指针中

objc_msgSend能识别Tagged Pointer，比如NSNumber的intValue方法，直接从指针提取数据，节省了以前的调用开销

判断是否是tagged pointer，iOS平台，最高有效位是1（第64bit）,pMac平台，最低有效位是1

```
BOOL isTaggedPointer(id pointer)
{
    return (long)(__bridge void *)pointer & 1; // 在Mac上位（1UL << 63）
}
```

以下两块代码有什么区别？

```objective-c
// 代码1   EXC_BAD_ACCESS (code=1, address=0x66caa54d5420)
dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
for (int i = 0; i < 1000; i++) {
  dispatch_async(queue, ^{
  	self.name = [NSString stringWithFormat:@"abcdefghijk"];
  });
}

// 代码2
dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
for (int i = 0; i < 1000; i++) {
	dispatch_async(queue, ^{
		self.name = [NSString stringWithFormat:@"abc"];
	});
}
```

### 引用计数的存储

在64bit中，引用计数可以直接存储在优化过的isa指针中，也可能存储在SideTable类中

![image-20220612111616435](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220612111616435.png)

refcnts是一个存放着对象引用计数的散列表

#### delloc

当一个对象要释放时，会自动调用dealloc，接下的调用轨迹是

- dealloc
- _objc_rootDealloc
- rootDealloc
- object_dispose
- objc_destructInstance、free

![image-20220612111758693](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220612111758693.png)

### 自动释放池

自动释放池的主要底层数据结构是：__AtAutoreleasePool、AutoreleasePoolPage

调用了autorelease的对象最终都是通过AutoreleasePoolPage对象来管理的

源码分析：clang重写@autoreleasepool，objc4源码：NSObject.mm

![image-20220612111132711](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220612111132711.png)

每个AutoreleasePoolPage对象占用4096字节内存，除了用来存放它内部的成员变量，剩下的空间用来存放autorelease对象的地址

所有的AutoreleasePoolPage对象通过双向链表的形式连接在一起

![image-20220612111405594](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220612111405594.png)

调用push方法会将一个POOL_BOUNDARY入栈，并且返回其存放的内存地址

调用pop方法时传入一个POOL_BOUNDARY的内存地址，会从最后一个入栈的对象开始发送release消息，直到遇到这个POOL_BOUNDARY

id *next指向了下一个能存放autorelease对象地址的区域 

#### RunLoop 和 Autorelease

iOS在主线程的Runloop中注册了2个Observer

- 第1个Observer监听了kCFRunLoopEntry事件，会调用objc_autoreleasePoolPush()
- 第2个Observer
  - 监听了kCFRunLoopBeforeWaiting事件，会调用objc_autoreleasePoolPop()、objc_autoreleasePoolPush()
  - 监听了kCFRunLoopBeforeExit事件，会调用objc_autoreleasePoolPop()

## Copy 和 mutableCopy

 iOS提供了2个拷贝方法

 1.copy，不可变拷贝，产生不可变副本 

 2.mutableCopy，可变拷贝，产生可变副本

 深拷贝和浅拷贝

 1.深拷贝：内容拷贝，产生新的对象

 2.浅拷贝：指针拷贝，没有产生新的对象

|                     | copy                 | mutableCopy                 |
| ------------------- | -------------------- | --------------------------- |
| NSString            | NSString  浅拷贝     | NSMutableString  深拷贝     |
| NSMutableString     | NSString  深拷贝     | NSMutableString  深拷贝     |
| NSArray             | NSArray  浅拷贝      | NSMutableArray  深拷贝      |
| NSMutableArray      | NSArray  深拷贝      | NSMutableArray  深拷贝      |
| NSDictionary        | NSDictionary  浅拷贝 | NSMutableDictionary  深拷贝 |
| NSMutableDictionary | NSDictionary  深拷贝 | NSMutableDictionary  深拷贝 |

## Block，NSTimer循环引用区别与解决方案

block解决方案：
1、__block修饰，并在里面手动释放
2、unsafe_unretain
2、__weak 修饰

NSTimer:
1、在合适的时机手动停止NSTimer并置空，- (void)didMoveToParentViewController:(UIViewController *)parent
2、第三方中介者+方法交换，delloc中调用NSTimer释放和置空
3、自定义Timer作为第三方中介，内部常见NSTimer，原理同方法2
4、NSProxy作为第三方中介， 消息转发。

timer循环引用：self -> timer -> weakSelf -> self,当前的timer捕获的是B界面的内存，即vc对象的内存，即weakSelf表示的是vc对象

Block循环引用：self -> block -> weakSelf -> self，当前的block捕获的是指针地址，即weakSelf表示的是指向self的临时变量的指针地址

## ARC，MRC属性关键字

retain 
    引用计数+1,如果引用计数出现上溢出，那么我们开始分开存储，一半存到散列表
relase 
    引用计数-1,如果引用计数出现下溢出，就去散列表借来的引用计数 - 1,存到extra_rc release 就算借散列表的引用计数过来，还是下溢出，那么就调用dealloc
dealloc 
    根据当前对象的状态是否直接调用free()释放
    是否存在C++的析构函数、移除这个对象的关联属性
    将指向该对象的弱引用指针置为nil
    从弱引用表中擦除对该对象的引用计数
weak 
    首先我们知道有一个非常牛逼的家伙-sideTable
    得到sideTable的weakTable 弱引用表
    创建一个weak_entry_t
    把referent加入到weak_entry_t的数组inline_referrers
    把weak_table扩容一下
    把new_entry加入到weak_table中