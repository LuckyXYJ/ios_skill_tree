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

## ForEach

```

struct ContentView: View {
    var value = 13
    
    let row: [CalculatorButtonItem] = [
        .digit(1),
        .digit(2),
        .digit(3),
        .op(.plus),
    ]
    
    var body: some View {
        HStack {
            ForEach(row, id: \.self) { item in
                CalculatorButton(title: item.title, size: item.size, backgroundColorName: item.backgroundColorName) {
                    print(item.title)
                }
            }
        }
        
    }
}
```

ForEach 是 SwiftUI 中一个用来列举元素，并生成对应 View collection 的类型。

它接受**满足 Identifiable 协议**的数组。

如果数组元素不满足 Identifiable，我们可以使用ForEach(row, id: \.self) 的方式转换为可以接受的类型

上面代码中的元素类型 CalculatorButtonItem 是不遵守 Identifiable 的。为了解决这个问题，我们可以为 CalculatorButtonItem 加上 Hashable。这样就可以直接用 ForEach(row, id: \.self) 的方式转换为可以接受的类型了

```
extension CalculatorButtonItem: Hashable {}
```

## frame

```
    /// - Parameters:
    ///   - minWidth: The minimum width of the resulting frame.
    ///   - idealWidth: The ideal width of the resulting frame.
    ///   - maxWidth: The maximum width of the resulting frame.
    ///   - minHeight: The minimum height of the resulting frame.
    ///   - idealHeight: The ideal height of the resulting frame.
    ///   - maxHeight: The maximum height of the resulting frame.
    ///   - alignment: The alignment of this view inside the resulting frame.
    ///     Note that most alignment values have no apparent effect when the
    ///     size of the frame happens to match that of this view.
    ///
    /// - Returns: A view with flexible dimensions given by the call's non-`nil`
    ///   parameters.
    @inlinable public func frame(minWidth: CGFloat? = nil, idealWidth: CGFloat? = nil, maxWidth: CGFloat? = nil, minHeight: CGFloat? = nil, idealHeight: CGFloat? = nil, maxHeight: CGFloat? = nil, alignment: Alignment = .center) -> some View
```

### .infinity

将 .infinity 传递给 maxWidth，表示不 对最大宽度进行限制，这种情况下 Text 会尽可能占据它的容器的宽度，变为全屏宽

