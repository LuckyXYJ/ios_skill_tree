## 固定管线/存储着色器初始化

```
GLShaderManager shaderManager;
shaderManager.InitializeStockShaders();
```

## 单元着色器

使用场景：绘制默认OpenGL 坐标系（-1,1）下的图形，图形所有片段都会以一种颜色填充

```
GLShaderManager::UserStockShader(GLT_SHADER_IDENTITY,GLfloat vColor[4]);
```

参数：

- GLT_SHADER_IDENTITY:  存储着⾊器种类**-**单元着⾊器器 
- vColor[4]: 颜⾊

## 平面着色器

使用场景：在绘制图形时，可以应用变换（模型/投影变化）。

```
GLShaderManager::UserStockShader(GLT_SHADER_FLAT,GLfloat mvp[16],GLfloat vColor[4]);
```

参数：

- 参数1: 存储着⾊色器器种类**-**平⾯面着⾊色器器
- 参数2: 允许变化的**4\*4**矩阵
- 参数3: 颜⾊

## 上色着色器

在绘制图形时，可以应用变换（模型/投影变化）。

与平面着色器区别：颜色将会平滑地插入到顶点之间，称为**平滑着色**

```
GLShaderManager::UserStockShader(GLT_SHADER_SHADED,GLfloat mvp[16]);
```

参数：

- 参数1：存储着⾊色器器种类**-**上⾊色着⾊色器器 
- 参数2：允许变化的**4\*4**矩阵

## 默认光源着色器

在绘制图形时, 可以应⽤用变换(模型/投影变化)这种着⾊色器器会使绘制的图形产⽣生**阴影**和**光照**的效果。

```
GLShaderManager::UserStockShader(GLT_SHADER_DEFAULT_LIGHT,GLfloat mvMatrix[16],GLfloat pMatrix[16],GLfloat vColor[4]);
```

参数：

- 参数**1:** 存储着⾊器种类**-**默认光源着⾊器 
- 参数**2:** 模型**4\*4**矩阵
- 参数**3:** 投影**4\*4**矩阵
- 参数**4:** 颜⾊值

## 点光源着色器

使用场景：在绘制图形时, 可以应⽤变换(模型/投影变化)，这种着⾊器会使绘制的图形产⽣阴影和光照的效果。它与默认光源着⾊色器器⾮非常类似，区别只是**光源位置可以是特定的**。

```
GLShaderManager::UserStockShader(GLT_SHADER_POINT_LIGHT_DIEF,GLfloat mvMatrix[16],GLfloat pMatrix[16],GLfloat vLightPos[3],GLfloat vColor[4]);
```

参数：

- 参数**1:** 存储着⾊色器器种类**-**点光源着⾊色器器 
- 参数**2:** 模型**4\*4**矩阵
- 参数**3:** 投影**4\*4**矩阵
- 参数**4:** 点光源的位置
- 参数**5:** 漫反射颜⾊色值

## 纹理替换着色器

使用场景：在绘制图形时, 可以应⽤变换(模型/投影变化)，这种着色器通过给定的模型视图投影矩阵，使用纹理单元进行颜色填充，其中每个像素点的颜色从纹理中获取

```
GLShaderManager::UserStockShader(GLT_SHADER_TEXTURE_REPLACE,GLfloat mvMatrix[16],GLint nTextureUnit);
```

参数：

- 参数1: 存储着⾊器种类-纹理替换矩阵着⾊器 
- 参数2: 模型4*4矩阵
- 参数3: 纹理单元

## 纹理调整着色器

使⽤用场景: 在绘制图形时, 可以应⽤变换(模型/投影变化)，这种着⾊器通过给定的模型视图投影矩阵. 着⾊色器器将一个基本色乘以⼀个取⾃纹理单元nTextureUnit 的纹理.将颜⾊与纹理进⾏颜⾊混合后才填充到⽚片段中.

```
GLShaderManager::UserStockShader(GLT_SHADER_TEXTURE_MODULATE,GLfloat mvMatrix[16],GLfloat vColor[4],GLint nTextureUnit);
```

参数：

- 参数1: 存储着⾊器种类-纹理调整着⾊器
- 参数2: 模型4*4矩阵
- 参数3: 颜⾊值
- 参数4: 纹理单元

## 纹理光源着色器

使⽤用场景: 在绘制图形时, 可以应⽤变换(模型/投影变化)，这种着⾊器通过给定的模型视图投影矩阵. 着⾊器将⼀个纹理通过漫反射照明计算进行调整(相乘).

```
GLShaderManager::UserStockShader(GLT_SHADER_TEXTURE_POINT_LIGHT_DIEF,G Lfloat mvMatrix[16],GLfloat pMatrix[16],GLfloat vLightPos[3],GLfloat vBaseColor[4],GLint nTextureUnit);
```

参数：

- 参数1: 存储着⾊器种类-纹理光源着⾊器 
- 参数2: 模型4*4矩阵
- 参数3: 投影4*4矩阵
- 参数4: 点光源位置
- 参数5: 颜⾊值(⼏何图形的基本⾊) 
- 参数6: 纹理单元

