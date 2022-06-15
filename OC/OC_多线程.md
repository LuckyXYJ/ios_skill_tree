## iOS多线程方案

| **技术方案** | **简介**                                                     | **语言** | **线程生命周期** | **使用频率**                             |
| ------------ | ------------------------------------------------------------ | -------- | ---------------- | ---------------------------------------- |
| pthread      | 通用多线程API<br />适用于unix/linux/windows等系统<br />跨平台/可移植<br />使用难度大 | C        | 程序员管理       | 不用                                     |
| NSThread     | 使用更加面向对象<br />简单易用，可直接操作线程对象           | OC       | 程序员管理       | 偶尔使用<br /> - 线程保活<br /> - 定时器 |
| GCD          | 旨在替代NSThread<br />充分利用设备多核                       | C        | 自动管理         | 经常使用                                 |
| NSOperation  | 基于GCD<br />比GCD多了一些更简单实用的功能<br />使用更加面向对象 | OC       | 自动管理         | 经常使用                                 |

## GCD

### 同步：

` dispatch_sync(dispatch_queue_t queue, dispatch_block_t block);`

### 异步：

` dispatch_async(dispatch_queue_t queue, dispatch_block_t block);`

### 并发队列：

` dispatch_queue_t queue = dispatch_queue_create("myqueu2", DISPATCH_QUEUE_CONCURRENT);`

` dispatch_queue_t queue1 = dispatch_get_global_queue(intptr_t identifier, uintptr_t flags);; `

**全局队列**有默认有四个，根据第一个参数**identifier**可以获取不同的全局队列。**flags**留作将来使用。传递除0以外的任何值都可能导致返回值为NULL。

- \#define DISPATCH_QUEUE_PRIORITY_HIGH 2
- #define DISPATCH_QUEUE_PRIORITY_DEFAULT 0
- #define DISPATCH_QUEUE_PRIORITY_LOW (-2)
- #define DISPATCH_QUEUE_PRIORITY_BACKGROUND INT16_MIN

### 串行队列：

` dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL); `

` dispatch_queue_t queue1 = dispatch_get_main_queue(); `

**主队列是特殊的串行队列**

### 同步异步任务与并发串行队列

同步和异步主要影响：能不能开启新的线程

- 同步：在当前线程中执行任务，不具备开启新线程的能力
- 异步：在新的线程中执行任务，具备开启新线程的能力

并发和串行主要影响：任务的执行方式

- 并发：多个任务并发（同时）执行
- 串行：一个任务执行完毕后，再执行下一个任务

主队列是特殊的串行队列

|            | 并发队列                                 | 串行队列                                 | 主队列                                     |
| ---------- | ---------------------------------------- | ---------------------------------------- | ------------------------------------------ |
| 同步 sync  | **没有**开启新线程<br />**串行**执行任务 | **没有**开启新线程<br />**串行**执行任务 | **没有**开启新线程\|<br />**串行**执行任务 |
| 异步 async | **开启**新线程<br />**并发**执行任务     | **开启**新线程<br />**串行**执行任务     | **没有**开启新线程<br />**串行**执行任务   |

**使用sync函数往当前串行队列中添加任务，会卡住当前的串行队列（产生死锁）**

## 队列 组Group 的使用

异步并发执行任务1、任务2，等任务1、任务2都执行完毕后，再回到主线程执行任务3

![image-20220609094830991](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220609094830991.png)

## 栅栏函数 **dispatch_barrier_async**

这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的

如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果

![image-20220609100853125](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220609100853125.png)

## 信号量**dispatch_semaphore**

semaphore叫做”信号量”

信号量的初始值，可以用来控制线程并发访问的最大数量

信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步

![image-20220609101052133](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220609101052133.png)

## 多线程安全

1块资源可能会被多个线程共享，也就是**多个线程可能会访问同一块资源**，同一个对象、同一个变量、同一个文件

当多个线程访问同一块资源时，很容易引发**数据错乱和数据安全**问题

解决方案：使用线程**同步技术**，如：**加锁**

### OSSpinLock

OSSpinLock叫做”自旋锁”，等待锁的线程会处于**忙等**（busy-wait）状态，一直占用着CPU资源

