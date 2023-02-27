//
//  main.cpp
//  OpenGLDemo
//
//  Created by xyj on 2019/1/9.
//

/*
 GLTool.h头⽂件包含了⼤部分GLTool中类似C语⾔的独⽴函数
 */
#include "GLTools.h"

/*
 矩阵的⼯具类.可以利于 GLMatrixStack 加载单元矩阵/矩阵/矩阵相乘/压栈/出栈/缩放/平移/旋转
 */
#include "GLMatrixStack.h"

/*
 矩阵工具类,表示位置.通过设置vOrigin, vForward ,vUp
 */
#include "GLFrame.h"

/*
 矩阵工具类，用来快速设置正/透视投影矩阵，完成坐标从3D-->2D映射过程
 */
#include "GLFrustum.h"

/*
 变换管道类,⽤来快速在代码中传输视图矩阵/投影矩阵/视图投影变换矩阵等.
 */
#include "GLGeometryTransform.h"


#include "StopWatch.h"

/*
 数学库
 */
#include <math.h>

/*
 在Mac 系统下，`#include<glut/glut.h>`
 在Windows 和 Linux上，我们使⽤用freeglut的静
 态库版本并且需要添加⼀一个宏
 */
#ifdef __APPLE__
#include "glut/glut.h"
#else
#define FREEGLUT_STATIC
#include <GL/glut.h>
#endif



int main(int argc, char* argv[]) {
    
}
