## SSH、OpenSSH 与 SSL、OpenSSL

OpenSSH的加密就是通过OpenSSL完成的

SSH客户端和服务端版本要保持

iPhone默认是使用22端口进行SSH通信，采用的是TCP协议

### SSH

Secure Shell的缩写，意为“安全外壳协议”，是一种可以为远程登录提供安全保障的协议

使用SSH，可以把所有传输的数据进行加密，“中间人”攻击方式就不可能实现，能防止DNS欺骗和IP欺骗

### OpenSSH

是SSH协议的免费开源实现

可以通过OpenSSH的方式让Mac远程登录到iPhone

### SSL

Secure Sockets Layer的缩写，是为网络通信提供安全及数据完整性的一种安全协议，在传输层对网络连接进行加密

### OpenSSL

SSL的开源实现。绝大部分HTTPS请求等价于：HTTP + OpenSSL

## 使用OpenSSH远程登录

- 在Mac的终端输入**ssh 账户名@服务器主机地址**,
  比如ssh root@192.168.1.169（这里的服务器是手机）
- 初始密码**alpine**

登录成功后就可以使用终端命令行操作iPhone

退出登录命令是**exit**/**logout**,快捷键Ctrl+D

### root、mobile

iOS下有2个常用账户：root、mobile

- root：最高权限账户，$HOME是/var/root
- mobile：普通权限账户，只能操作一些普通文件，不能操作系统级别的文件，$HOME是/var/mobile

登录mobile用户：root mobile@服务器主机地址 

root和mobile用户的初始登录密码都是alpine

### 修改登录密码

登录root账户后，分别通过**passwd**、**passwd mobile**完成

## SSH通信过程

- 建立安全连接
- 客户端认证
- 数据传输

在建立安全连接过程中，服务器会提供自己的身份证明

如果客户端并无服务器端的公钥信息，就会询问是否连接此服务器

在建立安全连接过程中，可能会遇到以下**错误信息**：提醒服务器的身份信息发生了变更

如果确定要连接此服务器，删除掉之前服务器的公钥信息就行
`ssh-keygen -R 服务器IP地址`

或者直接打开known_hosts文件删除服务器的公钥信息就行
`vim ~/.ssh/known_hosts`

## SSH 的客户端认证方式

SSH-2提供了2种常用的客户端认证方式：

- 基于密码的客户端认证。使用账号和密码即可认证
- 基于密钥的客户端认证。免密码认证，最安全的一种认证方式

SSH-2默认会优先尝试“密钥认证”，如果认证失败，才会尝试“密码认证”

### 基于密钥的客户端认证

将客户端**公钥**内容追加到服务器**授权文件**尾部，即可直接登录

1、在客户端生成一对相关联的密钥（Key Pair）：一个公钥（Public Key），一个私钥（Private Key）。可以先到~/.ssh目录下看是否有id_rsa，id_rsa.pub两个文件。有的话可以直接下一步

`ssh-keygen` 

- 一路敲回车键（Enter）即可
- OpenSSH默认生成的是RSA密钥，可以通过-t参数指定密钥类型
- 生成的公钥：~/.ssh/id_rsa.pub
- 生成的私钥：~/.ssh/id_rsa

2、把客户端的公钥内容追加到服务器的授权文件（~/.ssh/authorized_keys）尾部

`ssh-copy-id root@服务器主机地址`

需要输入root用户的登录密码

ssh-copy-id会将客户端~/.ssh/id_rsa.pub的内容自动追加到服务器的~/.ssh/authorized_keys尾部

注意：由于是在~文件夹下操作，所以上述操作仅仅是解决了root用户的登录问题（不会影响mobile用户）

### scp 远程文件拷贝

scp是secure copy的缩写，是基于SSH登录进行安全的远程文件拷贝命令

除了ssh-copy-id自动追加方式之外，也可以通过scp手动将~/.ssh/id_rsa.pub拷贝到服务器上

1、复制客户端的公钥到服务器某路径

`scp ~/.ssh/id_rsa.pub root@服务器主机地址:~`

上面的命令行将客户端的~/.ssh/id_rsa.pub拷贝到了服务器的~地址

2、SSH登录服务器

`ssh root@服务器主机地址`

需要输入root用户的登录密码

3、在服务器创建.ssh文件夹

`mkdir .ssh`

4、追加公钥内容到授权文件尾部

`cat ~/id_rsa.pub >> ~/.ssh/authorized_keys`

5、删除公钥

`rm ~/id_rsa.pub`

### 文件权限

如果配置了免密码登录后，还是需要输入密码，需要在服务器端设置文件权限

chmod 755 ~

chmod 755 ~/.ssh

chmod 644 ~/.ssh/authorized_keys

## 通过USB进行SSH登录

默认情况下，由于SSH走的是TCP协议，Mac是通过网络连接的方式SSH登录到iPhone，要求iPhone连接WiFi

为了加快传输速度，也可以通过USB连接的方式进行SSH登录

Mac上有个服务程序usbmuxd（它会开机自动启动），可以将Mac的数据通过USB传输到iPhone

/System/Library/PrivateFrameworks/MobileDevice.framework/Resources/usbmuxd

![image-20220615144420689](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220615144420689.png)

### usbmuxd的使用

1、下载usbmuxd工具包（下载v1.0.8版本，主要用到里面的一个python脚本：tcprelay.py）

https://cgit.sukimashita.com/usbmuxd.git/snapshot/usbmuxd-1.0.8.tar.gz

2、将iPhone的22端口（SSH端口）映射到Mac本地的10010端口

`cd ~/Documents/usbmuxd-1.0.8/python-client`

`python tcprelay.py -t 22:10010`

加上-t参数是为了能够同时支持多个SSH连接

不一定非要10010端口，只要不是保留端口就行

**注意**：要想保持端口映射状态，不能终止此命令行（如果要执行其他终端命令行，请新开一个终端界面）

3、端口映射完毕后，以后如果想跟iPhone的22端口通信，直接跟Mac本地的10010端口通信就可以了

新开一个终端界面，SSH登录到Mac本地的10010端口（以下方式2选1）

```
ssh root@localhost -p 10010
ssh root@127.0.0.1 -p 10010
```

usbmuxd会将Mac本地10010端口的TCP协议数据，通过USB连接转发到iPhone的22端口

**远程拷贝**文件也可以直接跟Mac本地的10010端口通信

`scp -P 10010 ~/Desktop/1.txt root@localhost:~/test`

将Mac上的~/Desktop/1.txt文件，拷贝到iPhone上的~/test路径

**注意**：scp的端口号参数是大写的-P

## iOS终端的中文乱码问题

默认情况下，iOS终端不支持中文输入和显示

解决方案：新建一个~/.inputrc文件，文件内容是

- 不将中文字符转化为转义序列
  `set convert-meta off` 
- 允许向终端输出中文
  `set output-meta on`
- 允许向终端输入中文
  `set meta-flag on` 
  `set input-meta on`

如果是想在终端编辑文件内容，可以通过Cydia安装一个vim（软件源http://apt.saurik.com）





