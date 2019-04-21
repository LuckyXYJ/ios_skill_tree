## OpenGL ES

OpenGL ES (OpenGL for Embedded Systems)是以⼿持和嵌入式为⽬标的⾼级3D图形应用程序编程接⼝

OpenGL ES是OpenGL的简化版本，它消除了冗余功能，提供了一个既易于学习⼜更易于在移动图形硬件中实现的库

![image-20220802134528263](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220802134528263.png)

OpenGL ES允许应⽤程序利用**底层图形处理器**的强⼤功能。iOS设备上的GPU可以执行复杂的2D和3D绘图，以及最终图像中每个像素的复杂着色计算

OpenGL ES 命令需要**渲染上下⽂**和**绘制表面**才能完成图形图像的绘制

渲染上下文: 存储相关OpenGL ES 状态.

绘制表⾯: 是⽤于绘制图元的表面,它指定渲染所需要的缓存区类型,例如颜⾊缓存区,深度缓冲区和模板缓存区.

### EGL (Embedded Graphics Library )

OpenGL ES API 并没有提供如何创建渲染上下文或者上下⽂如何连接到原⽣窗口系统. EGL 是Khronos 渲染API(如OpenGL ES) 和原生窗⼝系统之间的接口. 唯⼀支持 OpenGL ES 却不支持EGL 的平台是iOS. Apple 提供⾃己的EGL API的iOS实现,称为**EAGL**.

因为每个窗⼝系统都有不同的定义,所以EGL提供基本的不透明类型—EGLDisplay, 这个类型封装了所有系统相关性,⽤于和原生窗口系统接⼝.

EGL的主要功能：

1. 和本地窗口系统(native windowing system)通讯;
2. 查询可用的配置;
3. 创建OpenGL ES可用的“绘图表面”(drawing surface);
4. 同步不同类别的API之间的渲染，⽐如在OpenGL ES和OpenVG之间同步，或者在OpenGL和本地窗口的绘图命令之间
5. 管理“渲染资源”，⽐如纹理映射(rendering map)。

### OpenGLES 错误处理

如果不正确使⽤OpenGL ES 命令,应⽤程序就会产⽣一个错误编码. 这个错误编码将被记录,可以用glGetError查询. 在应⽤程序用glGetError查询第⼀个错误代码之前,不会记录其他错误代码. 一旦查询到错误代码,当前错误代码便复位为GL_NO_ERROR

| 错误代码 | 描述 |
| ---- | ---- |
| GL_NO_ERROR | 从上⼀次调用glGetError 以来没有生成任何错误 |
| GL_INVALID_ENUM | GLenum 参数超出范围，忽略生成错误命令 |
| GL_INVALID_VALUE | 数值型 参数超出范围，忽略生成错误命令 |
| GL_INVALID_OPERATION | 特定命令在当前OpenGL ES 状态⽆法执⾏ |
| GL_OUT_OF_MEMORY | 内存不⾜时执⾏该命令,如果遇到这个错误,除⾮当前错误代码,否则OpenGL ES 管线的状态被认为未定义 |



## OpenGL ES 3.0图形管线

![image-20220802135104291](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220802135104291.png)

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/677.png)

## 顶点着色器

顶点着色器输入：

1. 着⾊器程序----描述顶点上执⾏操作的顶点着⾊器程序源代码/可执行⽂件 
2. 顶点着色器输入(属性) ---- ⽤顶点数组提供每个顶点的数据 
3. 统⼀变量(uniform) ---- 顶点/⽚元着⾊器使⽤的不变数据
4. 采样器 ---- 代表顶点着⾊器使用纹理的特殊统⼀变量类型.

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1200.png)

顶点着色器业务：

1. 矩阵变换位置
2. 计算光照公式生成逐顶点颜色
3. 生成/变换纹理坐标

总结: 顶点着色器可以用于执行⾃定义计算,实施新的变换,照明或者传统的固定功能所不允许的基于顶点的效果.

顶点着色器代码：

