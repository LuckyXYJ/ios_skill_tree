## 隐藏⾯面消除 Hidden surface elimination

在绘制3D场景的时候,我们需要决定哪些部分是对观察者可见的,或者哪些部分是对观察者不可见的.对于不可见的部分,应该及早丢弃.例如在⼀个不透明的墙壁后,就不应该渲染.这种情况叫做”隐藏⾯面消除”(Hidden surface elimination).

在甜甜圈案例中，设置观察者到物体的距离，设置观察者到物体的距离，即**观察者动，物体不动**，并创建一个甜甜圈如下，在转到的时候出现了如下动图的问题。这便是隐藏⾯面消除产生的

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1028.png" alt="img" style="zoom: 27%;" /><img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1036.gif" alt="img" style="zoom: 25%;" />

为什么使用默认光源着色器会出现隐藏面消除？

- 是因为在默光源着色器中，在光源无法照射的部分会呈现黑色，被照射部分呈现红色，可以非常直观的通过肉眼看出谁是正面，谁是反面

使用平面着色器绘制甜甜圈，会出现隐藏面消除吗？

- 会出现，由于都是红色，因此没有办法区别谁是正面，谁是背面，所以导致肉眼无法察觉

## 油画算法

- 先绘制场景中的离观察者较远的物体,再绘制较近的物体.
- 例如下面的图例: 先绘制红色部分,再绘制⻩色部分,最后再绘制灰色部分,即可解决隐藏面消除的问题

![image-20220720141042992](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220720141042992.png)

油画算法的弊端：

- 看不到的面也在渲染，性能较低

- 使⽤油画算法,只要将场景按照物体距离观察者的距离远近排序,由远及近的绘制即可。远近相同的多个图形叠加在一起就无法处理

  ![image-20220720141409885](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220720141409885.png)

## 正背面剔除

OpenGL 可以做到检查所有正面朝向观察者的面,并渲染它们.从⽽丢弃背面朝向的⾯. 这样可以节约片元着⾊器的性能.

**正反面区分**：

- 正⾯: 按照逆时针顶点连接顺序的三角形⾯
- 背⾯: 按照顺时针顶点连接顺序的三角形⾯
- 用户指定哪种顺序为正面,

```
//mode参数为: GL_CW,GL_CCW,默认值:GL_CCW
void glFrontFace(GLenum mode);
```



**相关方法：**

- 开启正背面剔除
- 关闭正背面剔除
- 设置需要剔除的面(默认背面剔除)

```
//开启表面剔除 （默认背面剔除）
void glEnable(GL_CULL_FACE);

//关闭表面剔除（默认背面剔除）
void glDisable(GL_CULL_FACE);

//GL_FRONT 正面
//GL_BACK 背面
//GL_FRONT_AND_BACK 正背面
//默认GL_BACK
void glCullFace(GLenum mode);

//例如,剔除正面实现(1)
glCullFace(GL_BACK); 
glFrontFace(GL_CW);
//例如,剔除正面实现(2) 
glCullFace(GL_FRONT);
```

