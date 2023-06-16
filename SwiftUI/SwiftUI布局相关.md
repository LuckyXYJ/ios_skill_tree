## GeometryReader

在 SwiftUI 中，`GeometryReader` 是一个视图容器，可以用来获取可用空间的大小和位置信息，进而调整视图的大小和位置。你可以在 `GeometryReader` 中添加子视图，并利用 `GeometryProxy` 对象来修改子视图的位置和大小。例如：

```
GeometryReader { geometry in
    // 获取可用空间大小
    let availableSpace = geometry.size
    
    // 使用 availableSpace 调整子视图
    Text("Hello, World!")
        .foregroundColor(.white)
        .frame(width: availableSpace.width, height: availableSpace.height)
        .background(Color.blue)
}
```

PreferenceKey

`PreferenceKey` 是一个协议，可以用来定义如何收集和组合视图的信息。当你需要将多个视图的位置和大小信息结合起来进行布局时，可以使用 `PreferenceKey`。具体实现步骤如下：

1. 创建一个自定义的 `PreferenceKey` 类型，指定视图信息的类型。

```
struct MyPreferenceKey: PreferenceKey {
    static var defaultValue: [CGRect] = []

    static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}
```

2. 在您的视图中，使用 `.background(_:)` 修饰符来应用自定义 `PreferenceKey` 并让视图汇报其信息。

```
Rectangle()
    .fill(Color.red)
    .frame(width: 100, height: 100)
    .padding()
    .background(
        GeometryReader { proxy in
            Color.clear
                .preference(key: MyPreferenceKey.self, value: [proxy.frame(in: .global)])
        }
    )
```

3. 最后，可以使用 `onPreferenceChange(_:_:)` 修饰符来监听视图汇报的信息，并对视图进行布局。

```
VStack {
    Rectangle()
        .fill(Color.green)
        .frame(width: 200, height: 200)
        .padding()
    
    // 使用收集到的信息布局其它视图
    Rectangle()
        .fill(Color.yellow)
        .frame(width: 50, height: 50)
        .overlay(
            GeometryReader { proxy in
                Color.clear
                    .preference(key: MyPreferenceKey.self, value: [proxy.frame(in: .global)])
            }
        )
        .onPreferenceChange(MyPreferenceKey.self) { preferences in
            // 对视图进行布局
            print(preferences)
        }
}
```

以上是 `PreferenceKey` 的简单示例，你可以根据需要对代码进行修改。注意，`PreferenceKey` 的流程会略显繁琐，但这种方法常用于实现动态 UI 布局和一些高级动画效果。

## Divider

在 SwiftUI 中，您可以使用 `Divider()` 添加分隔线。`Divider()` 默认情况下会创建一条水平分隔线，其颜色为系统默认的分割线颜色，但您可以通过使用 `.background()` 修改其背景色。

下面是一个简单的示例，将视图分成两个部分，并在它们之间添加一条分隔线：

```swift
VStack {
    Text("上部分")
    Divider()
    Text("下部分")
}
```

注意，`Divider()` 并不接收任何参数，你只需要在视图中放置它即可。

## Spacer

在 SwiftUI 中，您可以使用 `Spacer()` 视图来在布局中创建一个可伸缩的空间。`Spacer()` 会自动根据剩余的可用空间填充整个父容器。

例如，如果您希望将一个视图沿着另一个视图的顶部和底部对齐，并使它们之间的空间平均分配，则可以使用 `Spacer()`。示例代码如下：

```swift
VStack {
    Text("顶部视图")
    Spacer()
    Text("底部视图")
}
```

在这个示例中，`Spacer()` 视图会自动占用“顶部视图”和“底部视图”之间的所有可用空间。结果是，“顶部视图”和“底部视图”之间将分布相等的间距，并且与容器的顶部和底部对齐。

值得注意的是，`Spacer()` 视图不会自动缩小，只有当可用空间增大时，它才会自动扩展和填充整个容器。如果您希望视图在最小空间中自动缩小，请在父容器中使用 `Spacer(minLength: CGFloat)`。其中 `minLength` 是 `Spacer` 允许缩小时的最小长度。

## frame

在 SwiftUI 中，您可以为视图设置不同类型的 `frame`。例如，您可以把视图大小设置为固定值，也可以设置为相对于父容器的百分比值或者按照宽高比例。

下面是一些设置视图大小的示例：

**1. 固定大小**

您可以使用 `frame(width:height:)` 方法来设置视图的固定宽度和高度，例如：

```swift
Text("Hello, World!")
    .frame(width: 100, height: 50)
```

在这个示例中，`Text` 视图的宽度和高度都被设置为固定值。

**2. 相对大小**

如果您希望视图的大小相对于父容器来设置，可以使用 `frame(maxWidth:maxHeight:)` 方法。例如，以下代码将使视图的最大宽度为父容器的宽度的 50%：

```swift
Text("Hello, World!")
    .frame(maxWidth: .infinity, maxHeight: .infinity)
```

**3. 百分比大小**

您还可以使用 `frame(width:height:alignment)` 方法并使用 `.relativeTo` `ViewDimensions` 来设置视图的大小百分比。例如：

```swift
Text("Hello, World!")
    .frame(width: 0.5, height: 0.5, alignment: .center)
```

在这个示例中，`Text` 视图被设置为父视图宽度和高度的 50%。

**4. 宽高比例**

如果您想按照固定的宽高比例来设置视图的大小，可以使用 `frame(width:height:alignment:)` 方法并传入一个 `AspectRatio` 枚举值，例如：

```swift
Text("Hello, World!")
    .frame(width: 200, height: 0, alignment: .topLeading)
    .aspectRatio(1.5, contentMode: .fit)
```

在这个示例中，`Text` 视图的宽度被设置为 200，高度被设置为 0（自动设置），而且使用 `aspectRatio()` 方法指定了 1.5 的宽高比例，并设置了 `contentMode` 为 `.fit`。这样，视图的大小将动态计算以满足指定的宽高比例，并在适应其内容时自动缩放。

这些技术可以组合使用，以动态地创建适应您的布局和设计需求的视图大小和形状。