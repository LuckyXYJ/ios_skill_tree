## 动态库共享缓存

从iOS3.1开始，为了提高性能，绝大部分的系统动态库文件都打包存放到了一个缓存文件中（dyld shared cache）

缓存文件路径：/System/Library/Caches/com.apple.dyld/dyld_shared_cache_arm[x]

dyld_shared_cache_arm[x]的x代表ARM处理器指令集架构

动态库共享缓存一个非常明显的好处是节省内存

现在的ida、Hopper反编译工具都可以识别动态库共享缓存

## 架构对应手机

所有指令集原则上都是向下兼容的

```
v6
iPhone、iPhone3G
iPod Touch、iPod Touch2

v7
iPhone3GS、iPhone4、iPhone4S
iPad、iPad2、iPad3(The New iPad)
iPad mini
iPod Touch3G、iPod Touch4、iPod Touch5

v7s
iPhone5、iPhone5C
iPad4

arm64
iPhone5S、iPhone6、iPhone6 Plus、iPhone6S、iPhone6S Plus
iPhoneSE、iPhone7、iPhone7 Plus、iPhone8、iPhone8 Plus、iPhoneX
iPad5、iPad Air、iPad Air2、iPad Pro、iPad Pro2
iPad mini with Retina display、iPad mini3、iPad mini4
iPod Touch6
```