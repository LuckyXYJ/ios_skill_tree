## GLKit

**GLKit** 使⽤数学库，背景纹理加载，预先创建的着色器效果，以及标准视图和视图控制器来实现渲染循环。

**GLKView** 提供绘制场所(View)

**GLKViewController ** 扩展于标准的UIKit 设计模式。 ⽤于绘制视图内容的管理与呈现.

![GLKView_diagram](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/GLKView_diagram_2x.png)

## 使用GLKit 

创建GLKView

```
- (void)viewDidLoad {
   [super viewDidLoad];
   //创建OpenGL ES上下⽂并将其分配给从故事板加载的视图
   GLKView * view =（GLKView *）self.view;
   view.context = [[EAGLContext alloc] initWithAPI：kEAGLRenderingAPIOpenGLES2];
   //配置视图创建的渲染缓冲区
   view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888; // 红绿蓝各占用8位
   view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
   view.drawableStencilFormat = GLKViewDrawableStencilFormat8;
   //启⽤多重采样
   view.drawableMultisample = GLKViewDrawableMultisample4X;
}
```

实现drawRect

```
-(void)drawRect:(CGRect)rect {
   //清除帧缓冲区
   glClearColor（0.0f，0.0f，0.1f，1.0f）;
   glClear（GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT）;

  //使⽤先前配置的纹理，着⾊器和顶点数组绘制
   glBindTexture（GL_TEXTURE_2D，_planetTexture）;
   glUseProgram（_diffuseShading）;
   glUniformMatrix4fv（_uniformModelViewProjectionMatrix，1,0，
   _modelViewProjectionMatrix.m）;
   glBindVertexArrayOES（_planetMesh）;
   glDrawElements（GL_TRIANGLE_STRIP，256，GL_UNSIGNED_SHORT）;
}
```

## GLKit 功能

- 加载纹理
- 提供⾼性能的数学运算
- 提供常⻅的着⾊器
- 提供视图以及视图控制器

## GLKit纹理加载

GLKTextureInfo 创建OpenGL 纹理信息

- name: OpenGL 上下⽂中纹理名称
- target: 纹理绑定的⽬标
- height: 加载的纹理⾼度
- width: 加载纹理的宽度
- textureOrigin: 加载纹理中的原点位置
- alphaState: 加载纹理中alpha分量状态
- containsMipmaps: 布尔值,加载的纹理是否包含mip贴图

初始化

```
- initWithSharegroup: 初始化⼀个新的纹理加载到对象中
- initWithShareContext: 初始化⼀个新的纹理加载对象
```

从文件中加载处理

```
+ textureWithContentsOfFile:options:errer: 从⽂件加载2D纹理图像并从数据中

- textureWithContentsOfFile:options:queue:completionHandler: 从⽂件中异步加载2D纹理图像,并根据数据创建新纹理
```

从URL加载纹理

```
- textureWithContentsOfURL:options:error: 从URL 加载2D纹理图像并从数据创建新纹理
- textureWithContentsOfURL:options:queue:completionHandler: 从URL异步加载2D纹理图像,并根据数据创建新纹理.
```

从内存中表示创建纹理

```text
+ textureWithContentsOfData:options:errer: 从内存空间加载2D纹理图像,并根据数据创建新纹理
- textureWithContentsOfData:options:queue:completionHandler:从内存空间异步加载2D纹理图像,并从数据中创建新纹理
```

从CGImages创建纹理

```text
- textureWithCGImage:options:error: 从Quartz图像 加载2D纹理图像并从数据创建新纹理
- textureWithCGImage:options:queue:completionHandler: 从Quartz图像异步加载2D纹理图像,并根据数据创建新纹理.
```

从URL加载多维创建纹理

```text
+ cabeMapWithContentsOfURL:options:errer: 从单个URL加载⽴⽅体贴图纹理图像,并根据数据创建新纹理
- cabeMapWithContentsOfURL:options:queue:completionHandler:从单个URL异步加载⽴⽅体贴图纹理图像,并根据数据创建新纹理
```

从⽂件加载多维数据创建纹理

```text
+ cubeMapWithContentsOfFile:options:errer: 从单个⽂件加载⽴⽅体贴图纹理对象,并从数据中创建新纹理
- cubeMapWithContentsOfFile:options:queue:completionHandler:从单个⽂件异步加载⽴⽅体贴图纹理对象,并从数据中创建新纹理
+ cubeMapWithContentsOfFiles:options:errer: 从⼀系列⽂件中加载⽴⽅体贴图纹理图像,并从数据总创建新纹理
- cubeMapWithContentsOfFiles:options:options:queue:completionHandler:从⼀系列⽂件异步加载⽴⽅体
```