目前已经**不再安全**，从iOS10开始不支持，可能会出现**优先级反转问题**。如果等待锁的线程优先级较高，它会一直占用着CPU资源，优先级低的线程就无法释放锁

需要导入头文件#import <libkern/OSAtomic.h>

```objective-c
// 初始化
OSSpinLock lock = OS_SPINLOCK_INIT;
// 尝试加锁，需要等待就不加锁，直接返回FALSE，不需要等待就加锁，返回true
bool res = OSSpinLockTry(&lock);
// 加锁
OSSpinLockLock(&lock);
// 解锁
OSSpinLockUnlock(&lock);
```

### os_unfair_lock

os_unfair_lock用于取代不安全的OSSpinLock ，从iOS10开始才支持

等待os_unfair_lock锁的线程会处于**休眠状态**，并非忙等

需要导入头文件#import <os/lock.h>

```objective-c
// 初始化
os_unfair_lock lock = OS_UNFAIR_LOCK_INIT;
// 尝试加锁
os_unfair_lock_trylock(&lock)
// 加锁
os_unfair_lock_lock(&lock);
// 解锁
os_unfair_lock_unlock(&lock);
```

### pthread_mutex

mutex叫做”互斥锁”，等待锁的线程会处于**休眠状态**

需要导入头文件#import <pthread.h>

pthread_mutex 锁类型

- #define PTHREAD_MUTEX_NORMAL		0
- #define PTHREAD_MUTEX_ERRORCHECK	1
- #define PTHREAD_MUTEX_RECURSIVE		2    递归锁
- #define PTHREAD_MUTEX_DEFAULT		PTHREAD_MUTEX_NORMAL

普通锁

```objective-c
// 初始化属性
pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr);
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);

// 初始化锁
pthread_mutex_t mutex;
pthread_mutex_init(&mutex, &attr);

// 尝试加锁
pthread_mutex_trylock(&mutex);

// 加锁
pthread_mutex_lock(&mutex);
    
// 解锁
pthread_mutex_unlock(&mutex);

// 销毁相关资源
pthread_mutexattr_destroy(&attr);
pthread_mutex_destroy(&mutex);

```

递归锁

```objective-c
// 初始化属性
pthread_mutexattr_t attr;
pthread_mutexattr_init(&attr);
pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE);

// 初始化锁
pthread_mutex_t mutex;
pthread_mutex_init(&mutex, &attr);
```

条件锁。等待进入休眠，放开mutex锁；被唤醒后，会再次对mutex加锁

```objective-c
// 初始化锁
pthread_mutex_t mutex;
// NULL代表使用默认属性
pthread_mutex_init(&mutex, NULL);

// 初始化条件
pthread_cond_t cond;
pthread_cond_init(&cond, NULL);

// 等待条件（进入休眠，放开mutex锁；被唤醒后，会再次对mutex加锁）
pthread_cond_wait(&cond, &mutex);

// 激活一个等待该条件的线程
pthread_cond_signal(&cond);

// 激活所有等待该条件的线程
pthread_cond_broadcast(&cond);

// 销毁资源
pthread_mutex_destroy(&mutex);
pthread_cond_destroy(&cond);
```

### dispatch_semaphore

semaphore叫做”信号量”

信号量的初始值，可以用来控制线程并发访问的最大数量

信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步

```objective-c
int value = 1;

dispatch_semaphore_t semaphore = dispatch_semaphore_create(value);

// 信号量值 <= 0，进入休眠等待，知道信号量 > 0
// 信号量 > 0, 就 - 1，然后往下执行后面的代码
dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

// 信号量值 + 1
dispatch_semaphore_signal(semaphore);
```



### dispatch_queue(DISPATCH_QUEUE_SERIAL)

GCD串行队列

```objective-c
dispatch_queue_t queue = dispatch_queue_create("lock", DISPATCH_QUEUE_SERIAL);
dispatch_sync(queue, ^{

});
```

### NSLock

NSLock是对mutex普通锁的封装，面向对象

```objective-c
@protocol NSLocking

- (void)lock;
- (void)unlock;

@end

@interface NSLock : NSObject <NSLocking> {
@private
    void *_priv;
}

- (BOOL)tryLock;
- (BOOL)lockBeforeDate:(NSDate *)limit;

@property (nullable, copy) NSString *name API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

@end
```

