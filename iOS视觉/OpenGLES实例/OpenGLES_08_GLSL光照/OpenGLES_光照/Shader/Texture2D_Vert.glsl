#version 300 es

layout(location = 0) in vec3 position;  //顶点
layout(location = 1) in vec3 normal;    //法向量
layout(location = 2) in vec2 texCoord;  //纹理坐标

uniform mat4 view;
uniform mat4 projection;

out vec3 outNormal; //法向量
out vec3 FragPo;    //顶点在世界坐标位置
out vec2 outTexCoord;//纹理坐标

void main()
{

    FragPo = position;
    outNormal = normal;
    outTexCoord = texCoord;
    gl_Position = projection * view * vec4(position,1.0);
    
}
