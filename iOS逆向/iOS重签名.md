## 重签名

如果希望将破坏了签名的安装包，安装到非越狱的手机上，需要对安装包进行重签名操作

安装包中的可执行文件必须是经过脱壳的，重签名才有效

.app包内部的所有动态库（.framework、.dylib）、APPExtension（PlugIns文件夹，拓展名是appex）、WatchApp（Watch文件夹）都需要重新签名

查看设备的日志信息

- window -> Devices and Simulators -> view device logs
- window -> Devices and Simulators -> open Console

## codesign重签名

1. 准备embedded.mobileprovision文件，并放入app包中
   1. 可以通过xcode生成，然后再编译后的app包中找到
   2. 可以去开发者证书网站生成下载
2. 从embedded.mobileprovision文件中提取出entitlements.plist权限文件
   1. ` security cms -D -i embedded.mobileprovision` > temp.plist
   2. /usr/libexec/PlistBuddy -x -c 'Print :Entitlements' temp.plist > entitlements.plist
3. 查看可用的证书
   1. ` security find-identity -v -p codesigning`
4. 对.app内部的动态库、APPExtension等进行签名
   1. `codesign -fs 证书ID xxx.dylib`
5. 对.app 包进行签名
   1. ` codesign -fs 证书ID --entitlements entitlements.plist xxx.app`

GUI 工具

1、[iOS App Signer](https://github.com/DanTheMan827/ios-app-signer)

可以对.app重签名打包成ipa

需要对.app包中提供对应的embedded.mobileprovision文件

2、[iReSign](https://github.com/maciekish/iReSign/)

## 动态库注入

可以使用[insert_dylib](https://github.com/Tyilo/insert_dylib)库将动态库注入到Mach-O文件中

用法：` insert_dylib 动态库加载路径 Mach-O文件`

两个参数选项：` --weak`，即使找不到动态库也不会报错；` --all-yes` 后面所有的选择都为yes

inser_dylib的本质是往动态库Mach-O文件的Load Commands 中添加了一个**LC_LOAD_DYLIB** 或**LC_LOAD_WEAK_DYLIB**

可以通过otool查看Mach-O的**动态库依赖信息**

` otool -L Mach-O文件`

## 更改动态库加载地址

可以通过install_name_tool 修改Mach-O中动态库的加载地址

` install_name_tool -change 旧地址 新地址 Mach-O文件`

通过Theos开发的动态库插件（dylib）

- 默认都依赖于/library/Frameworks/CydiaSubstrate.framework/CydiaSubstrate
- 如果要将动态库插件打包到ipa中，也需要将CydiaSubstrate打包到ipa中，并且修改CydiaSubstrate的加载地址

两个常用的环境变量

- ` @executable_path`代表可执行文件所在的目录
- ` @load_path`代表动态库所在的目录