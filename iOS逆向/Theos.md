## Theos

Theos 主要用于以越狱为中心的 iOS 开发。Theos 是一个跨平台的开发工具套件，用于在不使用 Xcode 的情况下管理、开发和部署 iOS 软件。它是人们为越狱的 iOS 构建插件（Tweak）的重要工具，大多数插件开发人员使用 Theos

## Theos安装

1、安装ldid

`brew install ldid`

2、修改环境变量

```
vim ~/.bash_profile

// 在.bash_profile文件中加入以下两行
export THEOS=~/theos
export PATH=$THEOS/bin:$PATH

//让.bash_profile配置生效
source ~/.bash_profile
```

3、下载theos

`git clone --recursive https://github.com/theos/theos.git $THEOS`

## 常见问题

1、make package错误

```
make package

Can't locate IO/Compress/Lzma.pm in @INC (you may need to install the
IO::Compress::Lzma module) (@INC contains: /Library/Perl/5.18/darwin-
thread-multi-2level /Library/Perl/5.18 /Network/Library/Perl/5.18/darwin-
thread-multi-2level /Network/Library/Perl/5.18 /Library/Perl/Updates/5.18.2
/System/Library/Perl/5.18/darwin-thread-multi-2level
/System/Library/Perl/5.18 /System/Library/Perl/Extras/5.18/darwin-thread-
multi-2level /System/Library/Perl/Extras/5.18 .) at
/Users/mj/theos/bin/dm.pl line 12.
BEGIN failed--compilation aborted at /Users/mj/theos/bin/dm.pl line 12.
make: *** [internal-package] Error 2
```

以上错误是因为打包压缩方式有问题，改成gzip即可

- 修改dm.pl文件，用#号注释掉下面两句

  ```
  vim $THEOS/vendor/dm.pl/dm.pl
  #use IO::Compress::Lzma;
  #use IO::Compress::Xz;
  ```

  

- 修改deb.mk文件第六行的压缩方式为gzip

  ```
  vim $THEOS/makefiles/package/deb.mk
  _THEOS_PLATFORM_DPKG_DEB_COMPRESSION ?= gzip
  ```

2、make错误-xcode路径

```
make
Error: You do not have an SDK in
/Library/Developer/CommandLineTools/Platforms/iPhoneOS.platform/Developer/S
DKs
```

是因为多个xcode路径，需要指定一下xcode

```
sudo xcode-select --switch
/Applications/Xcode.app/Contents/Developer/
```

3、make错误-缓存

```
make
> Making all for tweak xxx...
make[2]: Nothing to be done for `internal-library-compile'.
```

是因为之前已经编译过，有缓存导致的，clean一下即可

```
make clean
make
```

## theos资料查询

目录结构：https://github.com/theos/theos/wiki/Structure

环境变量：http://iphonedevwiki.net/index.php/Theos

logos语法：http://iphonedevwiki.net/index.php/Logos

- **%hook**，**%end**：hook一个类的开始和结束

- **%log**：打印方法调用详情

  - 可以通过Xcode -> Window -> Devices and Simulators查看日志

- **HBDebugLog**：跟NSLog类似

- **%new**: 添加一个新方法

- **%c(className)** ：生成一个Class对象，比如%c(NSObject) ，类似于 NSStringFromClass() ，objc_getClass()

- **%orig** 函数原来的代码逻辑

- **%ctor** 在加载动态库时调用

- **%dtor**程序退出时调用

-  **logify.pl** 可以将一个头文件快速转换成已经包换打印信息的xm文件

    ```
    logify.pl xx.h > xx.xm
    ```

如果有额为的资源文件（如图片），放在项目的layout文件夹中，对应手机的根路径 `/`

