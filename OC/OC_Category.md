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

## 添加成员变量

默认情况下，因为分类底层结构的限制，不能添加成员变量到分类中。但可以通过关联对象来间接实现

关联对象提供了以下API：

**添加关联对象**

```
void objc_setAssociatedObject(id object, const void * key, id value, objc_AssociationPolicy policy)
```

| **objc_AssociationPolicy**        | **对应的修饰符**  |
| --------------------------------- | ----------------- |
| OBJC_ASSOCIATION_ASSIGN           | assign            |
| OBJC_ASSOCIATION_RETAIN_NONATOMIC | strong, nonatomic |
| OBJC_ASSOCIATION_COPY_NONATOMIC   | copy, nonatomic   |
| OBJC_ASSOCIATION_RETAIN           | strong, atomic    |
| OBJC_ASSOCIATION_COPY             | copy, atomic      |

**获得关联对象**

```
id objc_getAssociatedObject(id object, const void * key)
```

**移除所有的关联对象**

```
void objc_removeAssociatedObjects(id object)
```

### 关联对象key

```objective-c
static void *MyKey = &MyKey;

objc_setAssociatedObject(obj, MyKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
objc_getAssociatedObject(obj, MyKey)


static char MyKey;

objc_setAssociatedObject(obj, &MyKey, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
objc_getAssociatedObject(obj, &MyKey)


使用属性名作为key

objc_setAssociatedObject(obj, @"property", value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
objc_getAssociatedObject(obj, @"property");


使用get方法的@selecor作为key

objc_setAssociatedObject(obj, @selector(getter), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC)
objc_getAssociatedObject(obj, @selector(getter))
```

## 关联对象原理

实现关联对象技术的核心对象有

- AssociationsManager
- AssociationsHashMap
- ObjectAssociationMap
- ObjcAssociation

![image-20220601193652103](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601193652103.png)

关联对象并不是存储在被关联对象本身内存中

关联对象存储在全局的统一的一个AssociationsManager中

设置关联对象为nil，就相当于是移除关联对象

![image-20220601193831823](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601193831823.png)

## 分类与扩展

分类 category:

- 1、专门给类添加新的方法
- 2、不能添加成员属性，添加了成员变量，也无法取到
- 3、可以通过runtime给分类添加属性
- 4、分类中用@property定义变量，只会生成变量的getter,setter方法的声明，不能生成方法实现和带下划线的成员变量

扩展 extension:

- 1、是特殊的分类，也叫做匿名分类
- 2、可以给类添加成员属性，但是是私有变量
- 3、可以给类添加方法，也是私有方法