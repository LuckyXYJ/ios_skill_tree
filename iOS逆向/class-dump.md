## class-dump

作用是把Mach-O文件的class信息给dump出来（把类信息给导出来），生成对应的.h头文件

官方地址：http://stevenygard.com/projects/class-dump/

下载完工具包后将class-dump文件复制到Mac的/usr/local/bin目录，这样在终端就能识别class-dump命令了

上面下载地址最后更新时间都是2013年了， 还是自己下载源文件编译吧，[GitHub地址](https://github.com/nygard/class-dump)

## 使用命令

`class-dump  -H  Mach-O文件路径  -o  头文件存放目录`

-H表示要生成头文件

-o用于制定头文件的存放目录







```



常用格式
class-dump  -H  Mach-O文件路径  -o  头文件存放目录
-H表示要生成头文件
-o用于制定头文件的存放目录


```

