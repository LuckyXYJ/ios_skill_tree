## RunLoop

运行循环。在程序运行过程中循环做一些事情

作用：

- 保持程序的持续运行
- 处理App中的各种事件（比如触摸事件、定时器事件等）
- 节省CPU资源，提高程序性能：该做事时做事，该休息时休息
- ......

应用范畴:
- 定时器（Timer）、PerformSelector
- GCD Async Main Queue
- 事件响应、手势识别、界面刷新
- 网络请求
- AutoreleasePool

## RunLoop与线程

每条线程都有唯一的一个与之对应的RunLoop对象

RunLoop保存在一个全局的Dictionary里，线程作为key，RunLoop作为value

线程刚创建时并没有RunLoop对象，RunLoop会在第一次获取它时创建

RunLoop会在线程结束时销毁

主线程的RunLoop已经自动获取（创建），子线程默认没有开启RunLoop



