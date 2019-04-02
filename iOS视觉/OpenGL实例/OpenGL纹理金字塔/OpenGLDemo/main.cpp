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


GLShaderManager         shaderManager;
GLMatrixStack           modelViewMatrix;
GLMatrixStack           projectionMatrix;
GLFrame                 cameraFrame;
GLFrame                 objectFrame;
GLFrustum               viewFrustum;

GLBatch                 pyramidBatch;

//纹理变量，一般使用无符号整型
GLuint                  textureID;

GLGeometryTransform     transformPipeline;
M3DMatrix44f            shadowMatrix;

void MakePyramid(GLBatch& pyramidBatch) {
    
    /*通过pyramidBatch组建三角形批次
      参数1：类型
      参数2：顶点数
      参数3：这个批次中将会应用1个纹理
      注意：如果不写这个参数，默认为0。
     */
    pyramidBatch.Begin(GL_TRIANGLES, 18, 1);
    
    /**
     设置纹理坐标
     void MultiTexCoord2f(GLuint texture, GLclampf s, GLclampf t);
     参数1：texture，纹理层次，对于使用存储着色器来进行渲染，设置为0
     参数2：s：对应顶点坐标中的x坐标
     参数3：t:对应顶点坐标中的y
     (s,t,r,q对应顶点坐标的x,y,z,w)
     
     pyramidBatch.MultiTexCoord2f(0,s,t);
     
     void Vertex3f(GLfloat x, GLfloat y, GLfloat z);
     void Vertex3fv(M3DVector3f vVertex);
     向三角形批次类添加顶点数据(x,y,z);
      pyramidBatch.Vertex3f(-1.0f, -1.0f, -1.0f);
    
     */
    
    // 金字塔顶点
    M3DVector3f vApex = { 0.0f, 1.0f, 0.0f };
    M3DVector3f vFrontLeft = { -1.0f, -1.0f, 1.0f };
    M3DVector3f vFrontRight = { 1.0f, -1.0f, 1.0f };
    M3DVector3f vBackLeft = { -1.0f,  -1.0f, -1.0f };
    M3DVector3f vBackRight = { 1.0f,  -1.0f, -1.0f };
    M3DVector3f n;
    
    // 金字塔底部 三角形vBackLeft, vBackRight, vFrontRight
    m3dFindNormal(n, vBackLeft, vBackRight, vFrontRight);
    
    //vBackLeft
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.0f, 0.0f);
    pyramidBatch.Vertex3fv(vBackLeft);
    
    //vBackRight
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 1.0f, 0.0f);
    pyramidBatch.Vertex3fv(vBackRight);
    
    //vFrontRight
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 1.0f, 1.0f);
    pyramidBatch.Vertex3fv(vFrontRight);
    
    // 金字塔底部 三角形 vFrontLeft, vBackLeft, vFrontRight
    m3dFindNormal(n, vFrontLeft, vBackLeft, vFrontRight);
    
    //vFrontLeft
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.0f, 1.0f);
    pyramidBatch.Vertex3fv(vFrontLeft);
    
    //vBackLeft
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.0f, 0.0f);
    pyramidBatch.Vertex3fv(vBackLeft);
    
    //vFrontRight
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 1.0f, 1.0f);
    pyramidBatch.Vertex3fv(vFrontRight);
    
    // 金字塔前面 三角形：（Apex，vFrontLeft，vFrontRight）
    m3dFindNormal(n, vApex, vFrontLeft, vFrontRight);
   
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.5f, 1.0f);
    pyramidBatch.Vertex3fv(vApex);
    
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.0f, 0.0f);
    pyramidBatch.Vertex3fv(vFrontLeft);

    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 1.0f, 0.0f);
    pyramidBatch.Vertex3fv(vFrontRight);
    
    //金字塔左边
    //三角形：（vApex, vBackLeft, vFrontLeft）
    m3dFindNormal(n, vApex, vBackLeft, vFrontLeft);
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.5f, 1.0f);
    pyramidBatch.Vertex3fv(vApex);
    
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 1.0f, 0.0f);
    pyramidBatch.Vertex3fv(vBackLeft);
    
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.0f, 0.0f);
    pyramidBatch.Vertex3fv(vFrontLeft);
    
    //金字塔右边
    //三角形：（vApex, vFrontRight, vBackRight）
    m3dFindNormal(n, vApex, vFrontRight, vBackRight);
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.5f, 1.0f);
    pyramidBatch.Vertex3fv(vApex);
    
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 1.0f, 0.0f);
    pyramidBatch.Vertex3fv(vFrontRight);
    
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.0f, 0.0f);
    pyramidBatch.Vertex3fv(vBackRight);
    
    //金字塔后边
    //三角形：（vApex, vBackRight, vBackLeft）
    m3dFindNormal(n, vApex, vBackRight, vBackLeft);
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.5f, 1.0f);
    pyramidBatch.Vertex3fv(vApex);
    
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 0.0f, 0.0f);
    pyramidBatch.Vertex3fv(vBackRight);
    
    pyramidBatch.Normal3fv(n);
    pyramidBatch.MultiTexCoord2f(0, 1.0f, 0.0f);
    pyramidBatch.Vertex3fv(vBackLeft);
    
    //结束批次设置
    pyramidBatch.End();
}
    
