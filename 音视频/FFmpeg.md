## FFmpeg

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