## OpenGL 点/线

```
//1.最简单也是最常⽤的 4.0f,表示点的⼤小 
glPointSize(4.0f);

//2.设置点的⼤小范围和点与点之间的间隔 
GLfloat sizes[2] = {2.0f,4.0f};
GLfloat step = 1.0f;

//3.获取点⼤小范围和最⼩步长 
glGetFloatv(GL_POINT_SIZE_RANGE ,sizes);
glGetFloatv(GL_POINT_GRAULARITY ,&step);

//4.通过使⽤程序点⼤小模式来设置点⼤小 
glEnable(GL_PROGRAM_POINT_SIZE);

//5.这种模式下允许我们通过编程在顶点着⾊器或⼏何着⾊器中设置点⼤小。着⾊器内建变量量: gl_PointSize，并且可以在着⾊器源码直接写
gl_PointSize = 5.0

//6. 设置线段宽度 
glLineWidth(2.5f);
```

## OpenGL 三角形

对于OpenGL 光栅化最欢迎的是三⻆形.3个顶点就能构成⼀个三⻆形. 三⻆形类型来⾃于顶点.并不是所有的三角形都是正三角形等.

![image-20220719145403256](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220719145403256.png)

## OpenGL 三角形环绕方式

在绘制第⼀个三角形时，线条是按照从V0-V1，再到V2。最后再回到V0的⼀个闭合三⻆形。 这个是沿着顶点顺时针⽅方向。这种顺序与⽅向结合来指定顶点的⽅式称为环绕

在默认情况下,OpenGL 认为具有逆时针⽅方向环绕的多边形为正面. 这就意味着下图左边是正面,右边是反⾯.

```
//GL_CW:告诉OpenGL 顺时针环绕的多边形为正⾯面; GL_CCW:告诉OpenGL 逆时针环绕的多边形为正⾯面;
glFrontFace(GL_CW);
```

![image-20220719145444506](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220719145444506.png)

## OpenGL 三角形带

对于很多表面或者形状而言,我们会需要绘制几个相连的三角形. 这是我们可以使⽤GL_TRIANGLE_STRIP 图元绘制⼀串相连三角形,从⽽而节省⼤量的时间.

![image-20220719145745356](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220719145745356.png)

三角形带优点:

1. 用前3个顶点指定第1个三⻆角形之后，对于接下来的每⼀个三⻆形，只需要再指定1个顶点。需要绘制⼤量的三⻆形时，采⽤这种⽅方法可以节省⼤量的程序代码和数据存储空间
2. 提供运算性能和节省带宽。更少的顶点意味着数据从内存传输到图形卡的速度更快，并且顶点着⾊器需要处理的次数也更少了。

## OpenGL 三角形扇

对于很多表面或者形状⽽言,我们会需要绘制⼏个相连的三角形. 这是我们可以使⽤GL_TRIANGLE_FAN 图元绘制⼀组围绕⼀个中⼼点相连的三⻆形

![image-20220719150018963](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220719150018963.png)

## OpenGL工具类 GLBatch

GLBatch,是在GLTools中包含的⼀一个简单容器器类.

```
void GLBatch::Begain(GLeunm primitive,GLuint nVerts,GLuint nTexttureUnints = 0);
参数1:图元
参数2:顶点数 
参数3:一组或者2组纹理坐标(可选)

//复制顶点数据(⼀一个由3分量量x,y,z顶点组成的数组) 
void GLBatch::CopyVerterxData3f(GLfloat *vVerts);

//复制表面法线数据
void GLBatch::CopyNormalDataf(GLfloat *vNorms);

//复制颜色数据
void GLBatch::CopyColorData4f(GLfloat *vColors);

//复制纹理坐标数据
void GLBatch::CopyTexCoordData2f(GLFloat *vTextCoords, GLuint uiTextureLayer);

//结束数据复制
void GLBatch::End(void);

//绘制图形
void GLBatch::Draw(void);
```