## GLKit OpenGL ES 视图渲染

### GLKView 使⽤OpenGL ES 绘制内容的视图默认实现

• 初始化视图

```text
- initWithFrame:context: 初始化新视图
```

• 代理

```text
delegate 视图的代理
```

• 配置帧缓存区对象

```text
drawableColorFormat 颜⾊渲染缓存区格式
drawableDepthFormat 深度渲染缓存区格式
drawableStencilFormat 模板渲染缓存区的格式
drawableMultisample 多重采样缓存区的格式
```

• 帧缓存区属性

```text
drawableHeight 底层缓存区对象的⾼度(以像素为单位)
drawableWidth 底层缓存区对象的宽度(以像素为单位)
```

• 绘制视图的内容

```text
context 绘制视图内容时使⽤的OpenGL ES 上下⽂
- bindDrawable 将底层FrameBuffer 对象绑定到OpenGL ES
enableSetNeedsDisplay 布尔值,指定视图是否响应使得视图内容⽆效的消息
- display ⽴即重绘视图内容
snapshot 绘制视图内容并将其作为新图像对象返回
```

• 删除视图FrameBuffer对象

```text
- deleteDrawable 删除与视图关联的可绘制对象
```

•绘制视图的内容

```text
- glkView:drawInRect: 绘制视图内容 (必须实现代理) 
```

• 更新

```text
- (void) update 更新视图内容
- (void) glkViewControllerUpdate:
```

• 配置帧速率

```text
preferredFramesPerSecond 视图控制器调⽤视图以及更新视图内容的速率
framesPerSencond 视图控制器调⽤视图以及更新其内容的实际速率
```

• 配置GLKViewController 代理

```text
delegate 视图控制器的代理
```

• 控制帧更新

```text
paused 布尔值,渲染循环是否已暂停
pausedOnWillResignActive 布尔值,当前程序重新激活活动状态时视图控制器是否⾃动暂停渲染循环
resumeOnDidBecomeActive 布尔值,当前程序变为活动状态时视图控制是否⾃动恢复呈现循环
```

• 获取有关View 更新信息

```text
frameDisplayed 视图控制器⾃创建以来发送的帧更新数
timeSinceFirstResume ⾃视图控制器第⼀次恢复发送更新事件以来经过的时间量
timeSinceLastResume ⾃上次视图控制器恢复发送更新事件以来更新的时间量
timeSinceLastUpdate ⾃上次视图控制器调⽤委托⽅法以及经过的时间量
glkViewControllerUpdate:
timeSinceLastDraw ⾃上次视图控制器调⽤视图display ⽅法以来经过的时间量.
```

### GLKViewControllerDelegate 渲染循环回调⽅法

• 处理更新事件

```text
- glkViewControllerUpdate: 在显示每个帧之前调⽤
```

• 暂停/恢复通知

```text
- glkViewController : willPause: 在渲染循环暂停或恢复之前调⽤. 
```

### GLKBaseEffect ⼀种简单光照/着⾊系统,⽤于基于着⾊器OpenGL渲染

• 命名Effect

```text
label 给Effect(效果)命名
```

• 配置模型视图转换

```text
transform 绑定效果时应⽤于顶点数据的模型视图,投影和纹理变换
```

• 配置光照效果

```text
lightingType ⽤于计算每个⽚段的光照策略,GLKLightingType
GLKLightingType
	GLKLightingTypePerVertex 表示在三⻆形中每个顶点执⾏光照计算,然后在三⻆形进⾏插值
	GLKLightingTypePerPixel 表示光照计算的输⼊在三⻆形内插⼊,并且在每个⽚段执⾏光照计算
```

• 配置光照

```text
lightModelTwoSided 布尔值,表示为基元的两侧计算光照
material 计算渲染图元光照使⽤的材质属性
lightModelAmbientColor 环境颜⾊,应⽤效果渲染的所有图元.
light0 场景中第⼀个光照属性
light1 场景中第⼆个光照属性
light2 场景中第三个光照属性
```

• 配置纹理

```text
texture2d0 第⼀个纹理属性
texture2d1 第⼆个纹理属性
textureOrder 纹理应⽤于渲染图元的顺序
```

• 配置雾化

```text
fog 应⽤于场景的雾属性
```

• 配置颜⾊信息

```text
colorMaterialEnable 布尔值,表示计算光照与材质交互时是否使⽤颜⾊顶点属性
useConstantColor 布尔值,指示是否使⽤常量颜⾊
constantColor 不提供每个顶点颜⾊数据时使⽤常量颜⾊
```

• 准备绘制效果

```text
- prepareToDraw 准备渲染效果
```