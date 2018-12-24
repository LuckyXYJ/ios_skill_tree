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



