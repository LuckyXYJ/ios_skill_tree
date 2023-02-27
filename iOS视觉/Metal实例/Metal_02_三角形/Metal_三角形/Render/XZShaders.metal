//
//  XZShaders.metal
//  Metal_三角形
//
//  Created by xyj on 2019/6/14.
//  Copyright © 2019年 xyj. All rights reserved.
//


#include <metal_stdlib>
//使用命名空间 Metal
using namespace metal;

// 导入Metal shader 代码和执行Metal API命令的C代码之间共享的头
#import "XZShaderTypes.h"

// 顶点着色器输出和片段着色器输入
//结构体
typedef struct
{
    //处理空间的顶点信息
    float4 clipSpacePosition [[position]];

    //颜色
    float4 color;

} RasterizerData;

//顶点着色函数
vertex RasterizerData
vertexShader(uint vertexID [[vertex_id]],
             constant CCVertex *vertices [[buffer(CCVertexInputIndexVertices)]],
             constant vector_uint2 *viewportSizePointer [[buffer(CCVertexInputIndexViewportSize)]])
{
    /*
     处理顶点数据:
        1) 执行坐标系转换,将生成的顶点剪辑空间写入到返回值中.
        2) 将顶点颜色值传递给返回值
     */
    
    //定义out
    RasterizerData out; 

    //初始化输出剪辑空间位置
    out.clipSpacePosition = vector_float4(0.0, 0.0, 0.0, 1.0);

    // 索引到我们的数组位置以获得当前顶点
    // 我们的位置是在像素维度中指定的.
    float2 pixelSpacePosition = vertices[vertexID].position.xy;

    //将vierportSizePointer 从verctor_uint2 转换为vector_float2 类型
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);

    //每个顶点着色器的输出位置在剪辑空间中(也称为归一化设备坐标空间,NDC),剪辑空间中的(-1,-1)表示视口的左下角,而(1,1)表示视口的右上角.
    //计算和写入 XY值到我们的剪辑空间的位置.为了从像素空间中的位置转换到剪辑空间的位置,我们将像素坐标除以视口的大小的一半.
    out.clipSpacePosition.xy = pixelSpacePosition / (viewportSize / 2.0);

    //把我们输入的颜色直接赋值给输出颜色. 这个值将于构成三角形的顶点的其他颜色值插值,从而为我们片段着色器中的每个片段生成颜色值.
    out.color = vertices[vertexID].color;

    //完成! 将结构体传递到管道中下一个阶段:
    return out;
}

//当顶点函数执行3次,三角形的每个顶点执行一次后,则执行管道中的下一个阶段.栅格化/光栅化.


// 片元函数
//[[stage_in]],片元着色函数使用的单个片元输入数据是由顶点着色函数输出.然后经过光栅化生成的.单个片元输入函数数据可以使用"[[stage_in]]"属性修饰符.
//一个顶点着色函数可以读取单个顶点的输入数据,这些输入数据存储于参数传递的缓存中,使用顶点和实例ID在这些缓存中寻址.读取到单个顶点的数据.另外,单个顶点输入数据也可以通过使用"[[stage_in]]"属性修饰符的产生传递给顶点着色函数.
//被stage_in 修饰的结构体的成员不能是如下这些.Packed vectors 紧密填充类型向量,matrices 矩阵,structs 结构体,references or pointers to type 某类型的引用或指针. arrays,vectors,matrices 标量,向量,矩阵数组.
fragment float4 fragmentShader(RasterizerData in [[stage_in]])
{
    
    //返回输入的片元颜色
    return in.color;
}

