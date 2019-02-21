## 深度测试

### 深度

深度其实就是该像素点在3D世界中距离摄像机的距离,Z值

### 深度缓冲区

深度缓存区,就是⼀块内存区域,专⻔存储着每个像素点(绘制在屏幕上的)深度值.深度值(Z值)越⼤, 则离摄像机就越远.

只要存在深度缓冲区，**OpenGL**都会把像素的深度值写⼊到缓冲区中**.** 除⾮调用 `glDepthMask(GL_FALSE)`来禁⽌写⼊.

### 深度测试

在决定是否绘制⼀个物体表⾯时，⾸先要将表面对应的像素的深度值与当前深度缓冲区中的值进行比较，如果⼤于深度缓冲区中的值，则丢弃这部分。否则利⽤这个像素对应的深度值和颜⾊值，分别更更新深度缓冲区和颜⾊色缓存区。这个过程称为“深度测试”

### 深度测试的使用

1、开启深度测试

```
glEnable(GL_DEPTH_TEST);
```

2、在绘制场景前，清除颜⾊色缓存区，深度缓冲区

```
glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
```

3、指定深度测试判断模式

```
//指定深度测试判断模式
void glDepthFunc(GLEnum mode);
```

![image-20220720180520742](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220720180520742.png)

4、打开/阻断深度缓存区写入

```
void glDepthMask(GLBool value);
value : GL_TURE 开启深度缓冲区写⼊入; GL_FALSE 关闭深度缓冲区写⼊入
```

## ZFighting闪烁问题

显示出来的2个画面交错出现，交错闪烁的现象

![image-20220720200943685](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220720200943685.png)

![image-20220720200958730](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220720200958730.png)

### 原因：

开启深度测试后,OpenGL 就不会再去绘制模型被遮挡的部分. 这样实现的显示更加真实。但是由于深度缓冲区精度的限制对于深度相差⾮常⼩的情况下.(例如在同⼀平面上进⾏2次绘制),OpenGL 就可能出现不不能正确判断两者的深度值,会导致深度测试的结果不可预测.

### 解决方案：

多边形偏移（Polygon Offset）

### 问题预防：

- 不要将两个物体靠的太近，避免渲染时三角形叠在一起。这种方式要求对场景中物体插入一个少量的偏移，那么就可能避免ZFighting现象。例如上面的⽴方体和平面问题中，将平⾯下移0.001f就可以解决这个问题。当然手动去插入这个小的偏移是要付出代价的。
-  尽可能将近裁剪⾯设置得离观察者远⼀些。上⾯我们看到，在近裁剪平⾯附近，深度的精确度是很⾼的，因此尽可能让近裁剪面远⼀一些的话，会使整个裁剪范围内的精确度变⾼一些。但是这种⽅式会使离观察者较近的物体被裁减掉，因此需要调试好裁剪面参数。 
- 使⽤更高位数的深度缓冲区，通常使用的深度缓冲区是24位的，现在有⼀些硬件使⽤32位的缓冲区，使精确度得到提⾼

## 多边形偏移（Polygon Offset）

在执⾏深度测试前将⽴方体的深度值做⼀些细微的增加，使重叠的2个图形深度值之间有所区分

### 使用步骤：

1、启⽤Polygon Offset 方式 

```
glEnable(GL_POLYGON_OFFSET_FILL)
```

参数列列表: 

- GL_POLYGON_OFFSET_POINT 	对应光栅化模式: GL_POINT
- GL_POLYGON_OFFSET_LINE       对应光栅化模式: GL_LINE
- GL_POLYGON_OFFSET_FILL        对应光栅化模式: GL_FILL


2、指定偏移量

通过glPolygonOffset 来指定。glPolygonOffset 需要2个参数: factor , units 

每个Fragment 的深度值都会增加如下所示的偏移量量:

`Offset = ( m * factor ) + ( r * units);`

m : 多边形的深度的斜率的最⼤值，一个多边形越是与近裁剪面平行,m 就越接近于0.

r : 能产⽣于窗口坐标系的深度值中可分辨的差异最⼩值。r 是由OpenGL 平台指定的一个常量量.

⼀个大于0的Offset 会把模型推到离你(摄像机)更远的位置,相应的一个⼩于0的Offset会把模型拉近

一般⽽言,只需要将-1.0 和 -1 这样简单赋值给glPolygonOffset 基本可以满⾜足需求.

```
void glPolygonOffset(Glfloat factor,Glfloat units);

//应⽤用到⽚片段上总偏移计算⽅方程式:
Depth Offset = (DZ * factor) + (r * units); 

//DZ:深度值(Z值)
//r:使得深度缓冲区产⽣变化的最小值
//负值，将使得z值距离我们更近，⽽正值，将使得z值距离我们更远
```

3、关闭 Polygon Offset

```
glDisable(GL_POLYGON_OFFSET_FILL)
```

## 混合

当开启深度测试后，两个重叠的图层中，如果有一个图层是半透明的，另一个是非半透明，此时就不能通过深度值比较，来进行颜色值的覆盖，而是需要将两个颜色进行混合，然后存入颜色缓冲区。

混合函数经常用于实现在不透明的物体前⾯绘制⼀个透明物体的效果

### 目标颜色

已经存储在颜色缓存区的颜色值

### 源颜色

作为当前渲染命令结果进入颜色缓存区的颜色值

### 开启混合

```
glEnable(GL_BlEND);
```

### 颜色混合方式

选择混合⽅方程式的函数:

```
glbBlendEquation(GLenum mode);
```

![image-20220720203425222](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220720203425222.png)

默认混合方式：

```
Cf = (Cs * S) + (Cd * D)
```

- Cf :最终计算参数的颜色 
- Cs : 源颜色
- Cd :⽬目标颜色 
- S:源混合因⼦ 
- D:⽬标混合因⼦

### 设置混合因子

```
//- S:源混合因⼦ , - D:⽬标混合因⼦
glBlendFunc(GLenum S,GLenum D);

//strRGB: 源颜⾊的混合因⼦
//dstRGB: ⽬标颜色的混合因⼦ 
//strAlpha: 源颜色的Alpha因⼦ 
//dstAlpha: 目标颜⾊的Alpha因⼦
void glBlendFuncSeparate(GLenum strRGB,GLenum dstRGB ,GLenum strAlpha,GLenum dstAlpha);

//glBlendFunc 指定源和⽬标RGBA值的混合函数;
//但是glBlendFuncSeparate函数则允许为RGB 和 Alpha 成分单独指定混合函数。
```

![image-20220720203852834](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220720203852834.png)

表中R、G、B、A 分别代表 红、绿、蓝、alpha。 

表中下标S、D，分别代表源、⽬标

表中C 代表常量颜⾊(默认⿊色)

GL_CONSTANT_COLOR，GL_ONE_MINUS_CONSTANT_COLOR，GL_CONSTANT_ALPHA，GL_ONE_MINUS_CONSTANT值允许混合⽅程式中引入⼀个常量混合颜⾊

常量混合颜⾊：默认为黑色(0.0f,0.0f,0.0f,0.0f)

```
// 可以修改这个常量混合颜色。
void glBlendColor(GLclampf red ,GLclampf green ,GLclampf blue ,GLclampf alpha );
```

### 总结

- 在颜色缓冲区中，每个像素点只能存储一种颜色
- 颜色混合主要用于实现在不透明物体前绘制透明物体的效果
- 只有上面图层是透明时，才需要开启颜色混合，如果不是，则没有必要开启颜色混合
- 新颜色的alpha值越高，添加的新颜色成分就越高，旧颜色值值就保留的越少

