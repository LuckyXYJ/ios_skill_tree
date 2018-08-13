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



## Tagged Pointer

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

## OC对象内存管理

在iOS中，使用**引用计数**来管理OC对象的内存

一个新创建的OC对象引用计数默认是1，当引用计数减为0，OC对象就会销毁，释放其占用的内存空间

调用retain会让OC对象的引用计数+1，调用release会让OC对象的引用计数-1

内存管理的经验总结
当调用alloc、new、copy、mutableCopy方法返回了一个对象，在不需要这个对象时，要调用release或者autorelease来释放它
想拥有某个对象，就让它的引用计数+1；不想再拥有某个对象，就让它的引用计数-1

可以通过以下私有函数来查看自动释放池的情况
extern void _objc_autoreleasePoolPrint(void);

## Copy 和 mutableCopy

|                     | copy                 | mutableCopy                 |
| ------------------- | -------------------- | --------------------------- |
| NSString            | NSString  浅拷贝     | NSMutableString  深拷贝     |
| NSMutableString     | NSString  深拷贝     | NSMutableString  深拷贝     |
| NSArray             | NSArray  浅拷贝      | NSMutableArray  深拷贝      |
| NSMutableArray      | NSArray  深拷贝      | NSMutableArray  深拷贝      |
| NSDictionary        | NSDictionary  浅拷贝 | NSMutableDictionary  深拷贝 |
| NSMutableDictionary | NSDictionary  深拷贝 | NSMutableDictionary  深拷贝 |

