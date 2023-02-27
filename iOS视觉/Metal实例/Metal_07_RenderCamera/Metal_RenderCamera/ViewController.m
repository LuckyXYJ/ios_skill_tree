//
//  ViewController.m
//  Metal_RenderCamera
//
//  Created by xyj on 2019/6/25.
//  Copyright © 2019年 xyj. All rights reserved.
//
@import MetalKit;
@import GLKit;
@import AVFoundation;
@import CoreMedia;

#import "ViewController.h"
#import <MetalPerformanceShaders/MetalPerformanceShaders.h>

@interface ViewController () <MTKViewDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

//MTKView
@property (nonatomic, strong) MTKView *mtkView;

//负责输入和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *mCaptureSession;
//负责从AVCaptureDevice获得输入数据
@property (nonatomic, strong) AVCaptureDeviceInput *mCaptureDeviceInput;
//输出设备
@property (nonatomic, strong) AVCaptureVideoDataOutput *mCaptureDeviceOutput;
//处理队列
@property (nonatomic, strong) dispatch_queue_t mProcessQueue;
//纹理缓存区
@property (nonatomic, assign) CVMetalTextureCacheRef textureCache;
//命令队列
@property (nonatomic, strong) id<MTLCommandQueue> commandQueue;
//纹理
@property (nonatomic, strong) id<MTLTexture> texture;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //1. setupMetal
    [self setupMetal];
    //2. setupAVFoundation
    [self setupCaptureSession];
 
}

#pragma mark -- setup init

-(void)setupMetal{
    
    //1.获取MTKView
    self.mtkView = [[MTKView alloc] initWithFrame:self.view.bounds];
    self.mtkView.device = MTLCreateSystemDefaultDevice();
    [self.view insertSubview:self.mtkView atIndex:0];
    self.mtkView.delegate = self;
    
    //2.创建命令队列.
    self.commandQueue = [self.mtkView.device newCommandQueue];
    
    //3.注意: 在初始化MTKView 的基本操作以外. 还需要多下面2行代码.
    /*
     1. 设置MTKView 的drawable 纹理是可读写的(默认是只读);
     2. 创建CVMetalTextureCacheRef _textureCache; 这是Core Video的Metal纹理缓存
     */
    //允许读写操作
    self.mtkView.framebufferOnly = NO;
    /*
     CVMetalTextureCacheCreate(CFAllocatorRef  allocator,
     CFDictionaryRef cacheAttributes,
     id <MTLDevice>  metalDevice,
     CFDictionaryRef  textureAttributes,
     CVMetalTextureCacheRef * CV_NONNULL cacheOut )
     
     功能: 创建纹理缓存区
     参数1: allocator 内存分配器.默认即可.NULL
     参数2: cacheAttributes 缓存区行为字典.默认为NULL
     参数3: metalDevice
     参数4: textureAttributes 缓存创建纹理选项的字典. 使用默认选项NULL
     参数5: cacheOut 返回时，包含新创建的纹理缓存。
     
     */
    CVMetalTextureCacheCreate(NULL, NULL, self.mtkView.device, NULL, &_textureCache);
    
}

//AVFoundation 视频采集
- (void)setupCaptureSession {
    
    //1.创建mCaptureSession
    self.mCaptureSession = [[AVCaptureSession alloc] init];
    //设置视频采集的分辨率
    self.mCaptureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
  
    //2.创建串行队列
    self.mProcessQueue = dispatch_queue_create("mProcessQueue", DISPATCH_QUEUE_SERIAL);
   
    //3.获取摄像头设备(前置/后置摄像头设备)
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *inputCamera = nil;
    //循环设备数组,找到后置摄像头.设置为当前inputCamera
    for (AVCaptureDevice *device in devices) {
        if ([device position] == AVCaptureDevicePositionBack) {
            inputCamera = device;
        }
    }
    
    //4.将AVCaptureDevice 转换为AVCaptureDeviceInput
    self.mCaptureDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:inputCamera error:nil];
    
    //5. 将设备添加到mCaptureSession中
    if ([self.mCaptureSession canAddInput:self.mCaptureDeviceInput]) {
        [self.mCaptureSession addInput:self.mCaptureDeviceInput];
    }
    
    //6.创建AVCaptureVideoDataOutput 对象
    self.mCaptureDeviceOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    /*设置视频帧延迟到底时是否丢弃数据.
     YES: 处理现有帧的调度队列在captureOutput:didOutputSampleBuffer:FromConnection:Delegate方法中被阻止时，对象会立即丢弃捕获的帧。
     NO: 在丢弃新帧之前，允许委托有更多的时间处理旧帧，但这样可能会内存增加.
     */
    [self.mCaptureDeviceOutput setAlwaysDiscardsLateVideoFrames:NO];
    
    //这里设置格式为BGRA，而不用YUV的颜色空间，避免使用Shader转换
    //注意:这里必须和后面CVMetalTextureCacheCreateTextureFromImage 保存图像像素存储格式保持一致.否则视频会出现异常现象.
    [self.mCaptureDeviceOutput setVideoSettings:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey]];
    
    //设置视频捕捉输出的代理方法
    [self.mCaptureDeviceOutput setSampleBufferDelegate:self queue:self.mProcessQueue];
    
    //7.添加输出
    if ([self.mCaptureSession canAddOutput:self.mCaptureDeviceOutput]) {
        [self.mCaptureSession addOutput:self.mCaptureDeviceOutput];
    }
    
    //8.输入与输出链接
    AVCaptureConnection *connection = [self.mCaptureDeviceOutput connectionWithMediaType:AVMediaTypeVideo];
    
    //9.设置视频方向
    //注意: 一定要设置视频方向.否则视频会是朝向异常的.
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    //10.开始捕捉
    [self.mCaptureSession startRunning];
    
}

