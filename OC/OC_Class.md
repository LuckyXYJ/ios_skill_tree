## objc_class的结构

![image-20220601103622311](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601103622311.png)

objc_class 继承与 objc_object

所有对象都是以objc_object为模板继承过来的

## isKindOfClass 和 isMemberOfClass

### **isMemberOfClass**

- 调用者必须是传入的类的实例对象才返回YES
- 判断调用者是否是传入对象的实例，别弄反了，如 [ins isMemberOfClass:cls] ，意思是ins是否是cls的实例对象
- 不进行父类递归去查找判断

```
+ (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
}
- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}
```

### **isKindOfClass**

- 调用者是传入的类的实例对象，或者调用者是传入类的继承者链中的类的实例对象，则返回YES
- 判断调用者是否是传入对象的子类，别弄反了
- 去父类递归查找判断

```
+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->super_class) {
        if(tcls == cls) return YES;
    }
    return NO;
}
-（BOOL)isKindOfClass:(Class)cls {
    for(Class tcls = [self class]; tcls; tcls = tcls->super_class) {
        if(tcls == cls) return YES;
    }
    return NO;
}
```

## cache_t 方法缓存

![Cache_t原理分析图](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/Cooci%20%E5%85%B3%E4%BA%8ECache_t%E5%8E%9F%E7%90%86%E5%88%86%E6%9E%90%E5%9B%BE.png)

_buckets   
    imp
    SEL
_mask  
_flags 标志位
_occupied 占用情况    

## bits

uint32_t flags;
uint32_t version;
const class_ro_t *ro;
method_list_t *methods; 方法列表
property_list_t *properties;   属性列表 
const protocol_list_t *protocols; 协议列表
Class firstSubclass;
Class nextSiblingClass;
char *demangledName;

## 成员变量 、属性 、实例变量

属性 = 带下划线成员变量 + setter + getter 方法
实例变量： 特殊的成员变量（类的实例化）

## 方法 sel + IMP 

sel 方法编号
IMP 函数指针地址

name + type + imp

## 获取Class的几个方法 object_getClass，class，objc_getMetaClass

```+ (Class)class;``` 返回本身
```- (Class)class;``` 调用 object_getClass

```
Class object_getClass(id obj)
{
    if (obj) return obj->getIsa();
    else return Nil;
}
```

```
Class objc_getMetaClass(const char *aClassName)
{
    Class cls;

    if (!aClassName) return Nil;

    cls = objc_getClass (aClassName);
    if (!cls)
    {
        _objc_inform ("class `%s' not linked into application", aClassName);
        return Nil;
    }

    return cls->ISA();
}
```

## objc_getClass,object_getClass

Class objc_getClass(const char *aClassName)

- 传入字符串类名
- 返回对应的类对象

Class object_getClass(id obj)

- 传入的obj可能是instance对象、class对象、meta-class对象
- 返回值
  - 如果是instance对象，返回class对象
  - 如果是class对象，返回meta-class对象
  - 如果是meta-class对象，返回NSObject（基类）的meta-class对象



