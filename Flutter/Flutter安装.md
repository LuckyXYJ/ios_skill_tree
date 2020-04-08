## 一、Flutter

Flutter是谷歌的移动UI框架，可以快速在iOS和Android上构建高质量的原生用户界面。 Flutter可以与现有的代码一起工作。在全世界，Flutter正在被越来越多的开发者和组织使用，并且Flutter是完全免费、开源的。

### 与react native 对比

主要是渲染机制不同，具体的对比这里推荐个文章

[React Native VS Flutter评测](https://juejin.cn/post/6844903619867869192)

### Flutter 前景

[闲鱼正在悄悄放弃 Flutter 吗？](https://juejin.cn/post/6955304605190357005)

## 二、Flutter安装

1、下载安装包

[官网下载地址](https://flutter.dev/sdk-archive/#macos)

[镜像下载地址](https://github.com/flutter/flutter/releases)

打不开官网的，可以来这里看看[点击有惊喜](https://www.somersaultcloud.top/auth/register?code=wDF9)

2、解压到指定位置，我这里跟homebrew放到一块“/opt/flutter”

3、打开.bash_profile 文件，即shell配置文件

```
open ~/.bash_profile
```

4、配置镜像，在shell配置文件内新增以下代码。按需添加

```
#Flutter 镜像配置
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

5、配置环境，在shell配置文件内新增以下代码，其中FLUTTER的值为前面flutter安装包安装的位置 xxxx/bin.

```
#Flutter 配置
export FLUTTER=/opt/flutter/bin 
export PATH=$FLUTTER:$PATH
```

6、使配置文件生效

```
source ~/.bash_profile
```

7、检测flutter，终端输入，该命令可以查看是否需要安装其它依赖项来完成安装。根据终端输入内容做相应操作。

```
flutter doctor
```

8、创建第一个flutter工程xxxxx,终端输入

```
flutter create xxxxx
```

## 遇到的问题

1、安卓环境问题，缺少对应的命令行工具

```
Android toolchain - develop for Android devices (Android SDK version 30.0.3)
    ✗ cmdline-tools component is missing
      Run `path/to/sdkmanager --install "cmdline-tools;latest"`
      See https://developer.android.com/studio/command-line for more details.
    ✗ Android license status unknown.
      Run `flutter doctor --android-licenses` to accept the SDK licenses.
      See https://flutter.dev/docs/get-started/install/macos#android-setup for more details.
```

解决方案是，在Android studio 中安装对应的命令行工具，具体如下：

![image-20220917213627136](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220917213627136.png)

2、网络问题，对应的网站无法访问

```
HTTP Host availability check is taking a long time...[!] HTTP Host Availability
    ✗ HTTP host "https://maven.google.com/" is not reachable. Reason: An error occurred while checking the HTTP host:
      Operation timed out
    ✗ HTTP host "https://pub.dev/" is not reachable. Reason: An error occurred while checking the HTTP host: Operation timed
      out
    ✗ HTTP host "https://cloud.google.com/" is not reachable. Reason: An error occurred while checking the HTTP host:
      Operation timed out
```

解决方案，在shell配置中加入镜像，即以上第四步操作

```
#Flutter 镜像配置
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
```

如果系统可以访问以上三个网站，仅终端doctor命令失败，是因为终端环境与系统环境不同，需要单独开启**超能力**。

3、运行flutter出错，可能是是缓存的问题，解决方案即终端执行以下命令：

```
rm /opt/flutter/bin/cache/lockfile
```

