## Xcode上卡顿监测与分析新工具

iOS 16 和 Xcode 14以前检测方案

- MetricKit
- Xcode Organizer

WWDC2022上介绍了新的工具帮助开发者在不同开发阶段进行卡顿的排查与分析。需要再iOS 16 和 Xcode 14以上版本使用

具体工具如下：

- Thread Performance Checker  开发阶段
- Hang detection in Instruments 开发阶段
- On-Device Hang Detection  测试阶段/testfight阶段
- Xcode Reports Organizer 正式环境

### Thread Performance Checker

使用 Xcode 进行真机调试时，可以在 Edit Scheme -> Run -> Diagnostics 选项卡中开启 Thread Performance Checker。

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/906740463810a2452fc30856879dc7a0.jpg)

当开启 Thread Performance Checker 后，Xcode 如果检测到 App 在运行时有例如线程优先级反转和非 UI 工作在主线程运行等问题时就会在 Xcode 问题导航栏中提示该卡顿风险警告。

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/5218785baf75b54243072a8d3059fe80.jpg)

### Hang detection in Instruments

 Xcode 14 的 Timer Profiler 工具分析 App 的卡顿问题时，如果检测到 App 有卡顿问题时就会在轨道时间线上展示红色的 Hang 标记，该标记的长度代表了卡顿的时间间隔

我们可以通过点击三次 Hang 标记过滤出该卡顿时间间隔区间内的所有事件并展开详细的线程轨道视图，以方便查看其它线程的繁忙情况



![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/f5a28e0b0d320a509fd3caa20fe635c7.jpg)

我们可以展开 Timer Profiler 下方的调用堆栈分析当时子线程的堆栈信息，结合实际上下文并最终解决主线程阻塞问题。

单独的 Hang tracing 只能检测到运行期间是否发生了卡顿以及卡顿时长，并没有实际的堆栈信息，所以在实际利用 Instruments 排查卡顿时还是建议优先使用 Timer Profiler 进行分析。

## On-Device Hang Detection

Hang Detection（卡顿检测）功能，为 App 运行时提供实时的卡顿检测通知并诊断的能力，不过这只适用于由开发证书签名的以及通过 TestFlight 分发的应用，换言之就是该功能只能统计通过 Xcode 安装的 Debug 包和通过 TestFlight 安装的 Release 包

功能具体打开方式：手机 Settings -> Developer -> Hang Detection，并切换 Enable Hang Detection 开关状态到开启状态。开启后可以看到以下三部分：

- Hang Threshold：可设置卡断检测的阈值，目前只有 250ms、500ms、1000ms 和 2000ms 四个可选；
- Monitored Apps：展示可监控的 App 列表；（注意：只展示由开发证书签名的和通过 TestFlight 安装的应用，企业证书签名无法适用）
- Avalable Hang Logs：展示了收到卡顿警告通知时诊断所产生的卡顿日志列表，这个后续我们排查具体问题时会用到；

日志详情分为两部分：  

- 基于文本的卡顿日志摘要文件（格式类似崩溃日志），文件后缀名为 .ips；
- tailspin 压缩文件，tailspin 文件可以在 Instruments 中打开查看更多维度信息（例如 Timer Profile 和 Disk Usage 等系统资源使用情况等）供深入分析使用。

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1c660585e2dd9064d286d5ba4779f544.jpg)

## Xcode Reports Organizer

Xcode 14 以前 Organizer 只提供了卡顿率这种经过系统性分析后的数据指标，并没有提供诸如包含堆栈信息的卡顿报告来帮助排查定位

Xcode 14 上 Organizer 终于支持了 Hang Reports，它能收集并上报线上用户在遇到卡顿时系统所产生的诊断报告数据（前提是用户同意了与 App 开发者共享应用分析）

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/b58bb2f2eb2198e3da5cec87d0912d13.jpg)

Xcode 14 Organizer 的 Reports 分类中新增加了 Hang Reports 栏目。

- 第二栏展示问题的聚合列表，问题按用户影响程度进行排序；
- 第三栏展示了具体问题的堆栈信息，可帮助开发者分析定位卡顿原因；
- 第四栏展示了具体问题的汇总统计信息，比如发生卡顿的数量，操作系统和设备分布比例等。