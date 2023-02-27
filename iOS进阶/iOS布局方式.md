## 布局方式

frame，AutoLayout，Autoresizing，NSLayoutAnchor，自动布局SnapKit/Masonry

## AutoLayout

### NSLayoutConstraint使用
使用很久的Masonry，但是对其原理不是很了解，大概看了一下，是基于NSLayoutConstraint的一个框架。今天就先看下NSLayoutConstraint的使用

#### NSLayoutConstraint的使用方式

```
+ (NSArray<NSLayoutConstraint *> *)constraintsWithVisualFormat:(NSString *)format options:(NSLayoutFormatOptions)opts metrics:(nullable NSDictionary<NSString *, id> *)metrics views:(NSDictionary<NSString *, id> *)views API_AVAILABLE(macos(10.7), ios(6.0), tvos(9.0));

+ (instancetype)constraintWithItem:(id)view1 attribute:(NSLayoutAttribute)attr1 relatedBy:(NSLayoutRelation)relation toItem:(nullable id)view2 attribute:(NSLayoutAttribute)attr2 multiplier:(CGFloat)multiplier constant:(CGFloat)c API_AVAILABLE(macos(10.7), ios(6.0), tvos(9.0));
```

##### 一、constraintWithItem方式

直接上代码

```

UIView *superView = [[UIView alloc]initWithFrame:CGRectMake(30, 200, SCREEN_WIDTH - 60, 300)];
    superView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:superView];
    
    UIView *subView = [[UIView alloc]init];
    subView.backgroundColor = [UIColor yellowColor];
    subView.frame = CGRectMake(0, 0, 100, 100);
    
    /**
     添加约束之前，需要将视图添加到父视图上；
     */
    [self.view addSubview:subView];
    
    /**
     当使用autolayout布局是时，需要将视图的translatesAutoresizingMaskIntoConstraints属性设置为NO，不设置的话约束白加
     */
    subView.translatesAutoresizingMaskIntoConstraints = NO;
    
    /**
        七个参数
        1、要约束的视图view1
        2、约束类型attr1，宽，高，中心，上，下，左右
        3、约束方式，等于，小于等于。。。
        4、约束参照视图view2
        5、参照视图的参照属性attr2，上下左右。。。
        6、乘数multiplier，倍数
        7、约束值constant。
     
     约束结果：view1.attr1 等于(约束方式) view2.attr2*multiplier +constant
     */
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:subView attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeBottom) multiplier:1 constant:30];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:subView attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:superView attribute:(NSLayoutAttributeLeft) multiplier:1 constant:30];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:subView attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeWidth multiplier:1 constant:50];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:subView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50];
    
    /**
     约束添加到哪个视图
     1、自身约束。不需要依赖其他视图，如宽高数值，view2 = null，attr2 = NSLayoutAttributeNotAnAttribute。约束添加到view1上
     2、相对父视图约束。约束添加到层级相对更高的视图上。
     3、相对兄弟视图约束。约束添加到兄弟视图共同的父视图上 （别说面试造航母了， 这不就是是两个链表的第一个公共节点面试题应用场景）
        View+MASAdditions 类中的mas_closestCommonSuperview方法便是找父视图
     */
    
    [self.view addConstraint:constraint];
    [self.view addConstraint:constraint1];
    [subView addConstraint:constraint2];
    [subView addConstraint:constraint3];
    
```


这种方式的关键点

###### 1、设置translatesAutoresizingMaskIntoConstraints 为NO
关闭该属性，否则写布局代码等于写个空气
###### 2、NSLayoutConstraint的创建
创建需要七个参数
1. 指定要约束的视图view1
2. 约束类型attr1，宽、高、左、右、上、下...
3. 约束方式，等于、小于等于...
4. 约束参照视图view2.如果设置具体宽高数据，可以传空
5. 参照视图的参照属性attr2, view2为空时传NSLayoutAttributeNotAnAttribute，传其他的也一样
6. 乘数multiplier，倍数
7. 约束值constant。

