## Metal

Metal 是苹果在2018年推出的图形编程接口，通过Metal相关API可以直接操作GPU，能最大限度的利用GPU能力。

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