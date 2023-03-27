## RunLoop

运行循环。在程序运行过程中循环做一些事情

每一个 App 都会依附一个主线程 runloop，它就是一个不会停止的循环，App 底层会在这个循环里不停地对事件进行响应，处理源源不断的外部事件，从而响应最重要的用户操作。

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

## 获取RunLoop

```objective-c
// Foundation
[NSRunLoop currentRunLoop]; // 获得当前线程的RunLoop对象
[NSRunLoop mainRunLoop]; // 获得主线程的RunLoop对象

// Core Foundation	
CFRunLoopGetCurrent(); // 获得当前线程的RunLoop对象
CFRunLoopGetMain(); // 获得主线程的RunLoop对象
```

## RunLoop相关类

Core Foundation中关于RunLoop的5个类

- CFRunLoopRef
- CFRunLoopModeRef
- CFRunLoopSourceRef
- CFRunLoopTimerRef
- CFRunLoopObserverRef

![image-20220607203745744](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607203745744.png)

![image-20220607203712802](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607203712802.png)

![image-20220607203727018](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607203727018.png)

### CFRunLoopModeRef

- CFRunLoopModeRef代表RunLoop的运行模式
- 一个RunLoop包含若干个Mode，每个Mode又包含若干个Source0/Source1/Timer/Observer
- RunLoop启动时只能选择其中一个Mode，作为currentMode
- 如果需要切换Mode，只能退出当前Loop，再重新选择一个Mode进入
  - 不同组的Source0/Source1/Timer/Observer能分隔开来，互不影响
- 如果Mode里没有任何Source0/Source1/Timer/Observer，RunLoop会立马退出

常见的2种Mode

- kCFRunLoopDefaultMode（NSDefaultRunLoopMode）：App的默认Mode，通常主线程是在这个Mode下运
- UITrackingRunLoopMode：界面跟踪 Mode，用于 ScrollView 追踪触摸滑动，保证界面滑动时不受其他 Mode 影响

### CFRunLoopObserverRef

![image-20220607204418900](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607204418900.png)

### CFRunLoopSourceRef

Source0
触摸事件处理
performSelector:onThread:

Source1
基于Port的线程间通信
系统事件捕捉

### CFRunLoopTimerRef

Timers
NSTimer
performSelector:withObject:afterDelay:

### CFRunLoopObserverRef

Observers
用于监听RunLoop的状态
UI刷新（BeforeWaiting）
Autorelease pool（BeforeWaiting）



## 添加Observer监听RunLoop的所有状态

![image-20220607204546406](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607204546406.png)

## RunLoop的运行逻辑

![image-20220607204610636](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607204610636.png)

具体流程：

- 01、通知Observers：进入Loop
- 02、通知Observers：即将处理Timers
- 03、通知Observers：即将处理Sources
- 04、处理Blocks
- 05、处理Source0（可能会再次处理Blocks）
- 06、如果存在Source1，就跳转到第8步
- 07、通知Observers：开始休眠（等待消息唤醒）
- 08、通知Observers：结束休眠（被某个消息唤醒）
  - 01> 处理Timer
  - 02> 处理GCD Async To Main Queue
  - 03> 处理Source1
- 09、处理Blocks
- 10、根据前面的执行结果，决定如何操作
  - 01> 回到第02步
  - 02> 退出Loop
- 11、通知Observers：退出Loop

![image-20220607205420166](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607205420166.png)

## RunLoop休眠的实现原理

![image-20220607205450788](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220607205450788.png)

## RunLoop在实际开中的应用

- 控制线程生命周期（线程保活）
- 解决NSTimer在滑动时停止工作的问题
- 监控应用卡顿
- 性能优化

## 线程保活

```objective-c
/** XYJThread **/
@interface XYJThread : NSThread
@end
@implementation XYJThread
- (void)dealloc
{
    NSLog(@"%s", __func__);
}
@end

/** XYJPermenantThread **/
@interface XYJPermenantThread()
@property (strong, nonatomic) XYJThread *innerThread;
@end

@implementation XYJPermenantThread

#pragma mark - public methods
- (instancetype)init
{
    if (self = [super init]) {
        self.innerThread = [[XYJThread alloc] initWithBlock:^{
            // 创建上下文（要初始化一下结构体）
            CFRunLoopSourceContext context = {0};  
            // 创建source
            CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
            // 往Runloop中添加source
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
            // 销毁source
            CFRelease(source);
            // 启动
          	// 第3个参数：returnAfterSourceHandled，设置为true，代表执行完source后就会退出当前
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 1.0e10, false);
        }];
        
        [self.innerThread start];
    }
    return self;
}

- (void)executeTask:(XYJPermenantThreadTask)task {
    if (!self.innerThread || !task) return;
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

- (void)stop {
    if (!self.innerThread) return;
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc {
    [self stop];
}

#pragma mark - private methods
- (void)__stop {
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(XYJPermenantThreadTask)task {
    task();
}

@end

```