```
/*
  示例说明：
  顶点着色器取得一个位置及相关的颜色数据作为输人属性，
  用一个4x4矩阵变换位置，
  并输出变换后的位置和颜色。
*/

/* matrix to convert a_ position 
  from model space
  to normalized device space
*/
uniform mat4 u_mvpMatrix; 

// attributes input to the vertex shader
in vec4 a_position;    // position value
in vec4 a_color ;      // input vertex color

// output of the vertex shader - input to fragment
// shader
out vec4 v_color;  // output vertex color
void main()
{
  v_ color = a_color ;
  gl_Position = u_mvpMatrix * a_position;
}
```

## 图元装配

图元(Primitive): 点,线,三⻆形等.

图元装配: 将顶点数据计算成⼀个个图元.在这个阶段会执⾏裁剪、透视分割和 Viewport变换操作。

图元类型和顶点索确定将被渲染的单独图元。对于每个单独图元及其对应的顶点，图元装配阶段执⾏的操作包括: 将顶点着⾊器的输出值执行裁剪、透视分割、视⼝变换后进⼊光栅化阶段。

## 光栅化

这个阶段绘制对应的图元(点/线/三角形).

光栅化就是将图元转化成⼀组⼆维⽚段的过程.⽽这些转化的⽚段将由⽚元着⾊器处理。这些⼆维⽚段就是屏幕上可绘制的像素.

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1200-20220802142457833.png)

## 片元着色器

⽚元着⾊器/⽚段着⾊器 输⼊:

1. 着⾊器程序 ---- 描述⽚段上执⾏操作的片元着⾊器程序源代码/可执⾏文件 
2. 输⼊变量 ---- 光栅化单元⽤插值为每个⽚段⽣成的顶点着⾊器输出 
3. 统⼀变量(uniform) ---- 顶点/⽚元着色器使⽤的不变数据
4. 采样器 ---- 代表⽚元着⾊器使⽤纹理的特殊统⼀变量类型.

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1200-20220802143215216.png)

片元着色器业务：

1. 计算颜⾊
2. 获取纹理理值
3. 往像素点中填充颜⾊值(纹理值/颜色值);

总结: 它可以⽤于图片/视频/图形中每个像素的颜⾊填充(⽐如给视频添加滤镜,实际上就是将视频中每个图⽚的像素点颜⾊填充进行修改.)

片元着色器代码：

```
/*
  示例说明：
  描述了一个简单的片元着色器
*/
precision mediump float;
in vec4 v_color;  // input vertex color from vertex shader
out vec4 fragColor;  // output fragment color

void main ()
{
  fragColor = v_color;
}
```

## 逐片段操作

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1132.png)

**像素归属测试：**这个测试确定帧缓冲区中位置(Xw,Yw)的像素目前是不是归OpenGL ES所有。这个测试使窗口系统能够控制帧缓冲区中的哪些像素`属于当前OpenGL ES上下文`。例如，如果一个显示OpenGL ES帧缓冲区窗口的窗口被另一个窗口所遮蔽，则窗口系统可以确定被遮蔽的像素不属于OpenGL ES上下文，从而完成不显示这些像素。虽然像素回归测试是OpenGL ES的一部分，但是`它不由开发人员控制`，而是在OpenGL ES内部进行。

**裁剪测试：**裁剪测试确定(Xw,Yw)是否位于作为OpenGL ES状态的一部分裁剪矩形范围内。如果该片段位于裁剪区域之外，则被抛弃。

**模板和深度测试测试：**这些测试`在输入片段的模板和深度值上进行`，以确定片段是否应该被拒绝。

**混合：**混合将`新生成的片段颜色值`与保存在`帧缓冲区(Xw,Yw)位置`的颜色值`组合`起来。

**抖动：**抖动可用于最小化因为使用有限精度在帧缓冲区中保存颜色值而产生的伪像。

## OpenGL ES 动画

动画循环

![update_display_loop_2x.png](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/update_display_loop_2x.png)

显示器执行动画的应用程序流程

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/application_design_2x.png)

