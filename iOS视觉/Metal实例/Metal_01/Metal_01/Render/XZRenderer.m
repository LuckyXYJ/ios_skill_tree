//
//  XZRenderer.m
//  Metal_01
//
//  Created by xyj on 2019/6/12.
//  Copyright © 2019年 xyj. All rights reserved.
//

#import "XZRenderer.h"

@implementation XZRenderer
{
    id<MTLDevice> _device;
    id<MTLCommandQueue> _commandQueue;
}

//颜色结构体
typedef struct {
    float red, green, blue, alpha;
} Color;

//初始化
- (id)initWithMetalKitView:(MTKView *)mtkView
{
    self = [super init];
    if(self)
    {
        _device = mtkView.device;
        
        //所有应用程序需要与GPU交互的第一个对象是一个对象。MTLCommandQueue.
        //你使用MTLCommandQueue 去创建对象,并且加入MTLCommandBuffer 对象中.确保它们能够按照正确顺序发送到GPU.对于每一帧,一个新的MTLCommandBuffer 对象创建并且填满了由GPU执行的命令.
        _commandQueue = [_device newCommandQueue];
    }
    
    return self;
}

//设置颜色
- (Color)makeFancyColor
{
    //1. 增加颜色/减小颜色的 标记
    static BOOL       growing = YES;
    //2.颜色通道值(0~3)
    static NSUInteger primaryChannel = 0;
    //3.颜色通道数组colorChannels(颜色值)
    static float      colorChannels[] = {1.0, 0.0, 0.0, 1.0};
    //4.颜色调整步长
    const float DynamicColorRate = 0.015;
    
    //5.判断
    if(growing)
    {
        //动态信道索引 (1,2,3,0)通道间切换
        NSUInteger dynamicChannelIndex = (primaryChannel+1)%3;
        
        //修改对应通道的颜色值 调整0.015
        colorChannels[dynamicChannelIndex] += DynamicColorRate;
        
        //当颜色通道对应的颜色值 = 1.0
        if(colorChannels[dynamicChannelIndex] >= 1.0)
        {
            //设置为NO
            growing = NO;
            
            //将颜色通道修改为动态颜色通道
            primaryChannel = dynamicChannelIndex;
        }
    }
    else
    {
        //获取动态颜色通道
        NSUInteger dynamicChannelIndex = (primaryChannel+2)%3;
        
        //将当前颜色的值 减去0.015
        colorChannels[dynamicChannelIndex] -= DynamicColorRate;
        
        //当颜色值小于等于0.0
        if(colorChannels[dynamicChannelIndex] <= 0.0)
        {
            //又调整为颜色增加
            growing = YES;
        }
    }
    
    //创建颜色
    Color color;
    
    //修改颜色的RGBA的值
    color.red   = colorChannels[0];
    color.green = colorChannels[1];
    color.blue  = colorChannels[2];
    color.alpha = colorChannels[3];
    
    //返回颜色
    return color;
}

#pragma mark - MTKViewDelegate methods

//每当视图需要渲染时调用
- (void)drawInMTKView:(nonnull MTKView *)view
{
    //1. 获取颜色值
    Color color = [self makeFancyColor];
    //2. 设置view的clearColor
    view.clearColor = MTLClearColorMake(color.red, color.green, color.blue, color.alpha);
    
    //3. Create a new command buffer for each render pass to the current drawable
    //使用MTLCommandQueue 创建对象并且加入到MTCommandBuffer对象中去.
    //为当前渲染的每个渲染传递创建一个新的命令缓冲区
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    commandBuffer.label = @"MyCommand";
    
    //4.从视图绘制中,获得渲染描述符
    MTLRenderPassDescriptor *renderPassDescriptor = view.currentRenderPassDescriptor;
    
    //5.判断renderPassDescriptor 渲染描述符是否创建成功,否则则跳过任何渲染.
    if(renderPassDescriptor != nil)
    {
        //6.通过渲染描述符renderPassDescriptor创建MTLRenderCommandEncoder 对象
        id<MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
        renderEncoder.label = @"MyRenderEncoder";
        
        //7.我们可以使用MTLRenderCommandEncoder 来绘制对象,但是这个demo我们仅仅创建编码器就可以了,我们并没有让Metal去执行我们绘制的东西,这个时候表示我们的任务已经完成.
        //即可结束MTLRenderCommandEncoder 工作
        [renderEncoder endEncoding];
        
        /*
         当编码器结束之后,命令缓存区就会接受到2个命令.
         1) present
         2) commit
         因为GPU是不会直接绘制到屏幕上,因此你不给出去指令.是不会有任何内容渲染到屏幕上.  
        */
        //8.添加一个最后的命令来显示清除的可绘制的屏幕
        [commandBuffer presentDrawable:view.currentDrawable];
    }
    
    //9.在这里完成渲染并将命令缓冲区提交给GPU
    [commandBuffer commit];
}

//当MTKView视图发生大小改变时调用
- (void)mtkView:(MTKView *)view drawableSizeWillChange:(CGSize)size
{
    
}

@end
