## 一、查看可用设备

```
ffmpeg -devices
```

Mac的输出结果如下所示：

- 列表中有个[avfoundation](https://ffmpeg.org/ffmpeg-all.html#avfoundation)，是Mac平台的多媒体系统库
- 我们可以使用avfoundation去操作多媒体输入设备（比如录音设备）

```
Devices:
 D. = Demuxing supported
 .E = Muxing supported
 --
 D  avfoundation    AVFoundation input device
 D  lavfi           Libavfilter virtual input device
  E sdl,sdl2        SDL2 output device
```

## 二、查看avfoundation支持的设备

```
# 查看dshow支持的设备
ffmpeg -f avfoundation -list_devices true -i ''
```

- *-f avfoundation*
  - avfoundation支持的
- *-list_devices true*
  - 打印出所有的设备
-  *-i ''* 或 *-i ""*
  - 立即退出

输出结果如下

```
AVFoundation video devices:
 [0] FaceTime高清摄像头（内建）
 [1] Capture screen 0
AVFoundation audio devices:
 [0] MS-T800
 [1] Edu Audio Device
 [2] MacBook Pro麦克风
```

## 三、指定设备进行录音

```shell
# 在Mac上通过编号指定设备
ffmpeg -f avfoundation -i :2 out.wav
# :0表示使用0号音频设备
# 0:2表示使用0号视频设备和2号音频设备
```

## 四、设置avfoundation参数

通过命令查看一下avfoundation可以使用的参数

```
# 从ffmpeg -devices命令的结果可以看得出来：avfoundation属于demuxer，而不是muxer
ffmpeg -h demuxer=avfoundation
```

打印如下

```shell
Demuxer avfoundation [AVFoundation input device]:
AVFoundation indev AVOptions:
  -list_devices      <boolean>    .D......... list available devices (default false)
  -video_device_index <int>        .D......... select video device by index for devices with same name (starts at 0) (from -1 to INT_MAX) (default -1)
  -audio_device_index <int>        .D......... select audio device by index for devices with same name (starts at 0) (from -1 to INT_MAX) (default -1)
  -pixel_format      <pix_fmt>    .D......... set pixel format (default yuv420p)
  -framerate         <video_rate> .D......... set frame rate (default "ntsc")
  -video_size        <image_size> .D......... set video size
  -capture_cursor    <boolean>    .D......... capture the screen cursor (default false)
  -capture_mouse_clicks <boolean>    .D......... capture the screen mouse clicks (default false)
  -capture_raw_data  <boolean>    .D......... capture the raw data from device connection (default false)
  -drop_late_frames  <boolean>    .D......... drop frames that are available later than expected (default true)
```

