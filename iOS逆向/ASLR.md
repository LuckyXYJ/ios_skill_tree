## ASLR

Address Space Layout Randomization，地址空间布局随机化

是一种针对缓冲区溢出的安全保护技术，通过对堆、栈、共享库映射等线性区布局的随机化，通过增加攻击者预测目的地址的难度，防止攻击者直接定位攻击代码位置，达到阻止溢出攻击的目的的一种技术

iOS4.3开始引入了ASLR技术

## Mach-O的文件结构

![image-20220628174945828](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220628174945828.png)

## 未使用ASLR

- 函数代码存放在__TEXT段中

- 全局变量存放在__DATA段中

- 可执行文件的内存地址是0x0

- 代码段（__TEXT）的内存地址

  - 就是LC_SEGMENT(__TEXT)中的VM Address
  - arm64：0x100000000（8个0）
  - 非arm64：0x4000（3个0）

- 可以使用size -l -m -x来查看Mach-O的内存分布

  

![image-20220628180635335](/Users/xyj/Library/Application Support/typora-user-images/image-20220628180635335.png)

## 使用ASLR

- LC_SEGMENT(__TEXT)的VM Address

  - 0x100000000

  

- ASLR随机产生的Offset（偏移）

  - 0x5000
  - 也就是可执行文件的内存地址

![image-20220628180815063](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220628180815063.png)
