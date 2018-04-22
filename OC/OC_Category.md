## Category底层结构

![image-20220601174644778](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601174644778.png)

## Category加载过程

1.通过Runtime加载某个类的所有Category数据

2.把所有Category的方法、属性、协议数据，合并到一个大数组中。后面参与编译的Category数据，会在数组的前面

3.将合并后的分类数据（方法、属性、协议），插入到类原来数据的前面





















