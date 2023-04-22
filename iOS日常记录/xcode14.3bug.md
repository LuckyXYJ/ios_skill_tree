## 升级Xcode14.3 后运行报错

```
File not found: /Applications/Xcode-beta.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/arc/libarclite_iphoneos
```

原因是libarclite_iphoneos文件缺失

### 解决方案分两种情况

1. 有的三方库支持版本过低，在podfile文件中指定版本

```
post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
               end
          end
   end
end

```

![image-20230408153746532](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230408153746532.png)

2、直接下载libarclite_iphoneos文件，放到以上路径下面

```
cd /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/
sudo mkdir arc
cd  arc
sudo git clone https://github.com/kamyarelyasi/Libarclite-Files.git .
```

终端修改这个目录可能会遇到没有权限的情况，可以通过` sudo chmod +x `添加权限 

也可以手动添加:

打开文件夹

```
open /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/
```

手动创建arc文件

下载 https://github.com/kamyarelyasi/Libarclite-Files.git 文件，手动将文件夹内容拷贝到arc文件夹下

![image-20230408153711669](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230408153711669.png)