约束结果：view1.attr1 等于(约束方式) view2.attr2*multiplier +constant

##### 3、比较重要的是约束添加到哪个视图
1. 自身约束。不需要依赖其他视图，如宽高数值，view2 = null，attr2 = NSLayoutAttributeNotAnAttribute。约束添加到view1上
2. 相对父视图约束。约束添加到层级相对更高的视图上。
3. 相对兄弟视图约束。约束添加到兄弟视图共同的父视图上
- 别说面试造航母了， 这不就是是两个链表的第一个公共节点面试题应用场景
- Masonry中View+MASAdditions 类中的mas_closestCommonSuperview方法便是找父视图,但是实现方式有点low，不过影响不大，依然是很优秀的框架

##### 相关参数说明
```
NSLayoutAttribute类型
     NSLayoutAttributeLeft 视图的左边
     NSLayoutAttributeRight 视图的右边
     NSLayoutAttributeTop 视图的上边
     NSLayoutAttributeBottom 视图的下边
     NSLayoutAttributeLeading 视图的前边
     NSLayoutAttributeTrailing 视图的后边
     NSLayoutAttributeWidth 视图的宽度
     NSLayoutAttributeHeight 视图的高度
     NSLayoutAttributeCenterX 视图的中点的X值
     NSLayoutAttributeCenterY 视图中点的Y值
     NSLayoutAttributeBaseline 视图的基准线
     NSLayoutAttributeNotAnAttribute 无属性

     3.NSLayoutRelation的类型：
     
     NSLayoutRelationLessThanOrEqual 视图关系小于或等于
     NSLayoutRelationEqual      视图关系等于
     NSLayoutRelationGreaterThanOrEqual      视图关系大于或等于
```

#### 二、constraintsWithVisualFormat方式

还是先上代码

```
UIView *view1 = [[UIView alloc]init];
    view1.backgroundColor = [UIColor yellowColor];
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:view1];
    
    UIView *view2 = [[UIView alloc]init];
    view2.backgroundColor = [UIColor yellowColor];
    view2.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:view2];
    
    UIView *view3 = [[UIView alloc]init];
    view3.backgroundColor = [UIColor yellowColor];
    view3.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:view3];
    
    NSString *hVFL = @"H:|-space-[view1(==100)]-space1-[view2]-space-|";
    NSString *hVFL1 = @"H:|-space-[view3]-space-|";
    NSString *vVFL = @"V:|-space-[view1(==view3)]-space-[view3]-space-|";
    NSString *vVFL1 = @"V:|-space-[view2(==view3)]-space-[view3]-space-|";
    
    NSDictionary *metircs = @{@"space":@20,@"space1":@30};
    NSDictionary *views = NSDictionaryOfVariableBindings(view1,view2,view3);
    
    NSArray *hconstraint = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:NSLayoutFormatDirectionLeadingToTrailing metrics:metircs views:views];
    NSArray *hconstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:hVFL1 options:NSLayoutFormatDirectionLeadingToTrailing metrics:metircs views:views];
    NSArray *vconstraint = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:NSLayoutFormatDirectionLeadingToTrailing metrics:metircs views:views];
    NSArray *vconstraint1 = [NSLayoutConstraint constraintsWithVisualFormat:vVFL1 options:NSLayoutFormatDirectionLeadingToTrailing metrics:metircs views:views];
    
    //添加约束
    [superView addConstraints:hconstraint];
    [superView addConstraints:hconstraint1];
    [superView addConstraints:vconstraint];
    [superView addConstraints:vconstraint1];
```


这种方式要说的有

##### 1、设置translatesAutoresizingMaskIntoConstraints 为NO
关闭该属性，否则写布局代码等于写个空气
##### 2、Constraints的创建
1. 使用VFL格式化的字符串
   
2. 指定VFL中所有对象的布局属性和方向
   
3. 度量或者指标的字典，字典里面有相关的键值对来控制相关的度量指标，通过key获取；

