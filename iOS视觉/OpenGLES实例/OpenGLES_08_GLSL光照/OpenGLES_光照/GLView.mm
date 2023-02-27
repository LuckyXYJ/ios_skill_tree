//
//  GLView.m
//  OpenGLES_光照
//
//  Created by xyj on 2019/5/22.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "GLView.h"
#import <GLKit/GLKit.h>

#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>
#import "GLUtil.h"

EAGLContext* context;
GLuint renderBuf;
GLuint frameBuf;
GLuint depthBuf;
GLuint program;
unsigned int VBO;

//光源位置
GLKVector3 lightPo = {1.2f,1.0f,2.0f};

@implementation GLView

-(void)setupGL{
    
    //1.上下文初始化&设置当前上下文
    context = [[EAGLContext alloc] initWithAPI:(kEAGLRenderingAPIOpenGLES3)];
    BOOL isSetCOntextRight = [EAGLContext setCurrentContext:context];
    if (!isSetCOntextRight) {
        NSLog(@"设置Context失败");
    }
    
    //2.获取顶点着色器/图形片元着色器/光源片元着色器
    NSString* verStr = [[NSBundle mainBundle] pathForResource:@"Texture2D_Vert.glsl" ofType:nil];
    NSString* fragStr = [[NSBundle mainBundle]pathForResource:@"Texture2D_Frag.glsl" ofType:nil];
    
    //3.正方形箱子渲染program
    program = createGLProgramFromFile(verStr.UTF8String, fragStr.UTF8String);
    
    //4.使用program
    glUseProgram(program);
    
    //5.创建渲染缓存区(renderBuf)
    glGenRenderbuffers(1, &renderBuf);
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuf);
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
    
    int wi,he;
    //6.检索有关绑定缓冲区的对象的信息(width,height)
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &wi);
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &he);
    
    //7.创建深度缓冲区(depthBuf)
    glGenRenderbuffers(1, &depthBuf);
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuf);
    /*
     glRenderbufferStorage (GLenum target, GLenum internalformat, GLsizei width, GLsizei height)
     参数1:GL_RENDERBUFFER
     参数2:渲染格式
     参数3:width
     参数4:height
     */
    glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, wi, he);
    
    //8.将depthBuf/renderBuf ->Framebuffer
    glGenFramebuffers(1, &frameBuf);
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuf);
   
    glBindRenderbuffer(GL_RENDERBUFFER, depthBuf);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthBuf);
    
    glBindRenderbuffer(GL_RENDERBUFFER, renderBuf);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, renderBuf);
    

    //一个立方体坐标信息(6个面,每个面2个三角形)
    float vertices[] = {
        //顶点位置              //法线               //纹理坐标
        -0.5f, -0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  0.0f,  0.0f,
        0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,  1.0f,  0.0f,
        0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,  1.0f,  1.0f,
        0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,  1.0f,  1.0f,
        -0.5f,  0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  0.0f,  1.0f,
        -0.5f, -0.5f, -0.5f,   0.0f,  0.0f, -1.0f,  0.0f,  0.0f,
        
        -0.5f, -0.5f,  0.5f,   0.0f,  0.0f,  1.0f,  0.0f,  0.0f,
        0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,  1.0f,  0.0f,
        0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,  1.0f,  1.0f,
        0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,  1.0f,  1.0f,
        -0.5f,  0.5f,  0.5f,   0.0f,  0.0f,  1.0f,  0.0f,  1.0f,
        -0.5f, -0.5f,  0.5f,   0.0f,  0.0f,  1.0f,  0.0f,  0.0f,
        
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,  1.0f,  1.0f,
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,  0.0f,  1.0f,
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,  0.0f,  1.0f,
        -0.5f, -0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,  0.0f,  0.0f,
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,  1.0f,  0.0f,
        
        0.5f,  0.5f,  0.5f,    1.0f,  0.0f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f, -0.5f,    1.0f,  0.0f,  0.0f,  1.0f,  1.0f,
        0.5f, -0.5f, -0.5f,    1.0f,  0.0f,  0.0f,  0.0f,  1.0f,
        0.5f, -0.5f, -0.5f,    1.0f,  0.0f,  0.0f,  0.0f,  1.0f,
        0.5f, -0.5f,  0.5f,    1.0f,  0.0f,  0.0f,  0.0f,  0.0f,
        0.5f,  0.5f,  0.5f,    1.0f,  0.0f,  0.0f,  1.0f,  0.0f,
        
        -0.5f, -0.5f, -0.5f,   0.0f, -1.0f,  0.0f,  0.0f,  1.0f,
        0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,  1.0f,  1.0f,
        0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,  1.0f,  0.0f,
        0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,  1.0f,  0.0f,
        -0.5f, -0.5f,  0.5f,   0.0f, -1.0f,  0.0f,  0.0f,  0.0f,
        -0.5f, -0.5f, -0.5f,   0.0f, -1.0f,  0.0f,  0.0f,  1.0f,
        
        -0.5f,  0.5f, -0.5f,   0.0f,  1.0f,  0.0f,  0.0f,  1.0f,
        0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,  1.0f,  1.0f,
        0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,  1.0f,  0.0f,
        0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,  1.0f,  0.0f,
        -0.5f,  0.5f,  0.5f,   0.0f,  1.0f,  0.0f,  0.0f,  0.0f,
        -0.5f,  0.5f, -0.5f,   0.0f,  1.0f,  0.0f,  0.0f,  1.0f
    };
    
    //设置VBO 将顶点坐标/法线坐标/纹理坐标
    glGenBuffers(1, &VBO);
    glBindBuffer(GL_ARRAY_BUFFER, VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
    glEnableVertexAttribArray(2);
    
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), (void*)NULL);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 8*sizeof(float), (void*)(3*sizeof(float)));
    glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, 8*sizeof(float), (void*)(6*sizeof(float)));
    
    [self setupTextureBox:@"ziqi.jpg"];
    [self setupTextureSpecular:@"Box_specular.png"];
    
    //添加到渲染循环
    [self setupLinker];
    
    //[self render];
}

