## 查找响应者

```objectivec
- (nullable UIView *)hitTest:(CGPoint)point withEvent:(nullable UIEvent *)event;
- (BOOL)pointInside:(CGPoint)point withEvent:(nullable UIEvent *)event;
```

### hitTexst

它首先会通过调用自身的 pointInside 方法判断用户触摸的点是否在当前对象的响应范围内,如果 pointInside 方法返回 NO hitTest方法直接返回 nil

如果 pointInside 方法返回 YES hitTest方法接着会判断自身是否有子视图.如果有则调用顶层子视图的 hitTest 方法 直到有子视图返回 View

如果所有子视图都返回 nil hitTest 方法返回自身.

![img](https://upload-images.jianshu.io/upload_images/2026683-67629efe30d1ff5b.png?imageMogr2/auto-orient/strip|imageView2/2/w/176/format/webp)

## 事件传递

```objectivec
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event;
- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch *> *)touches NS_AVAILABLE_IOS(9_1);
```

1、找到第一响应者 application 便会根据 event 调用第一响应者响

2、第一响应者在这几个方法中处理响应的事件,处理完成后根据需要调用 nextResponder 的 touch 方法,通常 nextResponder 就是第一响应者的 superView 文章的第一张图倒着看就是nextResponder 的顺序

## 事件处理流程

1 当用户点击屏幕时，会产生一个触摸事件，系统会将该事件加入到一个由UIApplication管理的事件队列中

2 UIApplication会从事件队列中取出最前面的事件进行分发以便处理，通常，先发送事件给应用程序的主窗口(UIWindow)

3 主窗口会调用hitTest:withEvent:方法在视图(UIView)层次结构中找到一个最合适的UIView来处理触摸事件
(hitTest:withEvent:其实是UIView的一个方法，UIWindow继承自UIView，因此主窗口UIWindow也是属于视图的一种)

通常第一响应者都是响应链中最末端的响应者,事件拦截就是在响应链中截获事件,停止下发.将事件交由中间的某个响应者执行.比如这样:

## 应用

### 1、扩大按钮的点击区域(上下左右各增加20)

重写按钮的 pointInside 方法

```objectivec
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(CGRectInset(self.bounds, -20, -20), point)) {
        return YES;
    }
    return NO;
}
```

###  2、子view超出了父view的bounds响应事件

正常情况下，子View超出父View的bounds的那一部分是不会响应事件的。一般解决方案：修改父view的大小

解决方法:重写`父View`的pointInside方法，使事件Point 在超出父view的部分返回 true

```objectivec
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL flag = NO;
    for (UIView *view in self.subviews) {
        if (CGRectContainsPoint(view.frame, point)){
            flag = YES;
            break;
        }
    }
    return flag;
}
```

### 3、如果一个Button被一个View盖住了，在触摸View时，希望该Button能够响应事件

解决方法1：点击View及View的非交互子View(例如UIImageView)，则该Button可以响应事件

```objectivec
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL next = YES;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIControl class]]) {
            if (CGRectContainsPoint(view.frame, point)){
                next = NO;
                break;
            }
        }
    }
    return !next;
}
```

解决方法2：点击View本身Button会响应该事件，点击View的任何一个子View，Button不会响应事件

```objectivec
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self) {
        return nil;
    }
    return view;
}
```

### 4 特殊的UIScrollView

![img](https://upload-images.jianshu.io/upload_images/877723-15656a6ae22859d3.png?imageMogr2/auto-orient/strip|imageView2/2/w/465)

该ScrollView可以显示上一页和下一页的部分界面，红色框是ScrollView的frame，绿色框部分是设置了clipsToBounds = NO的结果，但是正如情况2提到的，超出部分是不响应事件的。

```objectivec
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat width = size.width - 80;
    JCScrollView *scrollView = [[JCScrollView alloc] initWithFrame:CGRectMake(40, size.height - 150 - 30, width, 150)];
    scrollView.pagingEnabled = YES;
    scrollView.clipsToBounds = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView setContentSize:CGSizeMake(width * 5, 150)];
    
    for (NSInteger i = 0; i < 5; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5 + width * i, 0, width - 10, 150)];
        view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255) / 255.0f green:arc4random_uniform(255) / 255.0f blue:arc4random_uniform(255) / 255.0f alpha:1];
        [scrollView addSubview:view];
    }
    
    [self.view addSubview:scrollView];
```

如果需要绿色框响应ScrollView的滚动事件，则原理和情况1一样

```objectivec
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    if (CGRectContainsPoint(CGRectInset(self.bounds, -40, 0), point)) {
        return YES;
    }
    return NO;
}
```