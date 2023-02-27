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


//**4、添加附加随机球
#define NUM_SPHERES 50
GLFrame spheres[NUM_SPHERES];

GLShaderManager        shaderManager;            // 着色器管理器
GLMatrixStack        modelViewMatrix;        // 模型视图矩阵
GLMatrixStack        projectionMatrix;        // 投影矩阵
GLFrustum            viewFrustum;            // 视景体
GLGeometryTransform    transformPipeline;        // 几何图形变换管道

GLTriangleBatch        torusBatch;             // 花托批处理
GLBatch                floorBatch;             // 地板批处理

//**2、定义公转球的批处理（公转自转）**
GLTriangleBatch     sphereBatch;            //球批处理

//**3、角色帧 照相机角色帧（全局照相机实例）
GLFrame             cameraFrame;

//**5、添加纹理
//纹理标记数组
GLuint uiTextures[3];

bool LoadTGATexture(const char *szFileName, GLenum minFilter, GLenum magFilter, GLenum wrapMode)
{

    GLbyte *pBits;
    int nWidth, nHeight, nComponents;
    GLenum eFormat;
    
    //1.读取纹理数据
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
    //参数3：纹理单元存储的颜色成分（从读取像素图是获得）-将内部参数nComponents改为了通用压缩纹理格式GL_COMPRESSED_RGB
    //参数4：加载纹理宽
    //参数5：加载纹理高
    //参数6：加载纹理的深度
    //参数7：像素数据的数据类型（GL_UNSIGNED_BYTE，每个颜色分量都是一个8位无符号整数）
    //参数8：指向纹理图像数据的指针
    glTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB, nWidth, nHeight, 0,
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



void SetupRC()
{
    //1.设置清屏颜色到颜色缓存区
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    //2.初始化着色器管理器
    shaderManager.InitializeStockShaders();
    
    //3.开启深度测试/背面剔除
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_CULL_FACE);

    //4.设置大球球
    gltMakeSphere(torusBatch, 0.4f, 40, 80);
    
    //5.设置小球(公转自转)
    gltMakeSphere(sphereBatch, 0.1f, 26, 13);
    
    //6.设置地板顶点数据&地板纹理
    GLfloat texSize = 10.0f;
    floorBatch.Begin(GL_TRIANGLE_FAN, 4,1);
    floorBatch.MultiTexCoord2f(0, 0.0f, 0.0f);
    floorBatch.Vertex3f(-20.f, -0.41f, 20.0f);
    
    floorBatch.MultiTexCoord2f(0, texSize, 0.0f);
    floorBatch.Vertex3f(20.0f, -0.41f, 20.f);
    
    floorBatch.MultiTexCoord2f(0, texSize, texSize);
    floorBatch.Vertex3f(20.0f, -0.41f, -20.0f);
    
    floorBatch.MultiTexCoord2f(0, 0.0f, texSize);
    floorBatch.Vertex3f(-20.0f, -0.41f, -20.0f);
    floorBatch.End();
    
    //7.随机小球球顶点坐标数据
    for (int i = 0; i < NUM_SPHERES; i++) {
        
        //y轴不变，X,Z产生随机值
        GLfloat x = ((GLfloat)((rand() % 400) - 200 ) * 0.1f);
        GLfloat z = ((GLfloat)((rand() % 400) - 200 ) * 0.1f);
        
        //在y方向，将球体设置为0.0的位置，这使得它们看起来是飘浮在眼睛的高度
        //对spheres数组中的每一个顶点，设置顶点数据
        spheres[i].SetOrigin(x, 0.0f, z);
    }
    
    //8.命名纹理对象
    glGenTextures(3, uiTextures);
    
    //9.将TGA文件加载为2D纹理。
    //参数1：纹理文件名称
    //参数2&参数3：需要缩小&放大的过滤器
    //参数4：纹理坐标环绕模式
    glBindTexture(GL_TEXTURE_2D, uiTextures[0]);
    LoadTGATexture("marble.tga", GL_LINEAR_MIPMAP_LINEAR, GL_LINEAR, GL_REPEAT);
    
    
    glBindTexture(GL_TEXTURE_2D, uiTextures[1]);
    LoadTGATexture("marslike.tga", GL_LINEAR_MIPMAP_LINEAR,
                   GL_LINEAR, GL_CLAMP_TO_EDGE);
    
    
    glBindTexture(GL_TEXTURE_2D, uiTextures[2]);
    LoadTGATexture("moonlike.tga", GL_LINEAR_MIPMAP_LINEAR,
                   GL_LINEAR, GL_CLAMP_TO_EDGE);
    
   
}

//删除纹理
void ShutdownRC(void)
{
    glDeleteTextures(3, uiTextures);
}

// 屏幕更改大小或已初始化
void ChangeSize(int nWidth, int nHeight)
{
    //1.设置视口
    glViewport(0, 0, nWidth, nHeight);
    
    //2.设置投影方式
    viewFrustum.SetPerspective(35.0f, float(nWidth)/float(nHeight), 1.0f, 100.0f);
    
    //3.将投影矩阵加载到投影矩阵堆栈,
    projectionMatrix.LoadMatrix(viewFrustum.GetProjectionMatrix());
    modelViewMatrix.LoadIdentity();
    
    //4.将投影矩阵堆栈和模型视图矩阵对象设置到管道中
    transformPipeline.SetMatrixStacks(modelViewMatrix, projectionMatrix);
   
    
}

