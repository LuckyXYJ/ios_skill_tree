## tweak

Tweak的实质就是iOS平台的动态库。iOS平台上有两种形势的动态库，dylib与framework。Framework这种开发者用的比较多，而dylib这种就相对比较少一点。而tweak用的正是dylib这种形势的动态库。

我们可以在/Library/MobileSubstrate/DynamicLibraries目录下查看越狱手机上存在着的所有tweak。这个目录下除dylib外还存在着plist与bundle两种格式的文件，plist文件是用来标识该tweak的作用范围, 而bundle是tweak所用到的资源文件.

一般使用Tweak是通过[Theos](https://github.com/theos/theos).

## 创建tweak项目

1、终端cd到存放项目代码的文件夹

2、终端输入 `nic.pl`，前提是安装了Theos

3、在命令给出的选项中选择iPhone/tweak

```
cd Desktop/jailbreak
nic.pl
```

4、根据提示输入项目信息

- Project Name  项目名
- Package Name  自己要生成的项目ID
- Author/Maintainer Name 作者
- [iphone/tweak] MobileSubstrate Bundle filter  要修改的APP包名，这里修改的是钉钉（com.laiwang.DingTalk）
- [iphone/tweak] List of applications to terminate upon installation 

原APP包名是通过 **cycript** 获取

## 编辑Makefile

在文件前面加入环境变量，标明通过哪个ip和端口访问手机。也可以直接将环境变量写入**.bash_profile**中

**THEOS_DEVICE_IP**， **THEOS_DEVICE_PORT**

```
export THEOS_DEVICE_IP=192.168.1.160
export THEOS_DEVICE_PORT=22

TARGET := iphone:clang:latest:7.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DingTalk

DingTalk_FILES = Tweak.x
DingTalk_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
```

## 编写代码

打开Tweak.x文件。写入要HOOK的方法。这里是把钉钉tabbar上的数字角标去掉了。

这里文件名，方法名来源：

- 通过**Reveal**找到对应的视图类
- 通过**class-dump**获取头文件信息，找到方法名

```
%hook DTUIBadgeView

- (id)initWithBadge:(id)arg1 {
	return nil;
}

%end
```

## 安装到手机

1、编译

`make`

2、打包成deb

`make package`

3、安装，默认是重启SpringBoard。我是非完美越狱，也只能选择重启SpringBoard

`make install`

## theos-tweak的实现过程

1、编写Tewak代码

2、make：编译Tweak代码为动态库（.dylib）

3、make package：将dylib打包为deb文件

4、make install：将deb文件传送到手机上，通过Cydia安装deb

5、插件将会安装在/Library/MobileSubstrate/DynamicLibraries文件夹中

- .dylib: 编译后的Tweak代码
- .plist: 存放需要HOOK的APP ID

6、当打开APP时

- Cydia substrate（Cydia插件）会让APP去加载对应的dylib
- 修改APP内存中的代码逻辑，去执行dylib中的函数代码

7、theos的tweak不会对app原来的可执行文件进行修改，仅仅修改了内存中的代码逻辑

## theos-tweak特点

1、未脱壳app支持theos-tweak

2、app被hook 代码不被修改的话一直有效

3、只能在越狱手机上起作用

4、可以对swift/C 函数进行tweak

5、可以对游戏项目进行tweak。但是很难，有混淆，多由c++实现

