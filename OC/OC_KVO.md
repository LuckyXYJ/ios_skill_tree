## KVO

KVO的全称是Key-Value Observing，俗称“键值监听”，可以用于监听某个对象属性值的改变

## KVO 使用方式

### 1、添加观察者

```objective-c
// 摘自AFNetworking
for (NSString *keyPath in AFHTTPRequestSerializerObservedKeyPaths()) {
        if ([self respondsToSelector:NSSelectorFromString(keyPath)]) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:AFHTTPRequestSerializerObserverContext];
        }
    }
```

### 2、实现 observeValueForKeyPath:ofObject:change:context: 方法

```objective-c
// 摘自AFNetworking
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(__unused id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (context == AFHTTPRequestSerializerObserverContext) {
        if ([change[NSKeyValueChangeNewKey] isEqual:[NSNull null]]) {
            [self.mutableObservedChangedKeyPaths removeObject:keyPath];
        } else {
            [self.mutableObservedChangedKeyPaths addObject:keyPath];
        }
    }
}
```



### 3、移除观察者 removeObserver:forKeyPath:

```objective-c
- (void)dealloc {
    for (NSString *keyPath in AFHTTPRequestSerializerObservedKeyPaths()) {
        if ([self respondsToSelector:NSSelectorFromString(keyPath)]) {
            [self removeObserver:self forKeyPath:keyPath context:AFHTTPRequestSerializerObserverContext];
        }
    }
}
```



## KVO 禁用

```objective-c
// 摘自AFNetworking
+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
    if ([AFHTTPRequestSerializerObservedKeyPaths() containsObject:key]) {
        return NO;
    }

    return [super automaticallyNotifiesObserversForKey:key];
}
```

## KVO 设置依赖

```objective-c
+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    if ([key isEqualToString:@"reachable"] || [key isEqualToString:@"reachableViaWWAN"] || [key isEqualToString:@"reachableViaWiFi"]) {
        return [NSSet setWithObject:@"networkReachabilityStatus"];
    }

    return [super keyPathsForValuesAffectingValueForKey:key];
}
```

## KVO原理

1:动态生成子类:NSKVONotifiy_A 

2:给动态子类添加Setter方法

3:消息转发给父类(runtime消息转发)

![image-20220601140719614](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601140719614.png)

![image-20220601140706480](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20220601140706480.png)

### _NSSet*ValueAndNotify的内部实现

调用willChangeValueForKey:

调用原来的setter实现

调用didChangeValueForKey:

- didChangeValueForKey:内部会调用observer的observeValueForKeyPath:ofObject:change:context:方法

## KVO存在问题

1、必须成对出现

2、重复添加，重复几次，执行几次响应

3、重复移除，移除超过添加次数后，**NSRangeException**报错。

**在移除观察的时候NSKVONotifying_XXX 是否移除? + isa 是否会回来?**  答：不会

