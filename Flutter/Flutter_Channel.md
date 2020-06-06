## Platform Channel 机制

Platform Channel机制用来实现Flutter与原生的通信。**Platform Channel**通讯是通过消息传递的方式进行。工作原理类似于二进制协议开发的网络服务

## Flutter Channel 

Flutter提供了三种Channel：

- FlutterBasicMessageChannel ：用作字符串与半结构化的数据传递
  - 结构化数据：包括预定义的数据类型，格式和结构的数据，如关系数据库中数据表里的数据
  - 半结构化数据：具有可识别的模式并可以解析的文本数据文件，如xml数据文件
  - 非结构化数据：没有固定结构的数据，通常保存为不同类型的文件，如文本，图片，视频等
- FlutterMethodChannel：用来调用方法，原生与flutter相互调用
- FlutterEventChannel：支持数据流通信

### 关键成员变量

#### 1、name

每个Channel唯一标志，通过name区分多个channel

#### 2、messenger：BinaryMessager

用作消息的发送和接收的工具，主要负责Flutter与原生的相互通讯

创建一个Channel后，不论是通过设置代理还是设置handler回调来处理消息。最终都会为该Channel绑定一个FLutterBinaryMessageHandler。并且是以name为key，保存在一个Map结构中。当接收到消息后，会根据消息中携带的name取出对应的FLutterBinaryMessageHandler，并交由BinaryMessenger处理

#### 3、codec编解码器

Flutter中采用二进制字节流作为数据传输协议。codec负责二进制编解码

messageCodec：对message进行编解码，用于二进制数据与基础数据之间的编解码，有多中实现

- FlutterStandardMessageCodec：是FlutterBasicMessageChannel中默认编解码器。用于数据类型和二进制数据之间的编解
- FlutterBinaryCodec：用于二进制与二进制之间的编解码
- FlutterStringCodec
- FlutterJSONMessageCodec：iOS 使用NSJSONSerialization作为序列号工具

FlutterMethodCodec：对FlutterMethodCall编解码。比FlutterMessageCodec多了两个处理调用结果的方法

- FlutterJSONMethodCodec
- FlutterStandardMethodCodec



