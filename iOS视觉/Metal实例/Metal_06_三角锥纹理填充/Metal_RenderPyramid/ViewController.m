//
//  ViewController.m
//  Metal_RenderPyramid
//
//  Created by xyj on 2019/6/23.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "ViewController.h"
#import "XZShaderTypes.h"

@import MetalKit;
@import GLKit;

@interface ViewController ()<MTKViewDelegate>

//rotationXYZ,slider
@property (weak, nonatomic) IBOutlet UISwitch *rotationX;
@property (weak, nonatomic) IBOutlet UISwitch *rotationY;
@property (weak, nonatomic) IBOutlet UISwitch *rotationZ;
@property (weak, nonatomic) IBOutlet UISlider *slider;

//mtkView
@property (nonatomic, strong) MTKView *mtkView;
//视口
@property (nonatomic, assign) vector_uint2 viewportSize;
//渲染管道
@property (nonatomic, strong) id<MTLRenderPipelineState> pipelineState;
//命令队列
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
//纹理
@property (nonatomic, strong) id<MTLTexture> texture;
//顶点缓存区
@property (nonatomic, strong) id<MTLBuffer> vertices;
//索引缓存区
@property (nonatomic, strong) id<MTLBuffer> indexs;
//索引个数
@property (nonatomic, assign) NSUInteger indexCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1. MTKView 初始化
    [self setupMtkView];
    //2. 管道初始化
    [self setupPipeline];
    //3. 顶点数据初始化
    [self setupVertex];
    //4.纹理初始化
    [self setupTexture];
  
}

#pragma mark -- setup init

-(void)setupMtkView
{
    //1. 获取MTKView
    self.mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    //设置device,一个MTLDevice 对象就代表这着一个GPU,通常我们可以调用方法MTLCreateSystemDefaultDevice()来获取代表默认的GPU单个对象.
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    //将mtkView 添加到self.view 上
    [self.view insertSubview:self.mtkView atIndex:0];
    
    //2.设置代理(viewController 实现)
    self.mtkView.delegate = self;
    
    //3. 获取viewportSize
    self.viewportSize = (vector_uint2){self.mtkView.drawableSize.width, self.mtkView.drawableSize.height};
    
}

-(void)setupPipeline {
    //1.在项目中加载所有的着色器文件
    id<MTLLibrary> defaultLibrary = [self.mtkView.device newDefaultLibrary];
    //从库中加载顶点函数
    id<MTLFunction> vertexFunction = [defaultLibrary newFunctionWithName:@"vertexShader"];
    //从库中加载片元函数
    id<MTLFunction> fragmentFunction = [defaultLibrary newFunctionWithName:@"samplingShader"];
    
    //2.创建渲染管道描述符
    MTLRenderPipelineDescriptor *pipelineStateDescriptor = [[MTLRenderPipelineDescriptor alloc] init];
    //可编程函数,用于处理渲染过程中的各个顶点
    pipelineStateDescriptor.vertexFunction = vertexFunction;
    //可编程函数,用于处理渲染过程总的各个片段/片元
    pipelineStateDescriptor.fragmentFunction = fragmentFunction;
    //设置管道中存储颜色数据的组件格式
    pipelineStateDescriptor.colorAttachments[0].pixelFormat = self.mtkView.colorPixelFormat;
    
    //3. 设置渲染管道
    self.pipelineState = [self.mtkView.device newRenderPipelineStateWithDescriptor:pipelineStateDescriptor error:NULL];
    
    //4. 创建命令队列
    self.commandQueue = [self.mtkView.device newCommandQueue];
}


- (void)setupVertex {
    
    //1.金字塔的顶点坐标,顶点颜色,纹理坐标数据
    static const CCVertex quadVertices[] =
    {  // 顶点坐标                          顶点颜色                    纹理坐标
        {{-0.5f, 0.5f, 0.0f, 1.0f},      {0.0f, 0.0f, 0.5f},       {0.0f, 1.0f}},//左上
        {{0.5f, 0.5f, 0.0f, 1.0f},       {0.0f, 0.5f, 0.0f},       {1.0f, 1.0f}},//右上
        {{-0.5f, -0.5f, 0.0f, 1.0f},     {0.5f, 0.0f, 1.0f},       {0.0f, 0.0f}},//左下
        {{0.5f, -0.5f, 0.0f, 1.0f},      {0.0f, 0.0f, 0.5f},       {1.0f, 0.0f}},//右下
        {{0.0f, 0.0f, 1.0f, 1.0f},       {1.0f, 1.0f, 1.0f},       {0.5f, 0.5f}},//顶点
    };
    
    //2.创建顶点数组缓存区 开辟空间
    self.vertices = [self.mtkView.device newBufferWithBytes:quadVertices
                                                     length:sizeof(quadVertices)
                                            options:MTLResourceStorageModeShared];
   
    //3.索引数组
    static int indices[] =
    { // 索引
        0, 3, 2,
        0, 1, 3,
        0, 2, 4,
        0, 4, 1,
        2, 3, 4,
        1, 4, 3,
    };
    
    //4.创建索引数组缓存区
    self.indexs = [self.mtkView.device newBufferWithBytes:indices
                                                   length:sizeof(indices)
                                            options:MTLResourceStorageModeShared];
    
    //5.计算索引个数
    self.indexCount = sizeof(indices) / sizeof(int);
}


