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

int main(int argc,char* argv[]) {
    
    //1.初始化一个GLUT库
    glutInit(&argc, (char **)argv);
    
    //2.创建一个窗口并制定窗口名
    glutCreateWindow("XZ_Window");
    
    //3.注册一个绘图函数，操作系统在必要时刻就会对窗体进行重绘制操作
    //它设置了一个显示回调（diplay callback），即GLUT在每次更新窗口内容的时候回自动调用该例程
    glutDisplayFunc(draw);
    
    //这是一个无限执行的循环，它会负责一直处理窗口和操作系统的用户输入等操作。（注意：不会执行在glutMainLoop()之后的所有命令。）
    glutMainLoop();
    
    return 0;
}
