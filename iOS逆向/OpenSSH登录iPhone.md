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



