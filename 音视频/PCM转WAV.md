## PCM存在问题

PCM是音频文件元数据，并不包含采样率、声道数、位深度等参数。播放器不知道相关参数无法直接读取

## WAV文件格式

- WAV、AVI文件都是基于RIFF标准的文件格式
- RIFF（Resource Interchange File Format，资源交换文件格式）由Microsoft和IBM提出
- 所以WAV、AVI文件的最前面4个字节都是RIFF四个字符

![WAV文件格式](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/497279-20210319021131588-1269411109.png)

每一个chunk（数据块）都由3部分组成：

- id：chunk的标识
- data size：chunk的数据部分大小，字节为单位
- data，chunk的数据部分

整个WAV文件是一个RIFF chunk，它的data由3部分组成：

- format：文件类型
- fmt chunk
  - 音频参数相关的chunk
  - 它的data里面有采样率、声道数、位深度等参数信息
- data chunk
  - 音频数据相关的chunk
  - 它的data就是真正的音频数据（比如PCM数据）

RIFF chunk除去data chunk的data（音频数据）后，剩下的内容可以称为：WAV文件头，一般是44字节。

## PCM转成WAV命令

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

