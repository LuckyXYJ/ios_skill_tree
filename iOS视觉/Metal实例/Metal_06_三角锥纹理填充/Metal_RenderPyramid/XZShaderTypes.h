//
//  XZShaderTypes.h
//  Metal_RenderPyramid
//
//  Created by xyj on 2019/6/23.
//  Copyright © 2019年 xyj. All rights reserved.
//

#ifndef XZShaderTypes_h
#define XZShaderTypes_h
#include <simd/simd.h>

//顶点数据结构
typedef struct
{
    vector_float4 position;          //顶点
    vector_float3 color;             //颜色
    vector_float2 textureCoordinate; //纹理坐标
} CCVertex;


//矩阵结构体
typedef struct
{
    matrix_float4x4 projectionMatrix; //投影矩阵
    matrix_float4x4 modelViewMatrix;  //模型视图矩阵
} CCMatrix;


//输入索引
typedef enum CCVertexInputIndex
{
    CCVertexInputIndexVertices     = 0, //顶点坐标索引
    CCVertexInputIndexMatrix       = 1, //矩阵索引
} CCVertexInputIndex;


//片元着色器索引
typedef enum CCFragmentInputIndex
{
    CCFragmentInputIndexTexture     = 0,//片元输入纹理索引
} CCFragmentInputIndex;


#endif /* XZShaderTypes_h */
