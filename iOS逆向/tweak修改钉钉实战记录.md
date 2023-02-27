## 1、找到mach-O

```
ssh root@192.168.1.160 //链接手机

ps -A // 找到钉钉应用ID，以及mach-O 路径
```

## 2、bundleId

```
cycript -p DingTalk // 进入cycript 调试环境

[NSBundle mainBundle].bundleIdentifier // 获取bundleID
```

## 3、验证是否加壳

```
otool  -l  DingTalk  |  grep  crypt
```

## 4、脱壳

打开**CrackerXI+**,选择钉钉，进行脱壳

## 5、头文件导出

```
class-dump  -H  DingTalk  -o  ../header
```

## 7、找到对应文件

分别尝试了两种方法：

- Cycript调试，获取到角标的类
- Reveal调试

最终找到角标类**DTUIBadgeView**

## 8、编码

创建tweak工程。

在Tweak.x文件中编码

```
%hook DTUIBadgeView

- (id)initWithBadge:(id)arg1 {
	return nil;
}

%end
```

## 9、安装到手机

在Makefile文件中加入IP和端口常量，然后执行命令

```
export THEOS_DEVICE_IP=192.168.1.160
export THEOS_DEVICE_PORT=22

make package && make install
```







