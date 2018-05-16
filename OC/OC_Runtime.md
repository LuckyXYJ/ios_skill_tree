## Runtime

OC是一门动态性比较强的编程语言，允许很多操作推迟到程序运行时再进行

OC的动态性就是由Runtime来支撑和实现的，Runtime是一套C语言的API，封装了很多动态性相关的函数

平时编写的OC代码，底层都是转换成了Runtime API进行调用

## isa指针

在arm64架构之前，isa就是一个普通的指针，存储着Class、Meta-Class对象的内存地址

从arm64架构开始，对isa进行了优化，变成了一个共用体（union）结构，还使用位域来存储更多的信息

![image-20220605101522274](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605101522274.png)

**nonpointer**

0，代表普通的指针，存储着Class、Meta-Class对象的内存地址；1，代表优化过，使用位域存储更多的信息

**has_assoc**

是否有设置过关联对象，如果没有，释放时会更快

**has_cxx_dtor**

是否有C++的析构函数（.cxx_destruct），如果没有，释放时会更快

**shiftcls**

存储着Class、Meta-Class对象的内存地址信息

**magic**

用于在调试时分辨对象是否未完成初始化

**weakly_referenced**

是否有被弱引用指向过，如果没有，释放时会更快

**deallocating**

对象是否正在释放

**extra_rc**

里面存储的值是引用计数器减1

**has_sidetable_rc**

引用计数器是否过大无法存储在isa中；如果为1，那么引用计数会存储在一个叫SideTable的类的属性中

## cache_t 方法缓存

Class内部结构中有个方法缓存（cache_t），用散列表（哈希表）来缓存曾经调用过的方法，可以提高方法的查找速度

![image-20220605103359536](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605103359536.png)

缓存查找

objc-cache.mm

bucket_t * cache_t::find(cache_key_t k, id receiver)

## objc_msgSend

OC中的方法调用，其实都是转换为objc_msgSend函数的调用

objc_msgSend的执行流程可以分为3大阶段

- 消息发送
- 动态方法解析
- 消息转发

## 消息发送

![image-20220605123625460](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605123625460.png)

如果是从class_rw_t中查找方法

- 已经排序的，二分查找
- 没有排序的，遍历查找

receiver通过**isa指针**找到receiverClass

receiverClass通过**superclass指针**找到superClass

## 动态方法解析

![image-20220605123907793](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220605123907793.png)

开发者可以实现以下方法，来动态添加方法实现

- +resolveInstanceMethod:
- +resolveClassMethod:

动态解析过后，会重新走“消息发送”的流程

- “从receiverClass的cache中查找方法”这一步开始执行

```objective-c
void c_other(id self, SEL _cmd) {
    NSLog(@"c_other - %@ - %@", self, NSStringFromSelector(_cmd));
}

- (void)other {
    NSLog(@"other - %s", __func__);
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 第一个参数是object_getClass(self)
        class_addMethod(object_getClass(self), sel, (IMP)c_other, "v16@0:8");
        
        return YES;
    }
    return [super resolveClassMethod:sel];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(test)) {
        // 动态添加test方法的实现
//        class_addMethod(self, sel, (IMP)c_other, "v16@0:8");
        
        // 获取其他方法
        Method method = class_getInstanceMethod(self, @selector(other));
        // 动态添加test方法的实现
        class_addMethod(self, sel,
                        method_getImplementation(method),
                        method_getTypeEncoding(method));
  
        // 返回YES代表有动态添加方法
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}

```

## 消息转发

![image-20220606195521004](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220606195521004.png)

开发者可以在forwardInvocation:方法中自定义任何逻辑

以上方法都有对象方法、类方法2个版本（前面可以是加号+，也可以是减号-）

**NSMethodSignature**获取：

```objective-c
NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
NSMethodSignature *signature = [[[ReceiveMethod alloc] init] methodSignatureForSelector:@selector(test)];
```

消息转发实现代码：

```objective-c
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        return [[ReceiveMethod alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

// 方法签名：返回值类型、参数类型
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test1)) {
        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    return [super methodSignatureForSelector:aSelector];
}

//// NSInvocation封装了一个方法调用，包括：方法调用者、方法名、方法参数
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%@", anInvocation);
    NSLog(@"%s", anInvocation.selector);
    NSLog(@"%@", anInvocation.target);
}
```

