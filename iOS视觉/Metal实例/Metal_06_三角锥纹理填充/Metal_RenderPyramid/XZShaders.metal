//
//  XZShaders.metal
//  Metal_RenderPyramid
//
//  Created by xyj on 2019/6/23.
//  Copyright © 2019年 xyj. All rights reserved.
//

#include <metal_stdlib>
// 导入Metal shader 代码和执行Metal API命令的C代码之间共享的头
#import"XZShaderTypes.h"
//使用命名空间 Metal
using namespace metal;

// 顶点着色器输出和片段着色器输入
//结构体
typedef struct
{
    //处理空间的顶点信息
    float4 clipSpacePosition [[position]];
    //颜色
    float3 pixelColor;
    //纹理坐标
    float2 textureCoordinate;
    
} RasterizerData;

//顶点函数
vertex RasterizerData
vertexShader(uint vertexID [[ vertex_id ]],
             constant CCVertex *vertexArray [[ buffer(CCVertexInputIndexVertices) ]],
             constant CCMatrix *matrix [[ buffer(CCVertexInputIndexMatrix) ]])
{
    //1.定义输出out
    RasterizerData out;
    //计算裁剪空间坐标 = 投影矩阵 * 模型矩阵 * 顶点
    out.clipSpacePosition = matrix->projectionMatrix * matrix->modelViewMatrix * vertexArray[vertexID].position;
    //纹理坐标 = vertexArray[vertexID].textureCoordinate
    out.textureCoordinate = vertexArray[vertexID].textureCoordinate;
    //像素颜色值 = vertexArray[vertexID].color;
    out.pixelColor = vertexArray[vertexID].color;
    
    return out;
}

// 片元函数
fragment float4
samplingShader(RasterizerData input [[stage_in]],
               texture2d<half> textureColor [[ texture(CCFragmentInputIndexTexture) ]])
{
    //颜色值 从三维变量RGB -> 四维变量RGBA
    //half4 colorTex = half4(input.pixelColor.x, input.pixelColor.y, input.pixelColor.z, 1);
    //Sampler是采样器，决定如何对一个纹理进行采样操作.在Metal程序里初始化的采样器必须使用constexpr修饰符声明。 采样器指针和引用是不支持的，将会导致编译错误
    
    constexpr sampler textureSampler (mag_filter::linear
                                      ,min_filter::linear);
   
    half4 colorTex = textureColor.sample(textureSampler, input.textureCoordinate);

    //返回颜色
    return float4(colorTex);
}
