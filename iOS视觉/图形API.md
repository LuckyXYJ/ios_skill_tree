## 图形API

利用GPU芯片来高效渲染图形图像，图形API是iOS开发者唯一接近GPU的方式

### 图形API应用：

- ⽐如在游戏开发中,对于游戏场景/游戏⼈物的渲染
- ⽐如在⾳视频开发中,对于视频解码后的数据渲染
- ⽐如在地图引擎,对于地图上的数据渲染
- ⽐如在动画中,实现动画的绘制
- ⽐如在视频处理中,对于视频加上滤镜效果

### 常见图形API

- **OpenGL** （Open Graphics Library）是⼀个跨编程语⾔、跨平台的编程图形程序接⼝，它将计 算机的资源抽象称为⼀个个OpenGL的对象，对这些资源的操作抽象为⼀个个的OpenGL指令

- **OpenGL ES** （OpenGL for Embedded Systems）是 OpenGL 三维图形 API 的⼦集，针对⼿机、 PDA和游戏主机等嵌⼊式设备⽽设计，去除了许多不必要和性能较低的API接⼝。

- **DirectX** 是由很多API组成的，DirectX并不是⼀个单纯的图形API. 最重要的是DirectX是属于 Windows上⼀个多媒体处理API.并不⽀持Windows以外的平台,所以不是跨平台框架. 按照性 质分类，可以分为四⼤部分，显示部分、声⾳部分、输⼊部分和⽹络部分.

- **Metal** : Metal: Apple为游戏开发者推出了新的平台技术 Metal，该技术能够为 3D 图 像提⾼ 10 倍的渲染性能.Metal 是Apple为了解决3D渲染⽽推出的框架

图形API本质是利用GPU芯片来高效渲染图形图像

图形API是iOS开发者唯一接近GPU的方式



