## 命令行实现

用法非常简单：

```sh
ffmpeg -c:a libfdk_aac -i in.aac -f s16le out.pcm
```

- *-c:a libfdk_aac*
  - 使用fdk-aac解码器
  - 需要注意的是：这个参数要写在aac文件那边，也就是属于输入参数
- *-f s16le*
  - 设置PCM文件最终的采样格式

## 代码实现

- 变量定义
- 获取解码器
- 初始化解析器上下文
- 创建上下文
- 创建AVPacket
- 创建AVFrame
- 打开解码器
- 打开文件
- 解码
- 设置输出参数
- 释放资源