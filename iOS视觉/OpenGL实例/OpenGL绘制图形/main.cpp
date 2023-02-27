//
//  main.cpp
//  OpenGLDemo
//
//  Created by xyj on 2019/1/9.
//


/*
 `#include<GLShaderManager.h>` 移入了GLTool 着色器管理器（shader Mananger）类。没有着色器，我们就不能在OpenGL（核心框架）进行着色。着色器管理器不仅允许我们创建并管理着色器，还提供一组“存储着色器”，他们能够进行一些初步䄦基本的渲染操作。
 */
#include "GLShaderManager.h"

#include "GLTools.h"

#include <glut/glut.h>

void draw(){
//-----------------画正方形-------------------------
    //1.设置清屏颜色 红、绿、蓝、透明度
    /*
     在windows 颜色成分取值范围：0-255之间
     在iOS、OS 颜色成分取值范围：0-1之间浮点值
     */
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);


    /*
     清除缓存区对数值进行预置
     参数：指定将要清楚的缓存区的遮罩的按位或运算。
     GL_COLOR_BUFFER_BIT: 指示当前激活的用来进行颜色写入缓存区
     GL_DEPTH_BUFFER_BIT:指示深度缓存区
     GL_STENCIL_BUFFER_BIT:指示模板缓存区

     每个缓存区的清楚值根据这个缓存区的清楚值设置不同。

     错误：
     如果设定不是以上三个参考值，返回GL_INVALID_VALUE
     */
    //glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT|GL_STENCIL_BUFFER_BIT);
    glClear(GL_COLOR_BUFFER_BIT);



    //设置颜色
    glColor3f(1.0f, 0.0f, 0.0f);


    //设置绘图是的坐标系统
    //左、右、上、下、近、远
    glOrtho(0.0f, 1.0f, 0.0f, 1.0f, -1.0f, 1.0f);


    //开始渲染
    glBegin(GL_POLYGON);

    //设置多边形的4个顶点
    glVertex3f(0.25f, 0.25f, 0.0f);
    glVertex3f(0.75f, 0.25f, 0.0f);
    glVertex3f(0.75f, 0.75f, 0.0f);
    glVertex3f(0.25f, 0.75f, 0.0f);


    //结束渲染
    glEnd();

    //强制刷新缓存区，保证绘制命令得以执行
    glFlush();
    
}

void drawCircle() {
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
 
    glClear(GL_COLOR_BUFFER_BIT);

    //设置颜色
    glColor3f(1.0f, 0.0f, 0.0f);
 
    //开始渲染
    glBegin(GL_POLYGON);
   
    const int n = 55;//当n为3时为三角形；n为4时是四边形，n为5时为五边形。。。。。
    const GLfloat R = 0.5f;//圆的半径
    const GLfloat pi = 3.1415926f;
    for (int i = 0; i < n; i++)
    {
        glVertex2f(R*cos(2 * pi / n*i), R*sin(2 * pi / n*i));
    }
    //结束渲染
    glEnd();
 
    //强制刷新缓存区，保证绘制命令得以执行
    glFlush();
    
    const GLfloat factor = 0.1f;
    GLfloat x;
    glClear(GL_COLOR_BUFFER_BIT);
    glBegin(GL_LINES);
    glVertex2f(-1.0f, 0.0f);
    glVertex2f(1.0f, 0.0f);        // 以上两个点可以画x轴
    glVertex2f(0.0f, -1.0f);
    glVertex2f(0.0f, 1.0f);        // 以上两个点可以画y轴
    glEnd();
    glBegin(GL_LINE_STRIP);
    for(x=-1.0f/factor; x<1.0f/factor; x+=0.01f)
    {
        glVertex2f(x*factor, sin(x)*factor);
    }
    glEnd();
    glFlush();
}

void drawPentagon() {
    // ------------------------五角形-----------------------------
    
    /*
     设五角星的五个顶点分布位置关系如下：
     A
     E       B
    
     D   C
     首先，根据余弦定理列方程，计算五角星的中心到顶点的距离a
     （假设五角星对应正五边形的边长为.0）
     a = 1 / (2-2*cos(72*Pi/180));
     然后，根据正弦和余弦的定义，计算B的x坐标bx和y坐标by，以及C的y坐标
     （假设五角星的中心在坐标原点）
     bx = a * cos(18 * Pi/180);
     by = a * sin(18 * Pi/180);
     cy = -a * cos(18 * Pi/180);
     五个点的坐标就可以通过以上四个量和一些常数简单的表示出来
     */
    const GLfloat Pi = 3.1415926536f;
    GLfloat a = 1 / (2-2*cos(72*Pi/180));
    GLfloat bx = a * cos(18 * Pi/180);
    GLfloat by = a * sin(18 * Pi/180);
    GLfloat cy = -a * cos(18 * Pi/180);
    GLfloat
    PointA[2] = { 0, a },
    PointB[2] = { bx, by },
    PointC[2] = { 0.5, cy },
    PointD[2] = { -0.5, cy },
    PointE[2] = { -bx, by };

    glClear(GL_COLOR_BUFFER_BIT);
    // 按照A->C->E->B->D->A的顺序，可以一笔将五角星画出
    glBegin(GL_LINE_LOOP);
    glVertex2fv(PointA);
    glVertex2fv(PointC);
    glVertex2fv(PointE);
    glVertex2fv(PointB);
    glVertex2fv(PointD);
    glEnd();
    glFlush();
}

void drawSin() {
//----------- 画出正弦函数的图形---------------
    /*
     由于OpenGL默认坐标值只能从-1到1，（可以修改，但方法留到以后讲）
     所以我们设置一个因子factor，把所有的坐标值等比例缩小，
     这样就可以画出更多个正弦周期
     试修改factor的值，观察变化情况
     */
    const GLfloat factor = 0.1f;
    GLfloat x;
    glClear(GL_COLOR_BUFFER_BIT);
    glBegin(GL_LINES);
    glVertex2f(-1.0f, 0.0f);
    glVertex2f(1.0f, 0.0f);        // 以上两个点可以画x轴
    glVertex2f(0.0f, -1.0f);
    glVertex2f(0.0f, 1.0f);        // 以上两个点可以画y轴
    glEnd();
    glBegin(GL_LINE_STRIP);
    for(x=-1.0f/factor; x<1.0f/factor; x+=0.01f)
    {
        glVertex2f(x*factor, sin(x)*factor);
    }
    glEnd();
    glFlush();
}

int main(int argc,char* argv[]) {
    
    //1.初始化一个GLUT库
    glutInit(&argc, (char **)argv);
    
    //2.创建一个窗口并制定窗口名
    glutCreateWindow("XZ_Window");
    
    //3.注册一个绘图函数，操作系统在必要时刻就会对窗体进行重绘制操作
    //它设置了一个显示回调（diplay callback），即GLUT在每次更新窗口内容的时候回自动调用该例程
//    glutDisplayFunc(draw);
//    glutDisplayFunc(drawCircle);
//    glutDisplayFunc(drawPentagon);
    glutDisplayFunc(drawSin);
    //这是一个无限执行的循环，它会负责一直处理窗口和操作系统的用户输入等操作。（注意：不会执行在glutMainLoop()之后的所有命令。）
    glutMainLoop();
    
    return 0;
}
