## 文件相关

### 文件编辑 VIM

1. 模式切换
   - 从命令模式->编辑模式：i，a，o，I，A，O
   - 从编辑模式->命令模式：ESC
   - 从命令模式->末行模式：输入一个冒号，即shift+；
2. 模式内编辑
   - 末行模式：
     - w保存，
     - q退出
     - ！强制退出(切换进出)
   - 命令模式：
     - hjkl控制上下移动
     - M中间位置
     - L当前屏幕的最后一行
     - yy：复制，8yy：表示从当前光标所在的行开始复制8行
     - p：黏贴
     - dd：剪切，8dd：表示从当前光标所在的行开始剪切8行
     - u：撤销
     - ctl+r：反撤销
     - G：跳到最后一行
     - 15G：跳转到第15行
     - 1G：跳转到第一行
     - gg：跳转到第一行

### 文件操作

删除文件

```
rm filename
```

删除文件夹

```
# 删除文件夹，文件夹非空时无法删除
rmdir data
# rmdir: failed to remove 'data': Directory not empty

# 删除目录不加 -r 会报错
$ rm data
# rm: cannot remove ‘data’: Is a directory
 
# 正确删除目录  -r 表示递归删除文件夹，加f 表示强制删除，不报任何提示
$ rm -r data
 
# 强制删除目录
$ rm -rf data
```

创建文件夹

```
mkdir data
```

### 文件查找 find操作

#### 按名称或正则表达式查找文件

```
// 要按特定名称搜索文件
find . -name test.txt

// 查找所有格式为 pdf 的书籍, 正则表达式
find ./yang/books -name "*.pdf"

// 默认情况下，find 命令会搜索常规文件，但最好进行指定（-type f）以使所有内容更清晰
find ./yang/books -type f -name "*.pdf"
```

#### 查找不同类型的文件

```
// 目录
find . -type d -name "yang*"

// 符号链接
find . -type l -name "yang*"

```

#### 按指定的时间戳查找文件

- **访问时间戳 (atime)**：最后一次读取文件的时间。
- **修改时间戳 (mtime)**：文件内容最后一次被修改的时间。
- **更改时间戳 (ctime)**：上次更改文件元数据的时间（如，所有权、位置、文件类型和权限设置）

```
// 搜索atime超过一年的文件
find . -type f -atime +365

//查找mtime正好是 5 天前的文件
find . -type f -mtime 5

//+表示“大于”，-表示“小于”。所以我们可以搜索ctime在 5~10 天前的文件
find . -type f -ctime +5 -ctime -10
```

#### 按大小查找文件

`-size`选项使我们能够按指定大小查找文件。我们可以将其计量单位指定为以下约定：

- `b`：512 字节块（默认）
- `c`：字节
- `w`：双字节字
- `k`：KB
- `M`：MB
- `G`：GB

```
// 要查找大小为 10 MB ~ 1 GB 的文件：
find . -type f -size +10M -size -1G
```

#### 按权限查找文件

`find`命令的`-perm`选项可以帮助我们按指定权限查找文件：

```
// 搜索所有具有 777 权限的文件
find . -type f -perm 777
```

#### 按所有权查找文件

我们可以使用`-user`选项指定用户名

```
// 查找所有属于yang的文件：
find -type f -user yang
```

#### 在找到文件后执行命令

在大多数情况下，我们希望在找到我们需要的文件后进行后续操作。例如将其删除，或检查它们的详细信息等等。`-exec`命令使这些所有事情变得更加容易。

```
// 此命令在`-exec`选项后是`rm -rf`，其用于删除文件。`{}`是用于查找结果的占位符。
find . -type f -atime +365 -exec rm -rf {} \;
```

## 网络相关

### ping 用法

ping /? 查看ping的用法

ping ip地址 -l 数据包大小 发送指定大小的数据包

ping ip地址 -f 不允许网络层分片    

ping ip地址 -i TTL 设置TTL的值

通过tracert、pathping命令，可以跟踪数据包经过了哪些路由器

### 端口号命令行

netstat -an: 查看被占用的端口

netstat -anb: 查看被占用的端口、占用端口的应用程序

telnet 主机 端口：查看是否可以访问主机的某个端口

### DNS 常用命令

ipconfig /displaydns：查看DNS缓存记录

ipconfig /flushdns：清空DNS缓存记录

ping 域名

nslookup 域名

### DHCP 命令

ipconfig /all：可以看到DHCP相关的详细信息，比如租约过期时间、DHCP服务器地址等

ipconfig /release：释放租约 

ipconfig /renew：重新申请IP地址、申请续约（延长租期）

### OpenSSL

生成私钥：openssl genrsa -out mj.key 

生成公钥：openssl rsa -in mj.key -pubout -out mj.pem

## 其他常用

### 连接服务器 

ssh root@x.x.x.x

### 允许任何来源应用

```
sudo spctl  --master-disable
```

### 进入目录搜索UIWebView

```
grep -r UIWebView . 
```

### brew

brew services start jenkins