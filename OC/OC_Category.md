## Category底层结构

![image-20220601174644778](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601174644778.png)

## Category加载过程

1.通过Runtime加载某个类的所有Category数据

2.把所有Category的方法、属性、协议数据，合并到一个大数组中。后面参与编译的Category数据，会在数组的前面

3.将合并后的分类数据（方法、属性、协议），插入到类原来数据的前面

## load方法

- +load方法会在runtime加载类、分类时调用
- 每个类、分类的+load，在程序运行过程中只调用一次
- +load方法是根据方法地址直接调用，并不是经过objc_msgSend函数调用
- 调用顺序
  - 1、先调用类的+load
    - 按照编译先后顺序调用（先编译，先调用）
    - 调用子类的+load之前会先调用父类的+load
  - 2、再调用分类的+load
    - 按照编译先后顺序调用（先编译，先调用）

## initialize方法

- +initialize方法会在类第一次接收到消息时调用
- 调用顺序
  - 先调用父类的+initialize，再调用子类的+initialize
  - (先初始化父类，再初始化子类，每个类只会初始化1次)

## +initialize和+load对比

+initialize是通过objc_msgSend进行调用的，所以有以下特点

- 如果子类没有实现+initialize，会调用父类的+initialize（所以父类的+initialize可能会被调用多次）
- 如果分类实现了+initialize，就覆盖类本身的+initialize调用

+load方法是根据方法地址直接调用，并不是经过objc_msgSend函数调用