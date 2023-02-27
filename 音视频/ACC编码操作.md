## 一、libfdk_aac编码要求

fdk-aac对输入的PCM数据是有[参数要求](https://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#Sample_Format)的，如果参数不对，会出现错误

### 采样格式

必须是16位整数PCM。

### 采样率

支持的采样率有（Hz）：

- 8000、11025、12000、16000、22050、24000、32000
- 44100、48000、64000、88200、96000

## 二、命令行进行编码

### 基本使用

最简单的用法如下所示：

```sh
# pcm -> aac
ffmpeg -ar 44100 -ac 2 -f s16le -i in.pcm -c:a libfdk_aac out.aac
 
# wav -> aac
# 为了简化指令，本文后面会尽量使用in.wav取代in.pcm
ffmpeg -i in.wav -c:a libfdk_aac out.aac
```

- *-ar 44100 -ac 2 -f s16le*
  - PCM输入数据的参数
- *-c:a*
  - 设置音频编码器
  - c表示codec（编解码器），a表示audio（音频）
  - 等价写法
    - *-codec:a*
    - *-acodec*
  - 需要注意的是：这个参数要写在aac文件那边，也就是属于输出参数

默认生成的aac文件是LC规格的。

```sh
ffprobe out.aac
 
# 输出结果如下所示
Audio: aac (LC), 44100 Hz, stereo, fltp, 120 kb/s
```

### [常用参数](https://ffmpeg.org/ffmpeg-all.html#libfdk_005faac)

- -b:a
  - 设置输出比特率
  - 比如*-b:a 96k*

```sh
复制代码
Shell
ffmpeg -i in.wav -c:a libfdk_aac -b:a 96k out.aac
```

- -profile:a
  - 设置输出规格
  - 取值有：
    - aac_low：Low Complexity AAC (LC)，默认值
    - aac_he：High Efficiency AAC (HE-AAC)
    - aac_he_v2：High Efficiency AAC version 2 (HE-AACv2)
    - aac_ld：Low Delay AAC (LD)
    - aac_eld：Enhanced Low Delay AAC (ELD)
  - 一旦设置了输出规格，会自动设置一个合适的输出比特率
    - 也可以用过*-b:a*自行设置输出比特率

```sh
ffmpeg -i in.wav -c:a libfdk_aac -profile:a aac_he_v2 -b:a 32k out.aac
```

- -vbr
  - 开启[VBR](https://wiki.hydrogenaud.io/index.php?title=Fraunhofer_FDK_AAC#Bitrate_Modes)模式（Variable Bit Rate，可变比特率）
  - 如果开启了VBR模式，*-b:a*选项将会被忽略，但*-profile:a*选项仍然有效
  - 取值范围是0 ~ 5
    - 0：默认值，关闭VBR模式，开启CBR模式（Constant Bit Rate，固定比特率）
    - 1：质量最低（但是音质仍旧很棒）
    - 5：质量最高

| VBR  | kbps/channel | AOTs         |
| ---- | ------------ | ------------ |
| 1    | 20-32        | LC、HE、HEv2 |
| 2    | 32-40        | LC、HE、HEv2 |
| 3    | 48-56        | LC、HE、HEv2 |
| 4    | 64-72        | LC           |
| 5    | 96-112       | LC           |

AOT是Audio Object Type的简称。

```sh
ffmpeg -i in.wav -c:a libfdk_aac -vbr 1 out.aac
```

### 文件格式

AAC编码的文件扩展名主要有3种：aac、m4a、mp4。

```sh
# m4a
ffmpeg -i in.wav -c:a libfdk_aac out.m4a
 
# mp4
ffmpeg -i in.wav -c:a libfdk_aac out.mp4
```

## 三、编程进行编码

- 变量定义
- 获取编码器
- 检查采样格式
- 创建上下文
- 打开编码器
- 创建AVFrame
  - AVFrame用来存放编码前的数据。
- 创建AVPacket
- 打开文件
- 开始编码
- 资源回收

