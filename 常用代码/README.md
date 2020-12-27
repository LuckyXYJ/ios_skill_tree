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

## CameraTool 相机相册

- 保存相册
- 获取相机权限

## LFKit

工具库LFKit

- 气泡提示框LFBubbleView
- 环形进度条LFAnnulusProgress
- 未读消息角标红点LFBadge

## Category

自定义一些分类，扩展系统类的功能

### UIImage+XZAdditions

- 截图
- 通过颜色生成图片
- 获取矩形的渐变色的UIImage
- 生成高斯模糊图片
- 将图片方向调整为适合观看的角度
- 截取部分图像
- 根据size缩放图片

### UIColor+XZAdditions

颜色转换

### UIDevice+XZAdditions

- 通过KeychainItemWrapper 获取设备不变uuid
- 获取手机 ip地址

### NSDate+Utilities

时间相关拓展属性

### NSURL+Encode

解决url中含有中文无法加载问题
