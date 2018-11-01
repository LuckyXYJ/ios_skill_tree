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

