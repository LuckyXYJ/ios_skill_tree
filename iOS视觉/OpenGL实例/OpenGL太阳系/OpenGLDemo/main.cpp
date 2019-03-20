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


GLShaderManager        shaderManager;            // 着色器管理器
GLMatrixStack        modelViewMatrix;        // 模型视图矩阵
GLMatrixStack        projectionMatrix;        // 投影矩阵
GLFrustum            viewFrustum;            // 视景体
GLGeometryTransform    transformPipeline;        // 几何图形变换管道

GLTriangleBatch        torusBatch;             //大球
GLTriangleBatch     sphereBatch;            //小球
GLBatch                floorBatch;          //地板

//角色帧 照相机角色帧
GLFrame             cameraFrame;

//**4、添加附加随机球
#define NUM_SPHERES 50
GLFrame spheres[NUM_SPHERES];

void SetupRC()
{
    //1.初始化
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    shaderManager.InitializeStockShaders();
    
    //2.开启深度测试
    glEnable(GL_DEPTH_TEST);
   
    //3. 设置地板顶点数据
    floorBatch.Begin(GL_LINES, 324);
    for(GLfloat x = -20.0; x <= 20.0f; x+= 0.5) {
        floorBatch.Vertex3f(x, -0.55f, 20.0f);
        floorBatch.Vertex3f(x, -0.55f, -20.0f);
        
        floorBatch.Vertex3f(20.0f, -0.55f, x);
        floorBatch.Vertex3f(-20.0f, -0.55f, x);
    }
    floorBatch.End();
    
   
    //4.设置大球模型
    gltMakeSphere(torusBatch, 0.4f, 40, 80);
}

//进行调用以绘制场景
void RenderScene(void)
{
    //1.颜色值(地板,大球,小球颜色)
    static GLfloat vFloorColor[] = { 0.0f, 1.0f, 0.0f, 1.0f };
    static GLfloat vTorusColor[] = { 1.0f, 0.0f, 0.0f, 1.0f };
    
    //2.基于时间动画
    static CStopWatch    rotTimer;
    float yRot = rotTimer.GetElapsedSeconds() * 60.0f;

    //2.清除颜色缓存区和深度缓冲区
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //3.绘制地面
    shaderManager.UseStockShader(GLT_SHADER_FLAT,
                                 transformPipeline.GetModelViewProjectionMatrix(),
                                 vFloorColor);
    floorBatch.Draw();
    
    
    //4.获取光源位置
    M3DVector4f vLightPos = {0.0f,10.0f,5.0f,1.0f};
   
    //5.使得大球位置平移(3.0)向屏幕里面
    modelViewMatrix.Translate(0.0f, 0.0f, -3.0f);
    //6.压栈(复制栈顶)
    modelViewMatrix.PushMatrix();
    //7.大球自转
    modelViewMatrix.Rotate(yRot, 0.0f, 1.0f, 0.0f);
    //8.指定合适的着色器(点光源着色器)
    shaderManager.UseStockShader(GLT_SHADER_POINT_LIGHT_DIFF, transformPipeline.GetModelViewMatrix(),
                                 transformPipeline.GetProjectionMatrix(), vLightPos, vTorusColor);
    torusBatch.Draw();
    //9.绘制完毕则Pop
    modelViewMatrix.PopMatrix();
    
    //4.执行缓存区交换
    glutSwapBuffers();
    
  
}

//屏幕更改大小或已初始化
void ChangeSize(int nWidth, int nHeight)
{
    //1.设置视口
    glViewport(0, 0, nWidth, nHeight);
    
    //2.创建投影矩阵，。
    viewFrustum.SetPerspective(35.0f, float(nWidth)/float(nHeight), 1.0f, 100.0f);
    //viewFrustum.GetProjectionMatrix()  获取viewFrustum投影矩阵
    //并将其加载到投影矩阵堆栈上
    projectionMatrix.LoadMatrix(viewFrustum.GetProjectionMatrix());
    
    
    //3.设置变换管道以使用两个矩阵堆栈（变换矩阵modelViewMatrix ，投影矩阵projectionMatrix）
    //初始化GLGeometryTransform 的实例transformPipeline.通过将它的内部指针设置为模型视图矩阵堆栈 和 投影矩阵堆栈实例，来完成初始化
    //当然这个操作也可以在SetupRC 函数中完成，但是在窗口大小改变时或者窗口创建时设置它们并没有坏处。而且这样可以一次性完成矩阵和管线的设置。
    transformPipeline.SetMatrixStacks(modelViewMatrix, projectionMatrix);
}





int main(int argc, char* argv[])
{
    gltSetWorkingDirectory(argv[0]);
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB | GLUT_DEPTH);
    glutInitWindowSize(800,600);
    
    glutCreateWindow("OpenGL SphereWorld");
    
    glutReshapeFunc(ChangeSize);
    glutDisplayFunc(RenderScene);
    
    GLenum err = glewInit();
    if (GLEW_OK != err) {
        fprintf(stderr, "GLEW Error: %s\n", glewGetErrorString(err));
        return 1;
    }
    
    
    SetupRC();
    glutMainLoop();
    return 0;
}