void drawSomething(GLfloat yRot)
{
    //1.定义光源位置&漫反射颜色
    static GLfloat vWhite[] = { 1.0f, 1.0f, 1.0f, 1.0f };
    static GLfloat vLightPos[] = { 0.0f, 3.0f, 0.0f, 1.0f };
    
    //2.绘制悬浮小球球
    glBindTexture(GL_TEXTURE_2D, uiTextures[2]);
    for(int i = 0; i < NUM_SPHERES; i++) {
        modelViewMatrix.PushMatrix();
        modelViewMatrix.MultMatrix(spheres[i]);
        shaderManager.UseStockShader(GLT_SHADER_TEXTURE_POINT_LIGHT_DIFF,
                                     modelViewMatrix.GetMatrix(),
                                     transformPipeline.GetProjectionMatrix(),
                                     vLightPos,
                                     vWhite,
                                     0);
        sphereBatch.Draw();
        modelViewMatrix.PopMatrix();
    }
    
    //3.绘制大球球
    modelViewMatrix.Translate(0.0f, 0.2f, -2.5f);
    modelViewMatrix.PushMatrix();
    modelViewMatrix.Rotate(yRot, 0.0f, 1.0f, 0.0f);
    glBindTexture(GL_TEXTURE_2D, uiTextures[1]);
    shaderManager.UseStockShader(GLT_SHADER_TEXTURE_POINT_LIGHT_DIFF,
                                 modelViewMatrix.GetMatrix(),
                                 transformPipeline.GetProjectionMatrix(),
                                 vLightPos,
                                 vWhite,
                                 0);
    torusBatch.Draw();
    modelViewMatrix.PopMatrix();
    
    //4.绘制公转小球球（公转自转)
    modelViewMatrix.PushMatrix();
    modelViewMatrix.Rotate(yRot * -2.0f, 0.0f, 1.0f, 0.0f);
    modelViewMatrix.Translate(0.8f, 0.0f, 0.0f);
    glBindTexture(GL_TEXTURE_2D, uiTextures[2]);
    shaderManager.UseStockShader(GLT_SHADER_TEXTURE_POINT_LIGHT_DIFF,
                                 modelViewMatrix.GetMatrix(),
                                 transformPipeline.GetProjectionMatrix(),
                                 vLightPos,
                                 vWhite,
                                 0);
    sphereBatch.Draw();
    modelViewMatrix.PopMatrix();
    
}



//进行调用以绘制场景
void RenderScene(void)
{
    //1.地板颜色值
    static GLfloat vFloorColor[] = { 1.0f, 1.0f, 0.0f, 0.75f};
    
    //2.基于时间动画
    static CStopWatch    rotTimer;
    float yRot = rotTimer.GetElapsedSeconds() * 60.0f;
    
    //3.清除颜色缓存区和深度缓冲区
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    //4.压入栈(栈顶)
    modelViewMatrix.PushMatrix();
    
    //5.设置观察者矩阵
    M3DMatrix44f mCamera;
    cameraFrame.GetCameraMatrix(mCamera);
    modelViewMatrix.MultMatrix(mCamera);
    
    //6.压栈(镜面)
    modelViewMatrix.PushMatrix();
    
    //7.---添加反光效果---
    //翻转Y轴
    modelViewMatrix.Scale(1.0f, -1.0f, 1.0f);
    //镜面世界围绕Y轴平移一定间距
    modelViewMatrix.Translate(0.0f, 0.8f, 0.0f);
    
    //8.指定顺时针为正面
    glFrontFace(GL_CW);
  
    //9.绘制地面以外其他部分(镜面)
    drawSomething(yRot);
   
    //10.恢复为逆时针为正面
    glFrontFace(GL_CCW);
    
    //11.绘制镜面，恢复矩阵
    modelViewMatrix.PopMatrix();
    
    //12.开启混合功能(绘制地板)
    glEnable(GL_BLEND);
    //13. 指定glBlendFunc 颜色混合方程式
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    //14.绑定地面纹理
    glBindTexture(GL_TEXTURE_2D, uiTextures[0]);
    
    /*15.
     纹理调整着色器(将一个基本色乘以一个取自纹理的单元nTextureUnit的纹理)
     参数1：GLT_SHADER_TEXTURE_MODULATE
     参数2：模型视图投影矩阵
     参数3：颜色
     参数4：纹理单元（第0层的纹理单元）
     
     */
    shaderManager.UseStockShader(GLT_SHADER_TEXTURE_MODULATE,
                                 transformPipeline.GetModelViewProjectionMatrix(),
                                 vFloorColor,
                                 0);
    //开始绘制
    floorBatch.Draw();
    //取消混合
    glDisable(GL_BLEND);
    
    //16.绘制地面以外其他部分
    drawSomething(yRot);
    
    //17.绘制完，恢复矩阵
    modelViewMatrix.PopMatrix();
    
    //18.交换缓存区
    glutSwapBuffers();
    
    //19.提交重新渲染
    glutPostRedisplay();
    
    
    
}


//**3.移动照相机参考帧，来对方向键作出响应
void SpeacialKeys(int key,int x,int y)
{
    
    float linear = 0.1f;
    float angular = float(m3dDegToRad(5.0f));
    
    if (key == GLUT_KEY_UP) {
        
        //MoveForward 平移
        cameraFrame.MoveForward(linear);
    }
    
    if (key == GLUT_KEY_DOWN) {
        cameraFrame.MoveForward(-linear);
    }
    
    if (key == GLUT_KEY_LEFT) {
        //RotateWorld 旋转
        cameraFrame.RotateWorld(angular, 0.0f, 1.0f, 0.0f);
    }
    
    if (key == GLUT_KEY_RIGHT) {
        cameraFrame.RotateWorld(-angular, 0.0f, 1.0f, 0.0f);
    }
    
    
    
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
    glutSpecialFunc(SpeacialKeys);
    
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
