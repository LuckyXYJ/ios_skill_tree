## Framework 包

flutter代码打包命令

```
flutter build ios-framework --output=../flutter_app
```

执行命令后，生成三个包

![image-20221117152313057](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20221117152313057.png)

将对应的静态库framework导入到原生项目即可运行

## Cocopods混合

flutter命令

```
flutter build ios-framework --cocoapods --output=../flutter_cocopods
```

执行后，同样生成三个包，区别便是里面的flutter不再是一个静态库，而是通过Cocopods拉取

![image-20221117152339382](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20221117152339382.png)

将app包导入到原生工程内，将Flutter配置到podfile内即可

## Git Actions

通过配置Git Action可以在每次提交代码后自动打包Flutter代码。

![image-20221118164606161](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20221118164606161.png)

对应的workflows代码如下

```yaml
name: FlutterCI #CI名称
on: [push] #触发条件push操作！

jobs:
  check:
    name: Test on ${{ matrix.os }}
    #运行在哪个平台这里是MacOS平台
    runs-on: macos-latest
    
    steps:
      - uses: actions/checkout@v3
      #三方flutter的Action，它可以在服务器配置一个Flutter环境
      - uses: subosito/flutter-action@v2
        with:
          #flutter-version: '3.0.5'
          channel: 'stable'
      #想让我们CI做的事情！
      - run: flutter --version
      - run: cd flutter_module && flutter build ios-framework --cocoapods --output=../NativeDemo/Flutter 
      - run: |
         git add .
         git commit -m 'update flutter framework'
     
      - name: Push changes
        uses: ad-m/github-push-action@master
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
```

