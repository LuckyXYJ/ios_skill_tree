## KVC

KVC的全称是Key-Value Coding，俗称“键值编码”，可以通过一个key来访问某个属性

### 常见的API有

```
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;

- (void)setValue:(id)value forKey:(NSString *)key;

- (id)valueForKeyPath:(NSString *)keyPath;

- (id)valueForKey:(NSString *)key; 
```

## setValue:forKey:的原理

![image-20220601173829649](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601173829649.png)

naccessInstanceVariablesDirectly方法的默认返回值是YES

## valueForKey:的原理

![image-20220601173914278](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601173914278.png)