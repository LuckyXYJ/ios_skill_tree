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

` dispatch_queue_t queue1 = dispatch_get_global_queue(0, 0); `

### 串行队列：

` dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL); `

` dispatch_queue_t queue1 = dispatch_get_main_queue(); `

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