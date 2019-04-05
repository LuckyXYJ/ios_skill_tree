//
//  main.cpp
//  OpenGLDemo
//
//  Created by xyj on 2019/1/9.
//

/*
 案例：实现矩阵的移动，利用矩阵的平移、旋转、综合变化等
 */
#include "GLTools.h"
#include "GLShaderManager.h"
#include "math3d.h"

#ifdef __APPLE__
#include <glut/glut.h>
#else
#define FREEGLUT_STATIC
#include <GL/glut.h>
#endif


GLBatch    squareBatch;
GLShaderManager    shaderManager;


GLfloat blockSize = 0.1f;
GLfloat vVerts[] = {
    -blockSize, -blockSize, 0.0f,
    blockSize, -blockSize, 0.0f,
    blockSize,  blockSize, 0.0f,
    -blockSize,  blockSize, 0.0f};

GLfloat xPos = 0.0f;
GLfloat yPos = 0.0f;

void SetupRC()
{
    //1.初始化
    glClearColor(0.0f, 0.0f, 1.0f, 1.0f );
    shaderManager.InitializeStockShaders();
    
    //2.加载三角形
    squareBatch.Begin(GL_TRIANGLE_FAN, 4);
    squareBatch.CopyVertexData3f(vVerts);
    squareBatch.End();
}

//移动（移动只是计算了X,Y移动的距离，以及碰撞检测）
void SpecialKeys(int key, int x, int y)
{
    GLfloat stepSize = 0.025f;
    if(key == GLUT_KEY_UP)
        yPos += stepSize;
    
    if(key == GLUT_KEY_DOWN)
        yPos -= stepSize;
    
    if(key == GLUT_KEY_LEFT)
        xPos -= stepSize;
    
    if(key == GLUT_KEY_RIGHT)
        xPos += stepSize;
    
    // 碰撞检测
    if(xPos < (-1.0f + blockSize)) xPos = -1.0f + blockSize;
    
    if(xPos > (1.0f - blockSize)) xPos = 1.0f - blockSize;
    
    if(yPos < (-1.0f + blockSize))  yPos = -1.0f + blockSize;
    
    if(yPos > (1.0f - blockSize)) yPos = 1.0f - blockSize;
    
    glutPostRedisplay();
}


void RenderScene(void)
{

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT | GL_STENCIL_BUFFER_BIT);
    
    GLfloat vRed[] = { 1.0f, 0.0f, 0.0f, 1.0f };
    
    M3DMatrix44f mFinalTransform, mTranslationMatrix, mRotationMatrix;
    
    //平移 xPos,yPos
    m3dTranslationMatrix44(mTranslationMatrix, xPos, yPos, 0.0f);
    
    // 每次重绘时，旋转5度
    static float yRot = 0.0f;
    yRot += 5.0f;
    m3dRotationMatrix44(mRotationMatrix, m3dDegToRad(yRot), 0.0f, 0.0f, 1.0f);
    
    //将旋转和移动的结果合并到mFinalTransform 中
    m3dMatrixMultiply44(mFinalTransform, mTranslationMatrix, mRotationMatrix);
    
    //将矩阵结果提交到固定着色器（平面着色器）中。
    shaderManager.UseStockShader(GLT_SHADER_FLAT, mFinalTransform, vRed);
    squareBatch.Draw();
    
    // 执行缓冲区交换
    glutSwapBuffers();
}



void ChangeSize(int w, int h)
{
    glViewport(0, 0, w, h);
}


int main(int argc, char* argv[])
{
    gltSetWorkingDirectory(argv[0]);
    
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA | GLUT_DEPTH);
    glutInitWindowSize(600, 600);
    glutCreateWindow("Move Block with Arrow Keys");
    
    GLenum err = glewInit();
    if (GLEW_OK != err)
    {
        
        fprintf(stderr, "Error: %s\n", glewGetErrorString(err));
        return 1;
    }
    
    glutReshapeFunc(ChangeSize);
    glutDisplayFunc(RenderScene);
    glutSpecialFunc(SpecialKeys);
    
    SetupRC();
    
    glutMainLoop();
    return 0;
}
