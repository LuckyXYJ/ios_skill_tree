## SignatureView 绘制

- 手写签名、
- 也可以用作水印相机涂鸦

## SystemUtil 系统相关

- 拨打电话
- 打开应用商店页面
- 打开Safari浏览器
- 保存相册
- 改变StatusBar颜色

## XZTools 常用代码片段

```
BOOL xz_isNull(id obj);
BOOL xz_isEmptyString(NSString *string);
NSString * xz_makeSureString(NSString *str);
NSDictionary * xz_makeSureDictionary(NSDictionary *dic );
NSArray * xz_makeSureArray(NSArray *array );
NSString * xz_stringFromInt(NSInteger i);
NSString * xz_timeStamp(void);
NSString * xz_documentDirectory(void);


void XZSwizzleInstanceMethod(Class class, SEL originalSelector, SEL alternativeSelector);
void XZSwizzleClassMethod(Class class, SEL originalSelector, SEL alternativeSelector);
```



