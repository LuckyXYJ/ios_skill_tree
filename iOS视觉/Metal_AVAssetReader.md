## AVAssetReader

AVAssetReader是`AVFoundation`中的一个读取器对象

- 1、直接从存储中读取原始未解码的媒体样本，获取解码为可渲染形式的样本：从mp4文件中拿到h264，并对其进行解码拿到可渲染的样本
- 2、混合资产的多个音轨，并使用和组合多个视频音轨

## AVAssetReader 类结构

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/815.png)

AVAssetReaderOutPut包含三种类型的输出

- AVAssetReaderTrackOutput：用于从`AVAssetReader`存储中读取单个轨道的媒体样本
- AVAssetReaderAudioMixOutput：用于读取音频样本
- AVAssetReaderVideoCompositionOutput：用于读取一个或多个轨道中的帧合成的视频帧

## AVAssetReader读取视频流程

- 从`AVAssetReader`存储中M获取mov/mp4视频文件，将视频文件解压缩，即解码，还原成`CMSampleBufferRef`图像数据
- 从`CMSampleBufferRef`中将图像数据读取到`CVPixelBufferRef`视频像素缓存区
- 利用`CVPixelBufferRef`像素缓存区数据 和 `CVMetalTextureCacheRef`纹理缓存区数据 创建metal纹理缓存区`CVMetalTextureRef`
- 将metal纹理缓存区`CVMetalTextureRef`的数据转换成metal纹理`id<MTLTexture>`
- 将mental纹理`id<MTLTexture>`传递到`GPU`中的片元着色函数

![img](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1200-20220822143519788.png)

