## GLSL语言

xcode中不支持GLSL语言对顶点/片元着色器的编译和连接，因此需要在项目中创建两个空文件，分别命名为`shader.vsh`和`shaderv.fsh`

- 使用`vsh、fsh`后缀的原因是方便区分着色器，其本质就是一个字符串
- 是否可以直接使用NSString？并不建议这样做，因为代码结构不清晰，不易读
- 这两个文件中是否可以加中文注释？不建议加中文注释，会报奇怪的错误，由于在xcode中书写GLSL，完全是纯手写，没有任何提示，排查问题不好排查

### 向量数据类型

| 类型              | 描述                              |
| ----------------- | --------------------------------- |
| vec2,vec3,vec4    | 2分量、3分量、4分量浮点向量       |
| ivec2,ivec3,ivec4 | 2分量、3分量、4分量整型向量       |
| uvec2,uvec3,uvec4 | 2分量、3分量、4分量无符号整型向量 |
| bvec2,bvec3,bvec4 | 2分量、3分量、4分量bool型向量     |

常用的是`vec2、vec3、vec4`，默认是浮点类型

### 矩阵数据类型

| 类型（mat列×行） | 描述     |
| ---------------- | -------- |
| mat2,mat2x2      | 两⾏两列 |
| mat3,mat3x3      | 三行三列 |
| mat4,mat4x4      | 四行四列 |
| mat2x3           | 三行两列 |
| mat2x4           | 四行两列 |
| mat3x2           | 两行三列 |
| mat3x4           | 四行三列 |
| mat4x2           | 两行四列 |
| mat4x3           | 三行四列 |

常用的是`vec2、vec3、vec4`，默认是浮点类型

### 变量存储限定符

| 限定符                 | 描述                                               |
| ---------------------- | -------------------------------------------------- |
| <none>                 | 只是普通的本地变量，外部不见，外部不可访问         |
| const                  | ⼀个编译常量，或者说是⼀个对函数来说为只读的参数   |
| in/varying             | 从以前阶段传递过来的变量                           |
| in/varying centroid    | ⼀个从以前的阶段传递过来的变量，使⽤质⼼插值       |
| out/attribute          | 传递到下⼀个处理阶段或者在⼀个函数中指定⼀个返回值 |
| out/attribute centroid | 传递到下⼀个处理阶段，质心插值                     |
| uniform                | ⼀个从客户端代码传递过来的变量，在顶点之间不做改变 |

常用`varying、attribute、uniform`

- varying 修饰符：当需要将顶点着色器的数据传递到片元着色器时，两个着色器中一模一样的纹理坐标变量就需要它来修饰
- attribute：数据只能从客户端中传递到顶点着色器，且只能在顶点着色器中使用
  - 修饰的数据：顶点、纹理、颜色、法线等
  - API通常以`glVertex...`开头，例如`glVertexAttribPointer`
  - 其中的纹理坐标，需要顶点着色器间接传递到片元着色器，需要在顶点与片元着色器中定义一个一模一样的纹理坐标，通过这个变量将纹理坐标数据间接传递到片元着色器，`varying lowp vec2 varyTextCoord;`
  - 顶点着色器计算之后的顶点结果需要赋值给GLSL的内建变量`gl_Position`

```cpp
attribute vec4 position;
attribute vec2 textCoordinate;
varying lowp vec2 varyTextCoord;

void main()
{
    varyTextCoord = textCoordinate;
    gl_Position = position;
}
```

- uniform：从app代码传递到vertex、fragment中所用的变量
  - 在vertex，fragment中一般将uniform当成常量
  - uniform可以传的数据：视图矩阵、投影矩阵、投影视图矩阵
  - API通常以`glUniform...`开头
  - 片元着色器中最终颜色，即拿到纹理对应坐标下的纹素。纹素是纹理对应像素点的颜色值，需要通过内建函数`texture2D(纹理，纹理坐标)`计算，将最终返回的颜色值赋值给内建变量`gl_FragColor`

```cpp
//需要定义精度，否则可能会报错
precsion highp float;
//纹理坐标 必须与顶点着色器中一模一样,通过这个参数获取传递过来的值
varying lowp vec2 varyTextCoord;
//纹理 
uniform sampler2D colorMap;   

void main(){
    //1、拿到纹理对应坐标下的纹素。纹素是纹理对应像素点的颜色值
    lowp vec4 temp = texture2D(colorMap, varyTextCoord);
    
    //2、非常重要且必须的内建变量：gl_FragColor
    gl_FragColor = temp；
} 
```

## 着色器与程序 的编译 与链接

需要创建2个基本对象才能使用着色器进行传染：着色器对象和程序对象

获取链接后着色器对象一般的编译&链接分为6步：

- 创建一个顶点着色器对象和一个片元着色器对象
- 将源代码链接到每个着色器对象
- 编译着色器对象
- 创建一个程序对象
- 将编译后的着色器对象连接到程序对象
- 链接程序对象