- (void)setupTexture {
    
    //1.获取图片
    UIImage *image = [UIImage imageNamed:@"ziqi.jpeg"];
    //2.纹理描述符
    MTLTextureDescriptor *textureDescriptor = [[MTLTextureDescriptor alloc] init];
    //表示每个像素有蓝色,绿色,红色和alpha通道.其中每个通道都是8位无符号归一化的值.(即0映射成0,255映射成1);
    textureDescriptor.pixelFormat = MTLPixelFormatRGBA8Unorm;
    //设置纹理的像素尺寸
    textureDescriptor.width = image.size.width;
    textureDescriptor.height = image.size.height;
    
    //3.使用描述符从设备中创建纹理
    _texture = [self.mtkView.device newTextureWithDescriptor:textureDescriptor];
    
    /*
     typedef struct
     {
     MTLOrigin origin; //开始位置x,y,z
     MTLSize   size; //尺寸width,height,depth
     } MTLRegion;
     */
    //MLRegion结构用于标识纹理的特定区域。 demo使用图像数据填充整个纹理；因此，覆盖整个纹理的像素区域等于纹理的尺寸。
    //4. 创建MTLRegion 结构体  [纹理上传的范围]
    MTLRegion region = {{ 0, 0, 0 }, {image.size.width, image.size.height, 1}};
    
    //5.获取图片数据
    Byte *imageBytes = [self loadImage:image];
    
    //6.UIImage的数据需要转成二进制才能上传，且不用jpg、png的NSData
    if (imageBytes) {
        [_texture replaceRegion:region
                    mipmapLevel:0
                      withBytes:imageBytes
                    bytesPerRow:4 * image.size.width];
        free(imageBytes);
        imageBytes = NULL;
    }
}

//从UIImage 中读取Byte 数据返回
- (Byte *)loadImage:(UIImage *)image {
    // 1.获取图片的CGImageRef
    CGImageRef spriteImage = image.CGImage;
    
    // 2.读取图片的大小
    size_t width = CGImageGetWidth(spriteImage);
    size_t height = CGImageGetHeight(spriteImage);
    
    //3.计算图片大小.rgba共4个byte
    Byte * spriteData = (Byte *) calloc(width * height * 4, sizeof(Byte));
    
    //4.创建画布
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, width, height, 8, width*4, CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
    
    //5.在CGContextRef上绘图
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, width, height), spriteImage);
    
    //6.图片翻转过来
    CGRect rect = CGRectMake(0, 0, width, height);
    CGContextTranslateCTM(spriteContext, rect.origin.x, rect.origin.y);
    CGContextTranslateCTM(spriteContext, 0, rect.size.height);
    CGContextScaleCTM(spriteContext, 1.0, -1.0);
    CGContextTranslateCTM(spriteContext, -rect.origin.x, -rect.origin.y);
    CGContextDrawImage(spriteContext, rect, spriteImage);
    
    //7.释放spriteContext
    CGContextRelease(spriteContext);
    
    return spriteData;
}


#pragma mark - delegate
//每当视图改变方向或调整大小时调用
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size {
    
    // 保存可绘制的大小，因为当我们绘制时，我们将把这些值传递给顶点着色器
    self.viewportSize = (vector_uint2){size.width, size.height};
}