// 将TGA文件加载为2D纹理。
bool LoadTGATexture(const char *szFileName, GLenum minFilter, GLenum magFilter, GLenum wrapMode)
{
    GLbyte *pBits;
    int nWidth, nHeight, nComponents;
    GLenum eFormat;
    
    //1、读纹理位，读取像素
    //参数1：纹理文件名称
    //参数2：文件宽度地址
    //参数3：文件高度地址
    //参数4：文件组件地址
    //参数5：文件格式地址
    //返回值：pBits,指向图像数据的指针
    
    pBits = gltReadTGABits(szFileName, &nWidth, &nHeight, &nComponents, &eFormat);
    if(pBits == NULL)
        return false;
    
    //2、设置纹理参数
    //参数1：纹理维度
    //参数2：为S/T坐标设置模式
    //参数3：wrapMode,环绕模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, wrapMode);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, wrapMode);
    
    //参数1：纹理维度
    //参数2：线性过滤
    //参数3：wrapMode,环绕模式
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minFilter);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magFilter);
    

    //3.载入纹理
    //参数1：纹理维度
    //参数2：mip贴图层次
    //参数3：纹理单元存储的颜色成分（从读取像素图是获得）
    //参数4：加载纹理宽
    //参数5：加载纹理高
    //参数6：加载纹理的深度
    //参数7：像素数据的数据类型（GL_UNSIGNED_BYTE，每个颜色分量都是一个8位无符号整数）
    //参数8：指向纹理图像数据的指针
    
    glTexImage2D(GL_TEXTURE_2D, 0, nComponents, nWidth, nHeight, 0,
                 eFormat, GL_UNSIGNED_BYTE, pBits);
    
    //使用完毕释放pBits
    free(pBits);
    

    //只有minFilter 等于以下四种模式，才可以生成Mip贴图
    //GL_NEAREST_MIPMAP_NEAREST具有非常好的性能，并且闪烁现象非常弱
    //GL_LINEAR_MIPMAP_NEAREST常常用于对游戏进行加速，它使用了高质量的线性过滤器
    //GL_LINEAR_MIPMAP_LINEAR 和GL_NEAREST_MIPMAP_LINEAR 过滤器在Mip层之间执行了一些额外的插值，以消除他们之间的过滤痕迹。
    //GL_LINEAR_MIPMAP_LINEAR 三线性Mip贴图。纹理过滤的黄金准则，具有最高的精度。
    if(minFilter == GL_LINEAR_MIPMAP_LINEAR ||
       minFilter == GL_LINEAR_MIPMAP_NEAREST ||
       minFilter == GL_NEAREST_MIPMAP_LINEAR ||
       minFilter == GL_NEAREST_MIPMAP_NEAREST)
    //4.加载Mip,纹理生成所有的Mip层
    //参数：GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D
    glGenerateMipmap(GL_TEXTURE_2D);
 
    return true;
}

// 清理…例如删除纹理对象
void ShutdownRC(void)
{
    glDeleteTextures(1, &textureID);
}

void SetupRC() {
    glClearColor(0.5, 0.5, 0.5, 1);
    shaderManager.InitializeStockShaders();
    
    glEnable(GL_DEPTH_TEST);
    
    glGenTextures(1, &textureID);
    //绑定纹理状态 参数1：纹理状态2D 参数2：纹理对象
    glBindTexture(GL_TEXTURE_2D, textureID);
    //将TGA文件加载为2D纹理。
    //参数1：纹理文件名称
    //参数2&参数3：需要缩小&放大的过滤器
    //参数4：纹理坐标环绕模式
    LoadTGATexture("stone.tga", GL_LINEAR_MIPMAP_NEAREST, GL_LINEAR, GL_CLAMP_TO_EDGE);
    
    //4.创造金字塔pyramidBatch
    MakePyramid(pyramidBatch);
    
    //5.
    /**相机frame MoveForward(平移)
    参数1：Z，深度（屏幕到图形的Z轴距离）
     */
    cameraFrame.MoveForward(-10);
}

