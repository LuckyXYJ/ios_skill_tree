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

#### PCM转成WAV

```
ffmpeg -ar 44100 -ac 2 -f s16le -i out.pcm out.wav
```

需要注意的是：上面命令生成的WAV文件头有78字节。对比44字节的文件头，它多增加了一个34字节大小的LIST chunk。

关于LIST chunk的参考资料：

- [What is a “LIST” chunk in a RIFF/Wav header?](https://stackoverflow.com/questions/63929283/what-is-a-list-chunk-in-a-riff-wav-header)
- [List chunk (of a RIFF file)](https://www.recordingblogs.com/wiki/list-chunk-of-a-wave-file)

加上一个输出文件参数*-bitexact*可以去掉LIST Chunk。

```
ffmpeg -ar 44100 -ac 2 -f s16le -i out.pcm -bitexact out2.wav
```

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

## 三、编译FFmpeg

### 3.1 安装依赖项

- brew install yasm
  - ffmpeg的编译过程依赖yasm
  - 若未安装yasm会出现错误：nasm/yasm not found or too old. Use --disable-x86asm for a crippled build.
- brew install sdl2
  - ffplay依赖于sdl2
  - 如果缺少sdl2，就无法编译出ffplay
- brew install fdk-aac
  - 不然会出现错误：ERROR: libfdk_aac not found
- brew install x264
  - 不然会出现错误：ERROR: libx264 not found
- brew install x265
  - 不然会出现错误：ERROR: libx265 not found

其实x264、x265、sdl2都在曾经执行*brew install ffmpeg*的时候安装过了。

- 可以通过brew list的结果查看是否安装过
  - *brew list | grep fdk*
  - *brew list | grep x26*
  - *brew list | grep -E 'fdk|x26'*
- 如果已经安装过，可以不用再执行*brew install*

### 3.2 configure

首先进入源码目录。

```sh
# 我的源码放在了Downloads目录下
cd ~/Downloads/ffmpeg-4.3.2
```

然后执行源码目录下的*configure*脚本，设置一些编译参数，做一些编译前的准备工作。

```sh
./configure --prefix=/usr/local/ffmpeg --enable-shared --disable-static --enable-gpl  --enable-nonfree --enable-libfdk-aac --enable-libx264 --enable-libx265
```

- *--prefix*
  - 用以指定编译好的FFmpeg安装到哪个目录
  - 一般放到/usr/local/ffmpeg中即可
- *--enable-shared*
  - 生成动态库
- *--disable-static*
  - 不生成静态库
- *--enable-libfdk-aac*
  - 将fdk-aac内置到FFmpeg中
- *--enable-libx264*
  - 将x264内置到FFmpeg中
- *--enable-libx265*
  - 将x265内置到FFmpeg中
- *--enable-gpl*
  - x264、x265要求开启[GPL License](https://www.gnu.org/licenses/gpl-3.0.html)
- *--enable-nonfree*
  - [fdk-aac与GPL不兼容](https://github.com/FFmpeg/FFmpeg/blob/master/LICENSE.md)，需要通过开启nonfree进行配置

你可以通过*configure --help*命令查看每一个配置项的作用。

```sh
./configure --help | grep static
 
# 结果如下所示
--disable-static         do not build static libraries [no]
```

### 3.3 编译

接下来开始解析源代码目录中的Makefile文件，进行编译。*-j8*表示允许同时执行8个编译任务。

```sh
make -j8
```

对于经常在类Unix系统下接触C/C++开发的小伙伴来说，Makefile必然是不陌生的。这里给不了解Makefile的小伙伴简单科普一下：

- Makefile描述了整个项目的编译和链接等规则
  - 比如哪些文件需要编译？哪些文件不需要编译？哪些文件需要先编译？哪些文件需要后编译？等等
- Makefile可以使项目的编译变得自动化，不需要每次都手动输入一堆源文件和参数
  - 比如原来需要这么写：*gcc test1.c test2.c test3.c -o test*

### 3.4 安装

将编译好的库安装到指定的位置：/usr/local/ffmpeg。

```sh
make install
```

### 3.5 配置PATH

为了让bin目录中的ffmpeg、ffprobe、ffplay在任意位置都能够使用，需要先将bin目录配置到环境变量PATH中。

```sh
# 编辑.zprofile
vim ~/.zprofile
 
# .zprofile文件中写入以下内容
export PATH=/usr/local/ffmpeg/bin:$PATH
 
# 让.zprofile生效
source ~/.zprofile
```

如果你用的是bash，而不是zsh，只需要将上面的.zprofile换成.bash_profile。

### 3.6 验证

命令行上进行验证。

```
ffmpeg -version
 
# 结果如下所示
ffmpeg version 4.3.2 Copyright (c) 2000-2021 the FFmpeg developers
built with Apple clang version 12.0.0 (clang-1200.0.32.29)
configuration: --prefix=/usr/local/ffmpeg --enable-shared --disable-static --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libx264 --enable-libx265
libavutil      56. 51.100 / 56. 51.100
libavcodec     58. 91.100 / 58. 91.100
libavformat    58. 45.100 / 58. 45.100
libavdevice    58. 10.100 / 58. 10.100
libavfilter     7. 85.100 /  7. 85.100
libswscale      5.  7.100 /  5.  7.100
libswresample   3.  7.100 /  3.  7.100
libpostproc    55.  7.100 / 55.  7.100
```

可以通过*brew uninstall ffmpeg*卸载以前通过homebrew安装的FFmpeg。
