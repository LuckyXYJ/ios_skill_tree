## HTTPS

超文本传输安全协议

端口：443

## SSL/TLS

TLS（Transport Layer Security），译为：传输层安全性协议 

前身是SSL（Secure Sockets Layer），译为：安全套接层

HTTPS = HTTP+SSL/TLS

FTPS = FTP + SSL/TLS

SMTPS =SMTP + SSL/TLS

**OpenSSL**  是SSL/TLS协议的来源实现

可以使用OpenSSL构建一套属于自己的CA，自己给自己颁发证书，称为“自签名证书”

## HTTPS vs HTTP 

优点：安全

缺点：

* 证书的费用
* 加解密计算性能消耗
* 降低访问速度

HTTPS 的通信过程

1. TCP的3次握手
2. TLS 的链接
3. HTTP请求和响应

## TLS 链接过程 1.2

![HTTPS-TLS过程](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/HTTPS-TLS%E8%BF%87%E7%A8%8B.png)

1. Client Hello

   TLS 版本号，支持的加密组件列表，一个**随机数**

2. Server Hello

   TLS的版本号，选择的加密组件，一个**随机数**

3. Certificate  

   1. 服务器的公钥证书（被CA签名过的）

4. Server Key Exchange

   1. 用以实现ECDHE（秘钥交换算法）算法的一个参数（Server Params）。Server Params经过服务器私钥签名

5. Server Hello Done

   告知客户端：协商部分结束

   目前为止，客户端和服务器之间通过明文共享了 Client Random、Server Random、Server Params

   而且，客户端也已经拿到了服务器的公钥证书，接下来，客户端会验证证书的真实有效性

6. Client Key Exchange

   用以实现ECDHE算法的另一个参数（Client Params）

   目前为止，客户端和服务器都拥有了ECDHE算法需要的2个参数：

   Server Params、Client Params 

   客户端、服务器都可以 使用ECDHE算法根据Server Params、Client Params计算出一个新的随机密钥串：Pre-master secret 

   然后结合Client Random、Server Random、Pre-master secret生成一个主密钥 

   最后利用主密钥衍生出其他密钥：客户端发送用的会话密钥、服务器发送用的会话密钥等

7. Change Cipher Spec

   告知服务器：之后的通信会采用计算出来的会话密钥进行加密

8. Finished

   1. 包含连接至今全部报文的整体校验值（摘要），加密之后发送给服务器 
   2. 这次握手协商是否成功，要以服务器是否能够正确解密该报文作为判定标准

9. Change Cipher Spec

10. Finished

    到此为止，客户端服务器都验证加密解密没问题，握手正式结束 

    后面开始传输加密的HTTP请求和响应

## HTTPS抓包

Charles抓包

```
help --> SSL Proxying --> 选择模拟器，移动设备，本机电脑
选择要抓包的接口 enable SSL Proxying
```

Wireshark	

```
设置环境变量SSLKEYLOGFILE（浏览器会将key信息导出到这个文件）
设置完成后，最好重启一下操作系统 
在Wireshark中选择这个文件  编辑 → 首选项 → Protocols → TLS
```



## 配置服务器HTTPS - 配置Tomcat

将证书*.jks文件放到TOMCAT_HOME/conf目录下

修改TOMCAT_HOME/conf/server.xml中的Connector

![HTTPS-Tomcat配置](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/HTTPS-Tomcat%E9%85%8D%E7%BD%AE.png)









