## 定义一行文字

```
var body: some View {
        Text("Hello, Word! ")
            .font(.title)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .background(.orange)
            .padding(16)
            .background(.red)
    }
```

显示结果

![image-20230521201647748](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230521201647748.png)

## swiftUI 预定义字体

SwiftUI 中预定义很多字体，[Using-system-fonts](https://developer.apple.com/design/human-interface-guidelines/typography#Using-system-fonts)，如

- title
- title2
- ...

使用预定义字体好处：

适配Dynamic type。自动根据用户字体设置进行适配

## 修饰符 modifier

分为两种

- 原地modifier
- 封装modifier

区别

1. 原地modifier ，定义在具体类型上，返回同样类型；封装modifier，将原view进行包装，返回新的view；
2. 原地modifier一般对顺序不敏感，对布局不关心。类似于对view本身属性的修改。封装modifier的顺序很重要



