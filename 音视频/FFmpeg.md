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

### 2.2、ffprobe

ffprobe的主要作用：查看音视频的参数信息。

```
# 可以查看MP3文件的采样率、比特率、时长等信息
ffprobe xx.mp3
```

当输入命令*ffprobe*时，可以看到ffprobe命令的使用格式是：

```
ffprobe [OPTIONS] [INPUT_FILE]
# OPTIONS：参数
# INPUT_FILE：输入文件
```

#### 帮助

```
# 简易版
ffprobe -h
# 详细版
ffprobe -h long
# 完整版
ffprobe -h full
 
# 或者使用
# ffprobe -help
# ffprobe -help long
# ffprobe -help full
```

### 2.3、ffplay

fplay的主要作用：播放音视频。

```shell
# 播放MP3文件
ffplay xx.mp3
```

当输入命令*ffplay*时，可以看到ffplay命令的使用格式是：

```shell
ffplay [options] input_file
# options：参数
# input_file：输入文件
```

#### ffplay 播放PCM文件

播放PCM需要指定相关参数：

- *ar*：采样率
- *ac*：声道数
- f：采样格式
  - *s16le*：PCM signed 16-bit little-endian
  - 更多PCM的采样格式可以使用命令查看
    - Windows：*ffmpeg -formats | findstr PCM*
    - Mac：*ffmpeg -formats | grep PCM*

```sh
ffplay -ar 44100 -ac 2 -f s16le out.pcm
```

#### ffplay 显示YUV数据

```
ffplay -s 512x512 -pix_fmt yuv420p in.yuv
# 在ffplay中
# -s已经过期，建议改为：-video_size
# -pix_fmt已经过期，建议改为：-pixel_format
ffplay -video_size 512x512 -pixel_format yuv420p in.yuv
```

- YUV中直接存储的是所有像素的颜色信息（可以理解为是图像的一种原始数据）
- 必须得设置YUV的尺寸（*-s*）、像素格式（*-pix_fmt*）才能正常显示
- 这就类似于：播放pcm时，必须得设置采样率（*-ar*）、声道数（*-ac*）、采样格式（*-f*）

可以使用过滤器（filter）显示其中的单个分量（r、g、b、y、u、v）。

```
# 只显示r分量
ffplay -vf extractplanes=r in.png
 
# 只显示g分量
ffplay -vf extractplanes=g in.png
 
# 只显示b分量
ffplay -vf extractplanes=b in.png
 
# 只显示y分量
ffplay -video_size 512x512 -pixel_format yuv420p -vf extractplanes=y in.yuv
# 只显示y分量
ffplay -video_size 512x512 -pixel_format yuv420p -vf extractplanes=u in.yuv
# 只显示y分量
ffplay -video_size 512x512 -pixel_format yuv420p -vf extractplanes=v in.yuv
```

- -vf
  - 设置视频过滤器
  - 等价写法：*-filter:v*
- extractplanes
  - 抽取单个分量的内容到灰度视频流中

#### 帮助

```
# 简易版
ffplay -h
# 详细版
ffplay -h long
# 完整版
ffplay -h full
 
# 或者使用
# ffplay -help
# ffplay -help long
# ffplay -help full
```

### 2.4、hide_banner

增加*-hide_bannder*参数可以隐藏一些冗余的描述信息：

```
ffprobe xx.mp3
 
ffprobe -hide_banner xx.mp3
 
# ffmpeg、ffprobe、ffplay都适用
```