## @dynamic

提醒编译器不要自动生成setter和getter的实现、不要自动生成成员变量

## super的本质

super调用，底层会转换为objc_msgSendSuper2函数的调用，接收2个参数

- struct objc_super2
- SEL

![image-20220606205831713](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220606205831713.png)

- receiver是消息接收者
- current_class是receiver的Class对象

## runtime应用

- 查看私有成员变量
  - 设置UITextField占位文字的颜色
- 字典转模型
  - 利用Runtime遍历所有的属性或者成员变量
  - 利用KVC设值
- 替换方法实现
  - class_replaceMethod
  - method_exchangeImplementations

## Runtime API

类相关

```objective-c
// 动态创建一个类（参数：父类，类名，额外的内存空间）
Class objc_allocateClassPair(Class superclass, const char *name, size_t extraBytes)

// 注册一个类（要在类注册之前添加成员变量）
void objc_registerClassPair(Class cls) 

// 销毁一个类
void objc_disposeClassPair(Class cls)

// 获取isa指向的Class
Class object_getClass(id obj)

// 设置isa指向的Class
Class object_setClass(id obj, Class cls)

// 判断一个OC对象是否为Class
BOOL object_isClass(id obj)

// 判断一个Class是否为元类
BOOL class_isMetaClass(Class cls)

// 获取父类
Class class_getSuperclass(Class cls)
```

成员变量 

```objective-c
// 获取一个实例变量信息
Ivar class_getInstanceVariable(Class cls, const char *name)

// 拷贝实例变量列表（最后需要调用free释放）
Ivar *class_copyIvarList(Class cls, unsigned int *outCount)

// 设置和获取成员变量的值
void object_setIvar(id obj, Ivar ivar, id value)
id object_getIvar(id obj, Ivar ivar)

// 动态添加成员变量（已经注册的类是不能动态添加成员变量的）
BOOL class_addIvar(Class cls, const char * name, size_t size, uint8_t alignment, const char * types)

// 获取成员变量的相关信息
const char *ivar_getName(Ivar v)
const char *ivar_getTypeEncoding(Ivar v)

```

属性

```objective-c
// 获取一个属性
objc_property_t class_getProperty(Class cls, const char *name)

// 拷贝属性列表（最后需要调用free释放）
objc_property_t *class_copyPropertyList(Class cls, unsigned int *outCount)

// 动态添加属性
BOOL class_addProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount)

// 动态替换属性
void class_replaceProperty(Class cls, const char *name, const objc_property_attribute_t *attributes, unsigned int attributeCount)

// 获取属性的一些信息
const char *property_getName(objc_property_t property)
const char *property_getAttributes(objc_property_t property)

```

方法

```objective-c
// 获得一个实例方法、类方法
Method class_getInstanceMethod(Class cls, SEL name)
Method class_getClassMethod(Class cls, SEL name)

// 方法实现相关操作
IMP class_getMethodImplementation(Class cls, SEL name) 
IMP method_setImplementation(Method m, IMP imp)
void method_exchangeImplementations(Method m1, Method m2) 

// 拷贝方法列表（最后需要调用free释放）
Method *class_copyMethodList(Class cls, unsigned int *outCount)

// 动态添加方法
BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)

// 动态替换方法
IMP class_replaceMethod(Class cls, SEL name, IMP imp, const char *types)

// 获取方法的相关信息（带有copy的需要调用free去释放）
SEL method_getName(Method m)
IMP method_getImplementation(Method m)
const char *method_getTypeEncoding(Method m)
unsigned int method_getNumberOfArguments(Method m)
char *method_copyReturnType(Method m)
char *method_copyArgumentType(Method m, unsigned int index)
  
// 选择器相关
const char *sel_getName(SEL sel)
SEL sel_registerName(const char *str)

// 用block作为方法实现
IMP imp_implementationWithBlock(id block)
id imp_getBlock(IMP anImp)
BOOL imp_removeBlock(IMP anImp)

```