void RenderScene() {
    
    //1.颜色值&光源位置
    static GLfloat vLightPos [] = { 1.0f, 1.0f, 0.0f };
    static GLfloat vWhite [] = { 1.0f, 1.0f, 1.0f, 1.0f };
    
    //2.清理缓存区
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    
    //3.当前模型视频压栈
    modelViewMatrix.PushMatrix();
    
    //添加照相机矩阵
    M3DMatrix44f mCamera;
    //从camraFrame中获取一个4*4的矩阵
    cameraFrame.GetCameraMatrix(mCamera);
    //矩阵乘以矩阵堆栈顶部矩阵，相乘结果存储到堆栈的顶部 将照相机矩阵 与 当前模型矩阵相乘 压入栈顶
    modelViewMatrix.MultMatrix(mCamera);
    
    //创建mObjectFrame矩阵
    M3DMatrix44f mObjectFrame;
    //从objectFrame中获取矩阵，objectFrame保存的是特殊键位的变换矩阵
    objectFrame.GetMatrix(mObjectFrame);
    //矩阵乘以矩阵堆栈顶部矩阵，相乘结果存储到堆栈的顶部 将世界变换矩阵 与 当前模型矩阵相乘 压入栈顶
    modelViewMatrix.MultMatrix(mObjectFrame);
    
    //4.绑定纹理，因为我们的项目中只有一个纹理。如果有多个纹理。绑定纹理很重要
    glBindTexture(GL_TEXTURE_2D, textureID);
    
    
    //5.纹理替换矩阵着色器
     /*
     参数1：GLT_SHADER_TEXTURE_REPLACE（着色器标签）
     参数2：模型视图投影矩阵
     参数3：纹理层
     */
//    shaderManager.UseStockShader(GLT_SHADER_TEXTURE_REPLACE, transformPipeline.GetModelViewProjectionMatrix(), 0);
    
    /*5.点光源着色器
     参数1：GLT_SHADER_TEXTURE_POINT_LIGHT_DIFF（着色器标签）
     参数2：模型视图矩阵
     参数3：投影矩阵
     参数4：视点坐标系中的光源位置
     参数5：基本漫反射颜色
     参数6：图形颜色（用纹理就不需要设置颜色。设置为0）
     */
    shaderManager.UseStockShader(GLT_SHADER_TEXTURE_POINT_LIGHT_DIFF,
                                 transformPipeline.GetModelViewMatrix(),
                                 transformPipeline.GetProjectionMatrix(),
                                 vLightPos, vWhite, 0);
    
    //pyramidBatch 绘制
    pyramidBatch.Draw();
    
    //模型视图出栈，恢复矩阵（push一次就要pop一次）
    modelViewMatrix.PopMatrix();
    
    //6.交换缓存区
    glutSwapBuffers();
}

void SpecialKeys(int key, int x, int y) {
    if(key == GLUT_KEY_UP)
        objectFrame.RotateWorld(m3dDegToRad(-5.0f), 1.0f, 0.0f, 0.0f);
    
    if(key == GLUT_KEY_DOWN)
        objectFrame.RotateWorld(m3dDegToRad(5.0f), 1.0f, 0.0f, 0.0f);
    
    if(key == GLUT_KEY_LEFT)
        objectFrame.RotateWorld(m3dDegToRad(-5.0f), 0.0f, 1.0f, 0.0f);
    
    if(key == GLUT_KEY_RIGHT)
        objectFrame.RotateWorld(m3dDegToRad(5.0f), 0.0f, 1.0f, 0.0f);
    
    glutPostRedisplay();
}

void ChangeSize(int width, int height) {
    
    //1.设置视口
    glViewport(0, 0, width, height);
    
    //2.创建投影矩阵
    viewFrustum.SetPerspective(35.0f, float(width)/float(height), 1.0f, 500.0f);
    
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
//    gltSetWorkingDirectory(argv[0]);
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH | GLUT_STENCIL);
    glutInitWindowSize(800, 600);
    glutCreateWindow("Pyramid");
    glutReshapeFunc(ChangeSize);
    glutSpecialFunc(SpecialKeys);
    glutDisplayFunc(RenderScene);
    
    GLenum err = glewInit();
    if (GLEW_OK != err) {
        fprintf(stderr, "GLEW Error: %s\n", glewGetErrorString(err));
        return 1;
    }
    
    
    SetupRC();
    
    glutMainLoop();
    
    ShutdownRC();
    
    return 0;
}
