## OC 

### 1、OC之对象

1. 什么是内存对齐，内存对齐规则是什么样的？
2. 内存对齐计算` (x + (8-1)) & ~(8-1) ` 和 ` (x + (8-1)) >> 3 << 3 `
3. 结构体实际占用内存计算，系统给该结构体开辟空间内存大小计算，他们的区别是什么？
4. class_getInstanceSize , malloc_size, sizeof 区别？
5. instance对象，class对象，mate-class对象的区别与关系? 在内存中各自存储哪些信息
6. ` - (Class)class` ，` + (Class)class `，` object_getClass(id _Nullable obj)  ` 的区别
7. 怎么判断一个Class对象是否为meta-class？
8. isa指针和superClass指针分别是如何指向的？

### 2、OC之类原理 ，iOS 类与对象原理

1. 类对象的结构，isa，superclass，cache，bits。
2. 什么是联合体(共用体)，什么是位域，isa包含哪些信息，怎么获取isa指针地址
3. class_rw_t，class_ro_t分别包含哪些信息，为什么这么设计
4. method_t包含哪些信息，存储在什么位置，分类添加同名方法时会执行哪个
5. property 和 ivars有什么区别，为什么说分类不能添加属性
6. isKindOfClass 和 isMemberOfClass的区别
7. objc_getClass,object_getClass，objc_getMetaClass区别
8. 方法缓存cache_t是怎么存储的，hash计算与buckets扩容实现方式
9. new与alloc/init的区别？

### 3、OC分类Category原理

1. Category底层结构是怎么样的
2. 为什么说不能添加属性？
3. Category加载过程？同名方法如何处理？
4. load方法和initialize的区别？
5. 怎么添加成员变量？
6. 关联对象是如何存储的？
7. 分类和扩展的区别是什么？

### 4、OC中Block本质

1. block是什么？封装了函数以及函数调用环境的OC对象
2. block分为哪几种类型？有什么区别
3. block变量捕获有哪些情况？auto，static，
4. ARC，MRC情况下定义block使用的属性关键字有什么区别，为什么
5. ARC环境下，哪些情况编译器会根据情况自动将栈上的block复制到堆上
6. block内部为什么不能修改局部变量，__block为什么能？
7. ` __block`有什么限制？`__block`不能修饰全局变量、静态变量（static）
8. ` __weak, __strong`分别有什么作用

### 5、OC之KVO原理

1. 什么是KVO？KVO 是如何实现的
2. 不调用set的情况下如何触发KVO，直接用_ivar修改属性值是否触发KVO？
3. 重复添加观察者，重复移除观察者会发生什么现象？
4. ` automaticallyNotifiesObserversForKey:` 和 `keyPathsForValuesAffectingValueForKey:`分别有什么作用
5. AFURLRequestSerialization为什么要用automaticallyNotifiesObserversForKey关闭一些方法的自动KVO

### 6、OC之KVC原理

1. 什么事KVC，常见的API有哪些
2. ` setValue:forKey: `方法查找顺序是什么样的
3. ` valueForKey:`方法的查找顺序是什么样的
4. accessInstanceVariablesDirectly方法有什么作用

### 7、OC内存管理

1. OC中内存分区从低到高是怎么样的？保留区，代码段，数据段，堆，栈，内核区
2. 各个分区分吧存储哪些内容？
3. OC内存管理方案有哪些？ARC，MRC的区别，Tagged Pointer是什么?自动释放池又是什么
4. Tagged Pointer能够存储哪些类型，怎么区分iOS平台还是Mac平台
5. 引用计数存储在什么位置？
6. delloc方法会进行哪些操作？
7. SideTable是什么，能够存储哪些数据，数据结构是怎么样的？
8. 自动释放池的底层结构是什么样的，怎么实现的？
9. Runloop和自动释放池的关系？
10. Copy 和 mutableCopy的区别是什么？
11. 属性关键字有哪些？什么情况下用copy
12. Block，NSTimer循环引用区别与解决方案？
13. weakTable 弱引用表是怎么实现的

### 8、OC中Runtime原理与使用

1. 什么是Runtime，有什么作用？常用在什么地方
2. OC方法查找机制是怎么样的？有什么缺点？
3. objc_msgSend分为哪几个阶段？每个阶段具体做了些什么？
4. 方法cache是怎么做的？有什么好处
5. OC与Swift在方法调用上有什么区别？
6. 动态方法解析过程中关键方法是哪个？` resolveInstanceMethod:`
7. 消息转发过程关键方法有哪几个？` forwardInvocation:`，` methodSignatureForSelector:`，` forwardInvocation`
8. @dynamic的作用是什么？
9. super xxxx]中super有什么作用？
10. Runtime的API有哪些？

### 9、OC中Runloop原理与使用

1. 什么是Runloop？有什么作用？常用来做什么？
2. Runloop与线程之间的关系？
3. Runloop在内存中如何存储？key是线程
4. Runloop相关的类有哪些？
5. CFRunLoopModeRef是什么？有哪几种mode?
6. Source0/Source1/Timer/Observer是什么，与mode有什么关系？
7. CFRunLoopObserverRef包含哪几种状态？
8. 如何监听RunLoop的所有状态？
9. Runloop具体流程？
10. 用户态和内核态是什么？
11. 线程保活怎么做？

### 10、OC中多线程实现与线程安全

1. iOS多线程方案有哪些？如何选择？有什么区别？
2. 串行队列，并行队列的区别？全局队列和主队列呢？
3. 同步任务和异步任务的区别？
4. 使用sync函数往当前串行队列中添加任务会发生什么现象？
5. 异步并发执行任务1、任务2，等任务1、任务2都执行完毕后，再回到主线程执行任务3怎么实现？
6. Group，`dispatch_barrier_async`，`dispatch_semaphore`分别用来做什么？
7. 多线程安全问题有哪些？如何解决
8. 自旋锁和互斥锁的区别？递归锁，条件锁是什么？
9. atomic，noatomic的区别？
10. iOS读写安全方案有哪些？读写锁pthread_rwlock，栅栏函数
11. dispatch_barrier_async 如果传入的是一个串行或是一个全局的并发队列会发生什么现象？