//从图片中加载纹理
- (void)setupTextureBox:(NSString *)fileName {
    
    //1、将 UIImage 转换为 CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    
    //判断图片是否获取成功
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    //2、读取图片的大小，宽和高
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    //3.获取图片字节数 宽*高*4（RGBA）
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
    
    //4.创建上下文
    /*
     参数1：data,指向要渲染的绘制图像的内存地址
     参数2：width,bitmap的宽度，单位为像素
     参数3：height,bitmap的高度，单位为像素
     参数4：bitPerComponent,内存中像素的每个组件的位数，比如32位RGBA，就设置为8
     参数5：bytesPerRow,bitmap的没一行的内存所占的比特数
     参数6：colorSpace,bitmap上使用的颜色空间  kCGImageAlphaPremultipliedLast：RGBA
     */
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    
    //5、在CGContextRef上--> 将图片绘制出来
    /*
     CGContextDrawImage 使用的是Core Graphics框架，坐标系与UIKit 不一样。UIKit框架的原点在屏幕的左上角，Core Graphics框架的原点在屏幕的左下角。
     CGContextDrawImage
     参数1：绘图上下文
     参数2：rect坐标
     参数3：绘制的图片
     */
    CGRect rect = CGRectMake(0, 0, width, height);
    
    //6.使用默认方式绘制
    CGContextDrawImage(spriteContext, rect, spriteImage);
    
    CGContextTranslateCTM(spriteContext, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(spriteContext, 0, rect.size.height);
    CGContextScaleCTM(spriteContext, 1.0, -1.0);
    CGContextTranslateCTM(spriteContext, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(spriteContext, rect, spriteImage);
    
    //7、画图完毕就释放上下文
    CGContextRelease(spriteContext);
    
    //绑定纹理并设置纹理参数
    unsigned int texture;
    
    glGenTextures(1, &texture);
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, texture);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    glGenerateMipmap(GL_TEXTURE_2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    free(spriteData);
    glUniform1i(glGetUniformLocation(program, "Material.Texture"), 0);
    
}


//从图片中加载纹理
- (void)setupTextureSpecular:(NSString *)fileName {
    
    //1、将 UIImage 转换为 CGImageRef
    CGImageRef spriteImage = [UIImage imageNamed:fileName].CGImage;
    
    //判断图片是否获取成功
    if (!spriteImage) {
        NSLog(@"Failed to load image %@", fileName);
        exit(1);
    }
    
    //2、读取图片的大小，宽和高
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    //3.获取图片字节数 宽*高*4（RGBA）
    GLubyte * spriteData = (GLubyte *) calloc(width * height * 4, sizeof(GLubyte));
    
    //4.创建上下文
    /*
     参数1：data,指向要渲染的绘制图像的内存地址
     参数2：width,bitmap的宽度，单位为像素
     参数3：height,bitmap的高度，单位为像素
     参数4：bitPerComponent,内存中像素的每个组件的位数，比如32位RGBA，就设置为8
     参数5：bytesPerRow,bitmap的没一行的内存所占的比特数
     参数6：colorSpace,bitmap上使用的颜色空间  kCGImageAlphaPremultipliedLast：RGBA
     */
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4,CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    
    //5、在CGContextRef上--> 将图片绘制出来
    /*
     CGContextDrawImage 使用的是Core Graphics框架，坐标系与UIKit 不一样。UIKit框架的原点在屏幕的左上角，Core Graphics框架的原点在屏幕的左下角。
     CGContextDrawImage
     参数1：绘图上下文
     参数2：rect坐标
     参数3：绘制的图片
     */
    CGRect rect = CGRectMake(0, 0, width, height);
    
    //6.使用默认方式绘制
    CGContextDrawImage(spriteContext, rect, spriteImage);
    
    CGContextTranslateCTM(spriteContext, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(spriteContext, 0, rect.size.height);
    CGContextScaleCTM(spriteContext, 1.0, -1.0);
    CGContextTranslateCTM(spriteContext, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(spriteContext, rect, spriteImage);
    
    //7、画图完毕就释放上下文
    CGContextRelease(spriteContext);
    
    unsigned int texture_specular;
    //绑定纹理并设置纹理参数
    glGenTextures(1, &texture_specular);
    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, texture_specular);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, (GLsizei)width, (GLsizei)height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
    
    glGenerateMipmap(GL_TEXTURE_2D);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    free(spriteData);
    glUniform1i(glGetUniformLocation(program, "Material.specularTexture"), 1);
 
}


-(void)render{

    glEnable(GL_DEPTH_TEST);
    
    glClearColor(1.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
  
    //光照颜色->片元/顶点着色器
    glUniform3f(glGetUniformLocation(program, "lightColor"), 1.0f, 1.0f, 1.0f);

    //投影矩阵->顶点着色器
    float aspect = (float)self.bounds.size.width / (float)self.bounds.size.height;
    GLKMatrix4 projectionMatrix =  GLKMatrix4MakePerspective(GLKMathRadiansToDegrees(45.0f), aspect, 0.1f, 800.0f) ;
    glUniformMatrix4fv(glGetUniformLocation(program, "projection"), 1, GL_FALSE, (GLfloat*)projectionMatrix.m);
    
    
    //模型视图矩阵-->顶点着色器
    float radius = 10.0f;
    float camX = sin(CACurrentMediaTime()) * radius;
    float camZ = cos(CACurrentMediaTime()) * radius;
    NSLog(@"%f,%f",camX,camZ);
    GLKVector3 viewPo = {camX,camX,camZ};
    //获取世界坐标系去模型矩阵中.
    /*
     LKMatrix4 GLKMatrix4MakeLookAt(float eyeX, float eyeY, float eyeZ,
     float centerX, float centerY, float centerZ,
     float upX, float upY, float upZ)
     等价于 OpenGL 中
     void gluLookAt(GLdouble eyex,GLdouble eyey,GLdouble eyez,GLdouble centerx,GLdouble centery,GLdouble centerz,GLdouble upx,GLdouble upy,GLdouble upz);
     
     目的:根据你的设置返回一个4x4矩阵变换的世界坐标系坐标。
     参数1:眼睛位置的x坐标
     参数2:眼睛位置的y坐标
     参数3:眼睛位置的z坐标
     第一组:就是脑袋的位置
     
     参数4:正在观察的点的X坐标
     参数5:正在观察的点的Y坐标
     参数6:正在观察的点的Z坐标
     第二组:就是眼睛所看物体的位置
     
     参数7:摄像机上向量的x坐标
     参数8:摄像机上向量的y坐标
     参数9:摄像机上向量的z坐标
     第三组:就是头顶朝向的方向(因为你可以头歪着的状态看物体)
     */
    
    GLKMatrix4 view1 = GLKMatrix4MakeLookAt(camX,camX,camZ,0,0,0,0,1,0);
    //GLKMatrix4 view1 = GLKMatrix4MakeLookAt(7,7,-10,0,0,0,0,1,0);
   
    view1 = GLKMatrix4Scale(view1, 5.0f, 5.0f, 5.0f);
    glUniformMatrix4fv(glGetUniformLocation(program, "view"), 1, GL_FALSE, (GLfloat *)view1.m);
    
    //光源位置
    glUniform3f(glGetUniformLocation(program, "lightPo"), lightPo.x, lightPo.y, lightPo.z);
    
    //观察者位置
    glUniform3f(glGetUniformLocation(program, "viewPo"), viewPo.x, viewPo.y, viewPo.z);
    
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
    
}


- (void)setupLinker
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CADisplayLink *linker = [CADisplayLink displayLinkWithTarget:self selector:@selector(render)];
        linker.preferredFramesPerSecond = 24;
        [linker addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    });
}

+(Class)layerClass{
    return [CAEAGLLayer class];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self setupGL];
}

- (void)dealloc {
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext: nil];
    }
}
@end