### NSRecursiveLock

NSRecursiveLock是对mutex递归锁的封装，API与NSLock基本一致

### NSCondition

NSCondition 是对 mutex条件锁的封装

```objective-c
@interface NSCondition : NSObject <NSLocking> {
@private
    void *_priv;
}

- (void)wait;
- (BOOL)waitUntilDate:(NSDate *)limit;
- (void)signal;
- (void)broadcast;

@property (nullable, copy) NSString *name API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

@end
```

### NSConditionLock

NSConditionLock是对NSCondition的进一步封装，可以设置具体的条件值

```objective-c
@interface NSConditionLock : NSObject <NSLocking> {
@private
    void *_priv;
}

- (instancetype)initWithCondition:(NSInteger)condition NS_DESIGNATED_INITIALIZER;

@property (readonly) NSInteger condition;
- (void)lockWhenCondition:(NSInteger)condition;
- (BOOL)tryLock;
- (BOOL)tryLockWhenCondition:(NSInteger)condition;
- (void)unlockWithCondition:(NSInteger)condition;
- (BOOL)lockBeforeDate:(NSDate *)limit;
- (BOOL)lockWhenCondition:(NSInteger)condition beforeDate:(NSDate *)limit;

@property (nullable, copy) NSString *name API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

@end
```

### @synchronized

@synchronized是对mutex递归锁的封装

@synchronized(obj)内部会生成obj对应的递归锁，然后进行加锁、解锁操作

```objective-c
@synchronized(obj) { // objc_sync_enter
		
}
```

## 线程同步方案对比

**性能**方面，性能从高到低排序

- os_unfair_lock
- OSSpinLock
- dispatch_semaphore
- pthread_mutex
- dispatch_queue(DISPATCH_QUEUE_SERIAL)
- NSLock
- NSCondition
- pthread_mutex(recursive)
- NSRecursiveLock
- NSConditionLock
- @synchronized

**如何选择？**

开发方便考虑 GCD信号量，串行线程。

面向对象考虑 NSLock，NSRecursiveLock，NSCondition，NSConditionLock 

追求性能考虑 os_unfair_lock

代码简单考虑 @synchronized

## 自旋锁互斥锁对比

什么情况使用自旋锁比较划算？

- 预计线程等待锁的时间很短
- 加锁的代码（临界区）经常被调用，但竞争情况很少发生
- CPU资源不紧张
- 多核处理器

什么情况使用互斥锁比较划算？

- 预计线程等待锁的时间较长
- 单核处理器
- 临界区有IO操作
- 临界区代码复杂或者循环量大
- 临界区竞争非常激烈

## atomic

atomic用于保证属性setter、getter的原子性操作，相当于在getter和setter内部加了线程同步的锁

可以参考源码objc4的objc-accessors.mm

它并不能保证使用属性的过程是线程安全的

## iOS读写安全方案

读写安全，需要多读单写。常见的方案有：

- pthread_rwlock：读写锁
- dispatch_barrier_async：异步栅栏调用

### pthread_rwlock

等待的线程会进入休眠

```objective-c
pthread_rwlock_t lock;
// 初始化锁
pthread_rwlock_init(&lock, NULL);

// 读 加锁
pthread_rwlock_rdlock(&lock);

// 读 尝试加锁
pthread_rwlock_tryrdlock(&lock);

// 写 加锁
pthread_rwlock_wrlock(&lock);

// 写 尝试加锁
pthread_rwlock_trywrlock(&lock);

// 解锁
pthread_rwlock_unlock(&lock);

// 销毁
pthread_rwlock_destroy(&_lock);

```

### dispatch_barrier_async

这个函数传入的并发队列必须是自己通过dispatch_queue_cretate创建的

如果传入的是一个串行或是一个全局的并发队列，那这个函数便等同于dispatch_async函数的效果

```objective-c
dispatch_queue_t queue = dispatch_queue_create("rw_queue", DISPATCH_QUEUE_CONCURRENT);

// 读
dispatch_async(queue, ^{
   
});
        
// 写
dispatch_barrier_async(queue, ^{

});
```

