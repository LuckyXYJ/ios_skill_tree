## Cycript

由Jay Freeman（saurik）开发的脚本语言。开发者可以用[Cycript](http://www.cycript.org/)来探索和调试iOS或者MacOS 上运行的程序

## Cycript使用准备

1、手机Cydia安装Cycript。

2、手机Cydia安装adv-cmds。可以用ps命令列出当前系统中的进程。获取需要调试的**进程号**或**进程名字**

```
列出所有进程
ps -A
ps aux

可以搜索关键词,如：wechat
ps -A | grep wechat
```

3、Cycript开启和关闭

```
开启
cycript 
cycript -p 进程ID
cycript -p 进程名称

取消输入  ctrl+C
退出  Ctrl+D
清屏  Command+ R
```

## Cycript常用语法

```
UIApp
[UIApplication sharedApplication]

定义变量
var 变量名 = 变量值

用内存地址获取对象
#内存地址

ObjectiveC.classes
已加载的所有OC类

查看对象的所有成员变量
*对象

递归打印view的所有子控件（跟LLDB一样的函数）
view.recursiveDescription().toString()

筛选出某种类型的对象
choose(UIViewController)
choose(UITableViewCell)

```

## Cycript 文件封装

可以将常用的Cycript代码封装在一个.cy文件中。exports参数名固定，用于向外提供接口

```
(function(exports) {
    exports.rootVC = function() {
        return UIApp.keyWindow.rootViewController;
    };

		// app id
		exports.XZAppId = [NSBundle mainBundle].bundleIdentifier;

		// mainBundlePath
		XZAppPath = [NSBundle mainBundle].bundlePath;
  
  	keyWinow = function() {
        return UIApp.keyWindow;
    };
})(exports);
```

其中exports.rootVC的调用需要通过`文件名.rootVC()`的方式

keyWinow的调用可以通过 `keyWinow`的方式

## .cy文件的使用

1、首先将文件放入手机 /usr/lib/cycript0.9 目录下。

2、打开cycript调试

3、`@import 文件` 导入文件。

4、使用.cy文件中的代码





