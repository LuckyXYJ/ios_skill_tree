## 着色器渲染流程

[openGL官方渲染管线流程地址](https://www.khronos.org/opengl/wiki/Rendering_Pipeline_Overview)

以下是渲染管道的图表。蓝色框是可编程着色器阶段

![image-20220708160828123](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220708160828123.png)

## OpenGL 渲染架构

OpenGL API 给顶点着色器，片元着色器传递参数架构图如下

![image-20220714102321393](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220714102321393.png)

**Client：**是指常见的iOS代码和OpenGL API方法，这部分是在CPU中运行

**Server：**是指OpenGL底层的渲染等处理，是运行在GPU中的

![image-20220714104853016](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220714104853016.png)

**架构分析**

- 客户端中通过iOS代码调用OpenGL API中的方法，将图形渲染的相关数据通过通道传递到服务器中顶点着色器和片元着色器，并交由GPU处理。
- 服务端通过与客户端的通道接收传递的数据，并交由相应着色器进行渲染处理，并将最终的结果渲染到屏幕上

**数据传递通道**

- **Attributes**经常发生变化的数据：纹理坐标，光照法线，顶点坐标，颜色数据
- **Uniforms**不经常发生变动的数据
- **Texture Data** 纹理数据

其中Attributes只能传递给顶点着色器。可以通过顶点着色器间接传递给片元着色器

Texture Data传递的是纹理数据，纹理的处理的逻辑主要是在片元着色器中进行的。

