## 进程和线程

进程（process）：计算机已经运行的程序，是操作系统管理程序的一种方式； 

线程（thread）：操作系统能够运行运算调度的最小单位，通常情况下它被包含在进程中；

## 浏览器中的JavaScript线程

JavaScript是单线程的，但是JavaScript的线程应该有自己的容器进程：浏览器或者Node。

浏览器是一个进程吗，它里面只有一个线程吗？

- 目前多数的浏览器其实都是多进程的，当我们打开一个tab页面时就会开启一个新的进程，这是为了防止一个页 面卡死而造成所有页面无法响应，整个浏览器需要强制退出； 
- 每个进程中又有很多的线程，其中包括执行JavaScript代码的线程；

JavaScript的代码执行是在一个单独的线程中执行的：

- 这就意味着JavaScript的代码，在同一个时刻只能做一件事； 
- 如果这件事是非常耗时的，就意味着当前的线程就会被阻塞；

所以真正耗时的操作，实际上并不是由JavaScript线程在执行的：

- 浏览器的每个进程是多线程的，那么其他线程可以来完成这个耗时的操作； 
- 比如网络请求、定时器，我们只需要在特性的时候执行应该有的回调即可；

## 浏览器中宏任务和微任务

事件循环中并非只维护着一个队列，事实上是有两个队列：

- 宏任务队列（macrotask queue）：ajax、setTimeout、setInterval、DOM监听、UI Rendering等 
- 微任务队列（microtask queue）：Promise的then回调、 Mutation Observer API、queueMicrotask()等

那么事件循环对于两个队列的优先级是怎么样的呢？

1. main script中的代码优先执行（编写的顶层script代码）； 
2. 在执行任何一个宏任务之前（不是队列，是一个宏任务），都会先查看微任务队列中是否有任务需要执行
   1. 也就是宏任务执行之前，必须保证微任务队列是空的；
   2. 如果不为空，那么就优先执行微任务队列中的任务（回调）；

## Node 事件循环EventLoop

浏览器中的EventLoop是根据HTML5定义的规范来实现的，不同的浏览器可能会有不同的实现，而Node中是由 libuv实现的。

事件循环像是一个桥梁，是连接着应用程序的JavaScript和系统调用之间的通道：

- 无论是我们的文件IO、数据库、网络IO、定时器、子进程，在完成对应的操作后，都会将对应的结果和回调函 数放到事件循环（任务队列）中； 
- 事件循环会不断的从任务队列中取出对应的事件（回调函数）来执行；

一次完整的事件循环Tick分成很多个阶段：

1. 定时器（Timers）：本阶段执行已经被 setTimeout() 和 setInterval() 的调度回调函数。 
2. 待定回调（Pending Callback）：对某些系统操作（如TCP错误类型）执行回调，比如TCP连接时接收到 ECONNREFUSED。 
3. idle, prepare：仅系统内部使用。 
4. 轮询（Poll）：检索新的 I/O 事件；执行与 I/O 相关的回调； 
5. 检测（check）：setImmediate() 回调函数在这里执行。 
6. 关闭的回调函数：一些关闭的回调函数，如：socket.on('close', ...)。

### Node的宏任务和微任务

Node的事件循环更复杂，它也分为微任务和宏任务： 

- 宏任务（macrotask）：setTimeout、setInterval、IO事件、setImmediate、close事件； 
- 微任务（microtask）：Promise的then回调、process.nextTick、queueMicrotask； n 

但是，Node中的事件循环不只是 微任务队列和 宏任务队列： 

- 微任务队列： 
  - next tick queue：process.nextTick； 
  - other queue：Promise的then回调、queueMicrotask； 
- 宏任务队列： 
  - timer queue：setTimeout、setInterval； 
  - poll queue：IO事件； 
  - check queue：setImmediate； 
  - close queue：close事件；

### Node事件循环的顺序

在每一次事件循环的tick中，会按照如下顺序来执行代码：

1. next tick microtask queue； 
2. other microtask queue； 
3. timer queue； 
4. poll queue； 
5. check queue； 
6. close queue；