// 每当视图需要渲染帧时调用
- (void)drawInMTKView:(MTKView *)view {
    
    //1. 为当前渲染的每个渲染传递创建一个新的命令缓存区
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    
    //2. 渲染描述符(currentRenderPassDescriptor描述符包含currentDrawable's的纹理、视图的深度、模板和sample缓冲区和清晰的值。)
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    //判断是否获取成功
    if(renderPassDescriptor != nil)
    {
        //3. 修改渲染描述符的信息(在之前的课程案例没有使用过,但是是可以修改的)
        //修改背景颜色
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.6, 0.2, 0.5, 1.0f);
        
        //MTLLoadActionClear : 将写入指定附件中的每个像素
        //loadAction 颜色附着点加载方式
        renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
        
        //4.创建渲染编码器(根据渲染描述信息)
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        
        //设置视口
        [renderEncoder setViewport:(MTLViewport){0.0, 0.0, self.viewportSize.x, self.viewportSize.y, -1.0, 1.0 }];
        
        //设置渲染管道
        [renderEncoder setRenderPipelineState:self.pipelineState];
        
        //设置投影矩阵/渲染矩阵
        [self setupMatrixWithEncoder:renderEncoder];
        
        //将顶点数据->顶点函数
        [renderEncoder setVertexBuffer:self.vertices
                                offset:0
                               atIndex:CCVertexInputIndexVertices];
        
        //设置正背面剔除中,逆时钟三角形为正面
        [renderEncoder setFrontFacingWinding:MTLWindingCounterClockwise];
        //设置正背面剔除,背面剔除
        [renderEncoder setCullMode:MTLCullModeBack];
        
        //给片元着色器传递纹理
        [renderEncoder setFragmentTexture:self.texture atIndex:CCFragmentInputIndexTexture];
        
        //开始绘制(索引绘图)
        [renderEncoder drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                                  indexCount:self.indexCount
                                   indexType:MTLIndexTypeUInt32
                                 indexBuffer:self.indexs
                           indexBufferOffset:0];
        //编码介绍
        [renderEncoder endEncoding];
        
        //一旦框架缓冲区完成，使用当前可绘制的进度表
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    //最后,在这里完成渲染并将命令缓冲区推送到GPU
    [commandBuffer commit];
}

#pragma mark -- ModelViewMatrix/ProjectionMatrix
/**
 找了很多文档，都没有发现metalKit或者simd相关的接口可以快捷创建矩阵的，于是只能从GLKit里面借力
 @param matrix GLKit的矩阵
 @return metal用的矩阵
 */
- (matrix_float4x4)getMetalMatrixFromGLKMatrix:(GLKMatrix4)matrix {
    
    matrix_float4x4 ret = (matrix_float4x4){
        simd_make_float4(matrix.m00, matrix.m01, matrix.m02, matrix.m03),
        simd_make_float4(matrix.m10, matrix.m11, matrix.m12, matrix.m13),
        simd_make_float4(matrix.m20, matrix.m21, matrix.m22, matrix.m23),
        simd_make_float4(matrix.m30, matrix.m31, matrix.m32, matrix.m33),
    };
    return ret;
}

//设置
- (void)setupMatrixWithEncoder:(id<MTLRenderCommandEncoder>)renderEncoder {
    
    
    CGSize size = self.view.bounds.size;
    //纵横比
    float aspect = fabs(size.width / size.height);
    
    //1.投影矩阵
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(90.0), aspect, 0.1f, 10.f);
    
    //2.模型视图矩阵
    GLKMatrix4 modelViewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0.0f, 0.0f, -2.0f);
   
    //x=0,y=0,z=180.
    static float x = 0.0, y = 0.0, z = M_PI;
    
    //3.判断X/Y/Z的开关状态
    if (self.rotationX.on) {
        //修改旋转的角度
        x += self.slider.value;
    }
    if (self.rotationY.on) {
        y += self.slider.value;
    }
    if (self.rotationZ.on) {
        z += self.slider.value;
    }
    
    //4.将矩阵围绕(x,y,z)轴,渲染相应的角度
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, x, 1, 0, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, y, 0, 1, 0);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, z, 0, 0, 1);
    
    //5.将GLKit Matrix -> MetalKit Matrix;
    matrix_float4x4 pm = [self getMetalMatrixFromGLKMatrix:projectionMatrix];
    matrix_float4x4 mm = [self getMetalMatrixFromGLKMatrix:modelViewMatrix];
    
    //6.将投影矩阵,模型视图矩阵 加载到CCMatrix
    CCMatrix matrix = {pm,mm};
    
    //7.将matirx 数据通过renderEncoder 传递到顶点/片元函数中使用
    [renderEncoder setVertexBytes:&matrix
                           length:sizeof(matrix)
                          atIndex:CCVertexInputIndexMatrix];
}

@end