## 常用API

### 自定义着色器

自定义着色器一般有以下步骤：

- 创建顶点着色器/片元着色器 --`glCreateShader`
- 指定shader的source --`glShaderSource`
- 编译shader --`glCompileShader`

### 创建与编译一个着色器

```
GLuint glCreateShader(GLenum type);
// type — 创建着色器的类型,GL_VERTEX_SHADER 或者GL_FRAGMENT_SHADER
// 返回值 — 是指向新着⾊器对象的句柄.可以调用glDeleteShader 删除 

void glDeleteShader(GLuint shader);
// shader — 要删除的着⾊器对象句柄

void glShaderSource(GLuint shader , GLSizei count ,const GLChar * const *string, const GLint *length);
// shader — 指向着⾊器对象的句柄
// count — 着⾊器源字符串的数量,着⾊器可以由多个源字符串组成,但是每个着⾊器只有⼀个main函数 
// string — 指向保存数量的count 的着⾊器源字符串的数组指针
// length — 指向保存每个着⾊器字符串大小且元素数量为count 的整数组指针

void glCompileShader(GLuint shader); 
// shader — 需要编译的着⾊器对象句柄

void glGetShaderiv(GLuint shader , GLenum pname , GLint *params );
// shader — 需要编译的着⾊器对象句柄
// pname — 获取的信息参数,可以为 GL_COMPILE_STATUS/GL_DELETE_STATUS/ GL_INFO_LOG_LENGTH/GL_SHADER_SOURCE_LENGTH/ GL_SHADER_TYPE
// params — 指向查询结果的整数存储位置的指针.

void glGetShaderInfolog(GLuint shader , GLSizei maxLength, GLSizei *length , GLChar *infoLog);
// shader — 需要获取信息⽇志的着⾊器对象句柄
// maxLength — 保存信息日志的缓存区⼤小
// length — 写⼊的信息日志的⻓度(减去null 终⽌符); 如果不需要知道长度. 这个参数可以为Null 
// infoLog — 指向保存信息日志的字符缓存区的指针.
```

### 自定义程序

自定义程序一般有以下步骤：

- 创建一个程序对象 --`glCreateProgram`
- 着色器与程序连接/附着 --`glAttachShader`
- 链接程序 --`glLinkProgram`
- 使用程序 --`glUseProgram`

### 创建与链接程序API

```
// 创建⼀个程序对象
GLUint glCreateProgram( )
// 返回值: 返回⼀个执行新程序对象的句句柄

void glDeleteProgram( GLuint program ) 
// program : 指向需要删除的程序对象句柄

// 着⾊器与程序连接/附着
void glAttachShader( GLuint program , GLuint shader );
// program : 指向程序对象的句柄
// shader : 指向程序连接的着⾊器对象的句柄

// 断开连接
void glDetachShader(GLuint program);
// program : 指向程序对象的句柄
// shader : 指向程序断开连接的着⾊器对象句柄

// 链接程序
glLinkProgram(GLuint program) 
// program: 指向程序对象句柄

// 检查链接是否成功
void glGetProgramiv (GLuint program,GLenum pname, GLint *params);
// program: 需要获取信息的程序对象句柄 
// pname : 获取信息的参数,可以是:
			GL_ACTIVE_ATTRIBUTES 
			GL_ACTIVE_ATTRIBUTES_MAX_LENGTH 
			GL_ACTIVE_UNIFORM_BLOCK 
			GL_ACTIVE_UNIFORM_BLOCK_MAX_LENGTH 
			GL_ACTIVE_UNIFROMS 
			GL_ACTIVE_UNIFORM_MAX_LENGTH 
			GL_ATTACHED_SHADERS 
			GL_DELETE_STATUS
			GL_INFO_LOG_LENGTH
			GL_LINK_STATUS 
			GL_PROGRAM_BINARY_RETRIEVABLE_HINT 
			GL_TRANSFORM_FEEDBACK_BUFFER_MODE 
			GL_TRANSFORM_FEEDBACK_VARYINGS 
			GL_TRANSFORM_FEEDBACK_VARYING_MAX_LENGTH 
			GL_VALIDATE_STATUS
// params : 指向查询结果整数存储位置的指针

// 从程序信息日志中获取信息
void glGetPorgramInfoLog( GLuint program ,GLSizei maxLength, GLSizei *length , GLChar *infoLog )
// program : 指向需要获取信息的程序对象句柄
// maxLength : 存储信息⽇志的缓存区⼤小
// length : 写⼊的信息日志⻓度(减去null 终⽌止符),如果不需要知道长度,这个参数可以为Null. infoLog : 指向存储信息⽇志的字符缓存区的指针

// 使用程序
void glUseProgram(GLuint program) 
// program: 设置为活动程序的程序对象句柄.
```

