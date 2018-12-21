## 安全方案

对称密码：DES，3DES，AES

- 加解密用同一个密钥
- 加解密速度快
- 无法解决密钥配送问题

非对称加密：RSA

- 加解密不同密钥
- 公钥加密，私钥解密，或者私钥加密，公钥解密
- 加解密速度慢
- 解决密钥配送问题

单向散列函数：MD4,MD5,SHA-1,SHA-2,SHA-3

- 根据消息生成对应固定长度的散列值
- 防止数据被篡改

数字签名

- 用私钥加密消息的散列值，生成的密文

证书

- 用CA的私钥，对其他人的公钥生成数字签名

![image-20220705143738174](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220705143738174.png)

## iOS签名机制

iOS签名机制的作用：保证安装到用户手机上的APP都是经过Apple官方允许的

不管是真机调试，还是发布APP，开发者都需要经过一系列复杂的步骤

- 生成CertificateSigningRequest.certSigningRequest文件
- 获得ios_development.cer\ios_distribution.cer证书文件
- 注册device、添加App ID
- 获得*.mobileprovision文件

对于真机调试，现在的Xcode已经自动帮开发者做了以上操作

对应文件：

`.certSigningRequest`文件

- Mac公钥

`.cer` 文件

- 利用Apple私钥，对Mac公钥生成数字签名

` .mobileprovision`文件

- 利用Apple私钥，对【` .cer证书+devices+AppID+entitlements`】进行数字签名

iOS签名对应流程图：

![image-20220705144246315](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220705144246315.png)

App Store对应签名机制相对简单，流程图：

![image-20220705144607148](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220705144607148.png)