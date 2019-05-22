//
//  GLUtil.c
//  GLKit
//
//  Created by CC on 2017/1/4.
//  Copyright © 2017年 CC. All rights reserved.
//

#include "GLUtil.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

long getFileContent(char *buffer, long len, const char *filePath)
{
    FILE *file = fopen(filePath, "rb");
    if (file == NULL) {
        return -1;
    }
    
    fseek(file, 0, SEEK_END);
    long size = ftell(file);
    rewind(file);
    
    if (len < size) {
        GLlog("file is large than the size(%ld) you give\n", len);
        return -1;
    }
    
    fread(buffer, 1, size, file);
    buffer[size] = '\0';
    
    fclose(file);
    
    return size;
}



static GLuint createGLShader(const char *shaderText, GLenum shaderType)
{
    //创建着色器,将根据传入的type参数 创建一个新的 顶点或片段着色器,返回值为新的着色器对象句柄
    //GL_VERTEX_SHADER(顶点着色器)     GL_FRAGMENT_SHADER(片段着色器)
    GLuint shader = glCreateShader(shaderType);

    //为着色器对象 提供着色器源代码.
    //参数: shader --> 着色器对象句柄
    //      count --> 着色器源字符串数量
    //      string --> 字符串的数组指针
    //      length ---> 指向保存美工着色器字符串大小且元素数量为count的整数数组指针.如果length为NULL 着色器字符串将被认定为空.
    glShaderSource(shader, 1, &shaderText, NULL);

    //调用该方法,将指定的着色器源代码 进行编译
    //参数shader 为着色器句柄
    glCompileShader(shader);

    //调用该方法获取 着色器源代码编译是否成功,并获取其他相关信息
    //第二个参数 pname 表示要查询什么信息
    /*
     GL_COMPILE_STATUS ---> 是否编译成功 成功返回 GL_TRUE
     GL_INFO_LOG_LENGTH ---> 查询源码编译后长度
     GL_SHADER_SOURCE_LENGTH ---> 查询源码长度
     GL_SHADER_TYPE ---> 查询着色器类型()
     GL_DELETE_STATUS ---> 着色器是否被标记删除
     */
    int compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    if (!compiled) {
        GLint infoLen = 0;
        glGetShaderiv (shader, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            char *infoLog = (char *)malloc(sizeof(char) * infoLen);
            if (infoLog) {


                //检索信息日志
                //参数: shader 着色器对象句柄
                //      maxLength 保存信息日志的缓冲区大小
                //      length 写入信息日志长度 ,不需要知道可传NULL
                //      infoLog 保存日志信息的指针
                glGetShaderInfoLog (shader, infoLen, NULL, infoLog);
                GLlog("Error compiling shader: %s\n", infoLog);
                free(infoLog);
            }
        }
        //删除着色器对象, 参数shader为要删除的着色器对象的句柄
        //若一个着色器链接到一个程序对象,那么该方法不会立刻删除着色器,而是将着色器标记为删除,当着色器不在连接到任何程序对象时,它的内存将被释放.
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
}

GLuint createGLProgram(const char *vertext, const char *frag)
{
    /*
     程序对象是一个容器对象,可以将着色器与之连接,并链接一个最终的可执行程序
     */
    // 创建一个程序对象,返回程序对象的句柄
    GLuint program = glCreateProgram();

    // 得到需要的着色器
    GLuint vertShader = createGLShader(vertext, GL_VERTEX_SHADER);  //顶点着色器
    GLuint fragShader = createGLShader(frag, GL_FRAGMENT_SHADER);   //片元着色器
    
    if (vertShader == 0 || fragShader == 0) {
        return 0;
    }

    //将程序对象和 着色器对象链接  //在ES 3.0中,每个程序对象 必须连接一个顶点着色器和片段着色器
    //program程序对象句柄 shader着色器句柄
    glAttachShader(program, vertShader);
    glAttachShader(program, fragShader);


    //链接程序对象 生成可执行程序(在着色器已完成编译 且程序对象连接了着色器)
    //链接程序会检查各种对象的数量,和各种条件.
    //在链接阶段就是生成最终硬件指令的时候
    glLinkProgram(program);


    //检查链接是否成功
    GLint success;
    glGetProgramiv(program, GL_LINK_STATUS, &success);

    if (!success) {
        GLint infoLen;
        //使用 GL_INFO_LOG_LENGTH 表示获取信息日志
        glGetProgramiv(program, GL_INFO_LOG_LENGTH, &infoLen);
        if (infoLen > 1) {
            GLchar *infoText = (GLchar *)malloc(sizeof(GLchar)*infoLen + 1);
            if (infoText) {
                memset(infoText, 0x00, sizeof(GLchar)*infoLen + 1);

                // 从信息日志中获取信息
                glGetProgramInfoLog(program, infoLen, NULL, infoText);
                GLlog("%s", infoText);
                free(infoText);

                //此函数用于校验当前的程序对象,校验结果可通过 glGetProgramiv函数检查,此函数只用于调试,因为他很慢.
                //glValidateProgram(program);
            }
        }
        glDeleteShader(vertShader);
        glDeleteShader(fragShader);

        //删除程序对象
        glDeleteProgram(program);
        return 0;
    }
/*
 * 链接完着色器,生成可执行程序. 将着色器断开删除
 */
    //断开指定程序对象和片段着色器
    glDetachShader(program, vertShader);
    glDetachShader(program, fragShader);

    //将着色器标记为删除
    glDeleteShader(vertShader);
    glDeleteShader(fragShader);

    return program;
}

GLuint createGLProgramFromFile(const char *vertextPath, const char *fragPath)
{
    char vBuffer[20480] = {0};
    char fBuffer[20480] = {0};
    
    if (getFileContent(vBuffer, sizeof(vBuffer), vertextPath) < 0) {
        return 0;
    }
    
    if (getFileContent(fBuffer, sizeof(fBuffer), fragPath) < 0) {
        return 0;
    }
    
    return createGLProgram(vBuffer, fBuffer);
}

GLuint createVBO(GLenum target, int usage, int datSize, void *data)
{
    //创建顶点缓冲对象
    GLuint vbo;
    glGenBuffers(1, &vbo);
    
    //将顶点缓存对象设置为当前指定类型的的缓存对象
    glBindBuffer(target, vbo);
    
    //为顶点缓存对象分配空间
    //datasize为缓存区大小
    //data用于初始化缓存区的数据(当为NULL时 表示只分配空间,可在后续调用glBufferSubData进行初始化)
    //usage表示缓冲区类型,是否会被频烦修改(GL_STATIC_DRAW --> 不会被修改)
    glBufferData(target, datSize, data, usage);
    return vbo;
}

GLuint createTexture2D(GLenum format, int width, int height, void *data)
{
    GLuint texture;
    glGenTextures(1, &texture);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    glTexImage2D(GL_TEXTURE_2D, 0, format, width, height, 0, format, GL_UNSIGNED_BYTE, data);
    glBindTexture(GL_TEXTURE_2D, 0);
    return texture;
}
