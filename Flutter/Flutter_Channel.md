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

