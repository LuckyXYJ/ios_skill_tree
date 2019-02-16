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



```


```

