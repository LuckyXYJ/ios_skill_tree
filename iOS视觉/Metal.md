## Metal

Metal 是苹果在2018年推出的图形编程接口，通过Metal相关API可以直接操作GPU，能最大限度的利用GPU能力。

UIKit --> Core Animation --> Metal --> GPU Drivel --> GPU

Metal 特点：

- 低CPU开销
- 最佳GPU性能，即metal 能在GPU上发挥最大的性能
- 最大限度的提高CPU/GPU 的并发性
- 有效的资源管理

Metal 图形管道

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1188.png)

## Metal 使用建议

- **Separate Your Rendering Loop** 分开渲染循环：不希望将渲染的处理放到VC中，希望将渲染循环封装在一个单独的类中
- **Respond to View Events** 响应视图的事件，即MTKViewDelegate协议，也需要放在自定义的渲染循环中
- **Metal Command Objects** 创建一个命令对象，即创建执行命令的GPU设备、MTLCommandQueue命令队列以及驱动GPU的MTCommandBuffer渲染缓存区

## Metal命令对象之间的关系

- 命令缓存区（command buffer）是从命令队列（command queue）创建的
- 命令编码器（command encoder）将命令编码到命令缓存区中
- 提交命令缓存区并将其发送到GPU
- GPU执行命令并将结果呈现为可绘制

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1200.png)

## Metal Kit 

Metal Kit 是基于Metal封装的框架， 方便我们用极少的代码完成 metal 需求

### MTKView

在MetalKit中提供了一个视图类**MTKView**，类似于GLKit中GLKView，它是NSView（macOS中的视图类）或者UIView（iOS、tvOS中的视图类）的子类。用于处理metal绘制并显示到屏幕过程中的细节。

### MTLDevice

由于metal是操作GPU的，所以需要获取GPU使用权限，即拿到GPU对象，Metal中提供了MTLDevice协议表示GPU接口，在iOS中一般是通过默认的方式MTLCreateSystemDefaultDevice()获取GPU

```objectivec
_view.device = MTLCreateSystemDefaultDevice();
```

- metal的使用必须使用真机，且必须是6s及以上的机型
- 如果设备不支持mental，将会返回空
- 如果想使用多个MTLDevice实例，或者从一个MTLDevice切换到另一个，则需要为每个MTLDevice创建单独的一组对象

MTLDevice协议表示可以执行命令的GPU，提供了如下功能

- 创建新的命令队列
- 从内存分配缓冲区
- 创建纹理
- 查询设备功能

### MTLCommandQueue

在获取了GPU后，还需要一个渲染队列，即[命令队列Command Queue](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FMiscellaneous%2FConceptual%2FMetalProgrammingGuide%2FCmd-Submiss%2FCmd-Submiss.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40014221-CH3-SW14)，类型是MTLCommandQueue，该队列是与GPU交互的第一个对象，队列中存储的是将要渲染的命令MTLCommandBuffer。

队列的获取需要通过**MTLDevice**对象获取，且每个命令队列的生命周期很长，因此commandQueue可以重复使用，而不是频繁创建和销毁。


```undefined
_commandQueue = [_device newCommandQueue];
```

在绘制之前，首先需要配置好MTKView、MTLDevice以及MTLCommandQueue后，其次是准备渲染到屏幕上的数据，即准备缓存数据MTLCommandBuffer，例如顶点数据等。

简单的渲染流程就是

- 先通过MTLCommandBuffer创建渲染缓存区，
- 其次通过MTLRenderPassDescriptor创建渲染描述符，
- 然后再通过创建的渲染缓存区和渲染描述符创建命令编辑器MTLRenderCommandEncoder进行编码
- 最后是结束编码，提交渲染命令，在完成渲染后，将命令缓存区提交至GPU

### MTLCommandBuffer

[命令缓存区 Command Buffer](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FMiscellaneous%2FConceptual%2FMetalProgrammingGuide%2FCmd-Submiss%2FCmd-Submiss.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40014221-CH3-SW15)主要是用于存储编码的命令，其生命周期是知道缓存区被提交到GPU执行为止，单个的命令缓存区可以包含不同的编码命令，主要取决于用于构建它的编码器的类型和数量。

命令缓存区的创建可以通过调用`MTLCommandQueue`的`commandBuffer`方法。且command buffer对象的提交只能提交至创建它的`MTLCommandQueue`对象中

commandBuffer在未提交命令缓存区之前，是不会开始执行的，提交后，命令缓存区将按其入队的顺序执行，commandBuffer的提交方式有以下两种，不同的提交方式表示不同的执行顺醋

- `enqueue`：顺序执行，enqueue方法在命令队列中为命令缓存区保留一个位置，此时并未提交命令缓存区，当最终提交命令缓存区后，按照命令队列的顺序依次执行
- `commit`：插队尽快执行，如果前面有commit还是需要排队等着

### MTLRenderCommandEncoder

[MTLRenderCommandEncoder](https://links.jianshu.com/go?to=https%3A%2F%2Fdeveloper.apple.com%2Flibrary%2Farchive%2Fdocumentation%2FMiscellaneous%2FConceptual%2FMetalProgrammingGuide%2FCmd-Submiss%2FCmd-Submiss.html%23%2F%2Fapple_ref%2Fdoc%2Fuid%2FTP40014221-CH3-SW14)表示单个渲染过程中相关联的渲染状态和渲染命令，有以下功能：

- 指定图形资源，例如缓存区和纹理对象，其中包含顶点、片元、纹理图片数据
- 指定一个MTLRenderPipelineState对象，表示编译的渲染状态，包含顶点着色器和片元着色器的编译&链接情况
- 指定固定功能，包括视口、三角形填充模式、剪刀矩形、深度、模板测试以及其他值
- 绘制3D图元

其中在创建commandEncoder之前，需要县创建渲染描述符`MTLRenderPassDescriptor`，渲染描述符通过`MTKView`的`currentRenderPassDescriptor`获取

```objectivec
MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
```

然后通过commandBuffer结合渲染描述符创建命令编辑器
```objectivec
id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
```
使用渲染命令编码器执行渲染的过程

- 过调用`MTLCommandBuffer`对象的`makeRenderCommandEncoder（descriptor :)`方法来创建`MTLRenderCommandEncoder`对象。
- 调用`setRenderPipelineState（_ :)`方法以指定`MTLRenderPipelineState`，该状态定义图形渲染管道的状态，包括顶点和片段函数。
- 指定用于顶点和片元函数输入和输出的资源，并在对应的参数中设置每个资源的位置（即索引），即将顶点数据等通过commandEncoder调用`setVertexBytes:length:atIndex:`函数传递到metal文件的顶点着色器和片元着色器函数
- 指定其他的固定功能状态，例如通过commandEncoder调用`setViewport:`函数设置视口大小等
- 绘制图形
- 调用`endEncoding（）`方法以终止渲染命令编码器。

## Metal 支持的采样器状态和默认值

![采样器状态和默认值](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220819163141761.png)