4. 指定约束的视图：一个或多个。

##### 3、VFL语言的规则
- "H" 表示水平方向，"V"表示垂直方向；
- "|" 表示superview的边界；
- "[]" 表示view，"()"表示尺寸，它们可以多个条件组合，中间使用逗号分隔，举例：[view(>=70, <=100)];
- "-" 表示间隙；
- "@"表示优先级。举例：V:|-50@750-[view(55)]

##### 最后上效果图

![效果](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/1240-20230216141907643.png)

## AutoresizingMask

autoresizingMask是UIView的属性，该属性的作用是调整子视图的上、下、左、右边距及宽高，以保证子视图相对与父视图的位置。autoresizingMask的值对应一个枚举，默认值是UIViewAutoresizingNone；

```
typedef NS_OPTIONS(NSUInteger, UIViewAutoresizing) {
  UIViewAutoresizingNone                = 0,
  UIViewAutoresizingFlexibleLeftMargin  = 1 << 0,
  UIViewAutoresizingFlexibleWidth        = 1 << 1,
  UIViewAutoresizingFlexibleRightMargin  = 1 << 2,
  UIViewAutoresizingFlexibleTopMargin    = 1 << 3,
  UIViewAutoresizingFlexibleHeight      = 1 << 4,
  UIViewAutoresizingFlexibleBottomMargin = 1 << 5
};
```

- UIViewAutoresizingNone：表示不随父视图的改变而改变
- UIViewAutoresizingFlexibleLeftMargin：表示随着父视图的改变自动调整view与父视图的左边距，保证view与父视图的右边距不变；
- UIViewAutoresizingFlexibleWidth：表示随着父视图的改变自动调整view的宽度，保证view与父视图左右边距不变；
- UIViewAutoresizingFlexibleRightMargin：表示随着父视图的改变自动调整view与父视图的右边距，保证view与父视图的左边距不变；
- UIViewAutoresizingFlexibleTopMargin：表示随着父视图的改变自动调整view与父视图的上边距，保证下边距不变；
- UIViewAutoresizingFlexibleHeight：表示随着父视图的改变自动调整view的高度，保证view与父视图的上下边距不变；
- UIViewAutoresizingFlexibleBottomMargin：表示随着父视图的改变自动调整view与父视图的下边距，保证上边距不变；

实际开发中，我们可以根据需要组合使用上述几种枚举值，各个值用‘|’隔开，如下：

```objectivec
self.overView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
```

这句代码的意思是，自动调整self.overView的宽高保证self.overView与父视图的左右边距和上下边距不变；

### translatesAutoresizingMaskIntoConstraints与AutoresizingMask关系

默认情况下，translatesAutoresizingMaskIntoConstraints ＝ true , 此时视图的AutoresizingMask会被转换成对应效果的约束。这样很可能就会和我们手动添加的其它约束有冲突。此属性设置成false时，AutoresizingMask就不会变成约束。也就是说 当前 视图的 AutoresizingMask失效了。

当我们用代码添加视图时,视图的translatesAutoresizingMaskIntoConstraints属性默认为true，可是AutoresizingMask属性默认会被设置成.None。也就是说如果我们不去动AutoresizingMask，那么AutoresizingMask就不会对约束产生影响。

当我们使用interface builder添加视图时，AutoresizingMask虽然会被设置成非.None，但是translatesAutoresizingMaskIntoConstraints默认被设置成了false。所以也不会有冲突。

反而有的视图是靠AutoresizingMask布局的，当我们修改了translatesAutoresizingMaskIntoConstraints后会让视图失去约束，走投无路。例如我自定义转场时就遇到了这样的问题，转场后的视图并不在视图的正中间。

## NSLayoutAnchor

iOS 9 推出的自动布局类，通过设置view的不同锚来实现自动布局约束，内部可以理解成也是NSLayoutConstraint实现。NSLayoutAnchor相对NSLayoutConstraint，代码更加整洁,优雅,易读。