#pragma mark - AVFoundation Delegate

//AVFoundation 视频采集回调方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    //1.从sampleBuffer 获取视频像素缓存区对象
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
   
    //2.获取捕捉视频的宽和高
    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    
    /*3. 根据视频像素缓存区 创建 Metal 纹理缓存区
     CVReturn CVMetalTextureCacheCreateTextureFromImage(CFAllocatorRef allocator,                         CVMetalTextureCacheRef textureCache,
     CVImageBufferRef sourceImage,
     CFDictionaryRef textureAttributes,
     MTLPixelFormat pixelFormat,
     size_t width,
     size_t height,
     size_t planeIndex,
     CVMetalTextureRef  *textureOut);
     
     功能: 从现有图像缓冲区创建核心视频Metal纹理缓冲区。
     参数1: allocator 内存分配器,默认kCFAllocatorDefault
     参数2: textureCache 纹理缓存区对象
     参数3: sourceImage 视频图像缓冲区
     参数4: textureAttributes 纹理参数字典.默认为NULL
     参数5: pixelFormat 图像缓存区数据的Metal 像素格式常量.注意如果MTLPixelFormatBGRA8Unorm和摄像头采集时设置的颜色格式不一致，则会出现图像异常的情况；
     参数6: width,纹理图像的宽度（像素）
     参数7: height,纹理图像的高度（像素）
     参数8: planeIndex.如果图像缓冲区是平面的，则为映射纹理数据的平面索引。对于非平面图像缓冲区忽略。
     参数9: textureOut,返回时，返回创建的Metal纹理缓冲区。
     
     // Mapping a BGRA buffer:
     CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, MTLPixelFormatBGRA8Unorm, width, height, 0, &outTexture);
     
     // Mapping the luma plane of a 420v buffer:
     CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, MTLPixelFormatR8Unorm, width, height, 0, &outTexture);
     
     // Mapping the chroma plane of a 420v buffer as a source texture:
     CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, MTLPixelFormatRG8Unorm width/2, height/2, 1, &outTexture);
     
     // Mapping a yuvs buffer as a source texture (note: yuvs/f and 2vuy are unpacked and resampled -- not colorspace converted)
     CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, textureCache, pixelBuffer, NULL, MTLPixelFormatGBGR422, width, height, 1, &outTexture);
     
     */
    CVMetalTextureRef tmpTexture = NULL;
    CVReturn status = CVMetalTextureCacheCreateTextureFromImage(kCFAllocatorDefault, self.textureCache, pixelBuffer, NULL, MTLPixelFormatBGRA8Unorm, width, height, 0, &tmpTexture);
    
    //4.判断tmpTexture 是否创建成功
    if(status == kCVReturnSuccess)
    {
        //5.设置可绘制纹理的当前大小。
        self.mtkView.drawableSize = CGSizeMake(width, height);
        //6.返回纹理缓冲区的Metal纹理对象。
        self.texture = CVMetalTextureGetTexture(tmpTexture);
        //7.使用完毕,则释放tmpTexture
        CFRelease(tmpTexture);
    }
}


#pragma mark - MTKView Delegate

//视图大小发生改变时.会调用此方法
- (void)mtkView:(nonnull MTKView *)view drawableSizeWillChange:(CGSize)size {
    
}

//视图渲染则会调用此方法
- (void)drawInMTKView:(MTKView *)view {
  
    //1.判断是否获取了AVFoundation 采集的纹理数据
    if (self.texture) {
        
        //2.创建指令缓冲
        id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
        
        //3.将MTKView 作为目标渲染纹理
        id<MTLTexture> drawingTexture = view.currentDrawable.texture;
        
        //4.设置滤镜
        /*
         MetalPerformanceShaders是Metal的一个集成库，有一些滤镜处理的Metal实现;
         MPSImageGaussianBlur 高斯模糊处理;
         */
       
        //创建高斯滤镜处理filter
        //注意:sigma值可以修改，sigma值越高图像越模糊;
        MPSImageGaussianBlur *filter = [[MPSImageGaussianBlur alloc] initWithDevice:self.mtkView.device sigma:1];
        
        //5.MPSImageGaussianBlur以一个Metal纹理作为输入，以一个Metal纹理作为输出；
        //输入:摄像头采集的图像 self.texture
        //输出:创建的纹理 drawingTexture(其实就是view.currentDrawable.texture)
        [filter encodeToCommandBuffer:commandBuffer sourceTexture:self.texture destinationTexture:drawingTexture];
        
        //6.展示显示的内容
        [commandBuffer presentDrawable:view.currentDrawable];
        
        //7.提交命令
        [commandBuffer commit];
        
        //8.清空当前纹理,准备下一次的纹理数据读取.
        self.texture = NULL;
    }
}






@end
