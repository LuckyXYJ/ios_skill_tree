## 一、FFmpeg

FFmpeg是跨平台的音视频开发库

有很多知名项目都采用了FFmpeg，比如：

- [Google Chrome](https://www.chromium.org/audio-video)：浏览器
- Firefox：浏览器
- [VLC](https://www.videolan.org/)：跨平台播放器
- [MPlayer](http://www.mplayerhq.hu/)
- [ijkplayer](https://github.com/bilibili/ijkplayer)：bilibili团队开发的Android/iOS播放器框架
- Perian：Apple公司的QuickTime组件

目录结构如下所示：

- bin
  - 有编译好的可执行程序：ffmpeg.exe、ffplay.exe、ffprobe.exe，可以直接在命令行上使用，比如
    - *ffplay xx.mp4*：可以直接播放某个视频
    - *ffmpeg -version*：可以查看FFmpeg的版本号
  - 有运行时需要用到的动态库文件（*.dll）
- doc：FFmpeg的使用文档
- include：开发时需要包含的头文件
- lib：链接时需要用到的库文件

## 二、FFmpeg命令行

FFmpeg的bin目录中提供了3个命令（可执行程序）ffmpeg.exe、ffplay.exe、ffprobe.exe，可以直接在命令行上使用。

### 2.1、ffmpeg

ffmpeg的主要作用：对音视频进行编解码。

```sh
# 将MP3文件转成WAV文件
ffmpeg -i xx.mp3 yy.wav
```

当输入命令*ffmpeg*时，可以看到ffmpeg命令的使用格式是：

```sh
ffmpeg [options] [[infile options] -i infile]... {[outfile options] outfile}...
```

简化一下，常用格式是：

```sh
ffmpeg arg1 arg2 -i arg3 arg4 arg5
```

- arg1：全局参数
- arg2：输入文件参数
- arg3：输入文件
- arg4：输出文件参数
- arg5：输出文件

#### 其他图片格式转YUV

```
ffmpeg -i in.png -s 512x512 -pix_fmt yuv420p out.yuv
```

- -s
  - 设置图片的尺寸
  - 可以用一些[固定字符串](https://ffmpeg.org/ffmpeg-all.html#Video-size)表示尺寸，比如hd720表示1280x720
  - 如果不设置此选项，默认会跟随输入图片的尺寸
- -pix_fmt
  - 设置像素格式
  - 可以通过*ffmpeg -pix_fmts*查看FFmpeg支持的像素格式
  - 如果不设置此选项，默认会跟随输入图片的像素格式
    - 比如可能是rgb24、rgba8、pal8等
    - 可以通过*ffprobe*查看某图片的像素格式，比如*ffprobe in.png*

#### YUV转其他图片格式

```
ffmpeg -s 512x512 -pix_fmt yuv420p -i in.yuv out.jpg
```

- 这里必须得设置YUV的尺寸（*-s*）、像素格式（*-pix_fmt*）
- 这就类似于：对pcm进行编码时，必须得设置采样率（*-ar*）、声道数（*-ac*）、采样格式（*-f*）

#### 帮助

```shell
# 简易版
ffmpeg -h
# 详细版
ffmpeg -h long
# 完整版
ffmpeg -h full
 
# 或者使用
# ffmpeg -help
# ffmpeg -help long
# ffmpeg -help full
```

