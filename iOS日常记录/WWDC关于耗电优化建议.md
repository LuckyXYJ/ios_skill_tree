## WWDC 2022关于耗电优化

### 暗黑模式适配

新的屏幕类型**OLED**，属于像素自发光，越暗的颜色发光越少，越省电。苹果Food Truck App 为例，使用暗黑模式节约用电70%

### 帧率控制

在使用 ProMotion 显示屏的设备中，刷新率会影响电池损耗，高刷新率则需要高能耗 

设置 CADisplayLink 的 preferredFrameRateRange 指定您最小 最大和偏好帧率

帧率监测：instrument中的CoreAnimation FPS工具，可以实时监测帧率变化

### 后台任务时间管理

后台任务检测：Xcode Gauges、 MetricKit、以及 iOS 16 新提出的 Control Center

- Xcode gauges： 会展示您 App 的定位使用 以及能量损耗时间线 这一时间线视图可验证您的 定位运行时间是否在您 预期的时间停止
- MetricKit： 使用 cumulativeBackgroundLocationTime 属性 查看您 App 在后台 使用定位服务的活跃时间
- Control Center：在 iOS 16 的更新中 用户可以通过 浏览 Control Center 监测当前使用定位服务的 App 用户可以点击顶部的文本 查看使用定位的 App 的详细视图

实际方案：

- 及时关闭后台任务。非必要后台定位关闭，
- 设置 AVAudioEngine 类的 autoShutdownEnabled启动自动关闭模式
- ...

### 推迟非实时性任务

后台任务优化：BGProcessingTask ， discretionary URL sessions，推送设置优先级等

##### BGProcessingTask

通过 BGProcessingTask 我们可以将能够在后台运行的非实时性任务交由系统在指定的时机完成。设置 requiresExternalPower 和 requiresNetworkConnectivity 可以告诉系统 BGProcessingTask 的触发时机是否需要连接电源和是否需要网络连接。

也有被系统中断的风险，这就意味着我们需要对 BGProcessingTask 设置 expirationHandler 进行任务过期处理。

##### discretionary URL sessions

后台网络请求加上 discretionary 标记的话会更合理一些，因为系统会根据自身情况决定什么时候发起请求。

后台网络请求：当网络请求完成后，系统会根据我们传入的 APP identifier 拉起对应的进程通知 APP。

##### 推送设置优先级等

避免非高优的事件进行实时推送。