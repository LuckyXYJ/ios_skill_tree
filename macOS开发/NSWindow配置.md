## NSWindow.StyleMask

`NSWindow.StyleMask`是一个枚举类型，用于指定`NSWindow`窗口的风格。它包含许多不同的选项，以控制窗口的行为和外观。

你可以使用`NSWindow.StyleMask`属性来设置窗口的风格。例如，下面的代码创建了一个没有标题栏，并且可以调整窗口大小的窗口：

```swift
let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false)
window.titleVisibility = .hidden
window.makeKeyAndOrderFront(nil)
```

在上面的代码中，我们使用了一些 StyleMask 选项：

- .titled：窗口带有标题栏和关闭按钮，可以被拖动移动。
- .closable：窗口带有关闭按钮。
- .resizable：窗口可被缩放，带有缩放按钮。
- .miniaturizable：窗口可以被最小化，带有最小化按钮。
- .fullSizeContentView：在标题栏中添加一个隐藏的全屏按钮。
- .unifiedTitleAndToolbar：窗口的标题栏和工具栏融合在一起。
- .texturedBackground：窗口使用纹理背景。
- .hudWindow：HUD样式的窗口
- .utilityWindow：窗口被设计成作为一个辅助浮动面板出现在主窗口上，带有控制面板。
- .borderless：没有标题栏和边框的窗口。
- .fullScreen：全屏窗口
- .docModal：当前窗口是一个Modal Dialog（模态对话框）。

你可以根据你的需求使用不同的选项来创建不同样式的窗口。还有其他风格选项，例如 `.bordered` 分别`.fullScreen` 。

## NSWindow.BackingStoreType

`NSWindow.BackingStoreType`是一个枚举类型，用于指定窗口使用的绘图缓冲类型。它指定了在窗口对象中如何维护应用程序绘图的缓存区域。

你可以使用`NSWindow.BackingStoreType`属性来设置窗口的绘图缓存类型。例如，下面的代码创建了一个使用`NSBackingStoreType.buffered`缓冲类型的窗口：

```swift
let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
    styleMask: [.titled, .closable, .miniaturizable, .resizable],
    backing: .buffered,
    defer: false)
window.makeKeyAndOrderFront(nil)
```

在上面的代码中，我们将`backing`参数设置为`.buffered`。这将导致窗口对象使用缓存来优化渲染和滚动性能。

除了`.buffered`，还有两种其他的缓存类型可用：

- `.retained`：此选项指定使用一个保留的缓存。这会使绘图操作非常快，但可能会占用大量的内存。这是在需要高性能的图形应用程序中推荐使用的选项，例如游戏或音视频编辑器。
- `.nonretained`：此选项指定使用非保留的缓存区。这意味着窗口对象不会保留其绘图缓存，而是在需要时再次创建这些缓存区。这可以节省内存，但可能会影响性能。

## NSWindow.Level

NSWindow.Level是一个枚举类型，用于表示窗口的层级。它定义了许多不同的窗口层级，应用程序可以根据需要将窗口放置在不同的层级上。例如，NSWindow.Level.normal表示普通级别的窗口，NSWindow.Level.popUpMenu表示弹出菜单，NSWindow.Level.modalPanel表示模态面板等等。

在Mac开发中，NSWindow.Level通常用于设置窗口的行为，例如将窗口总是置于顶部（NSWindow.Level.floating），禁用窗口交互（NSWindow.Level.screenSaver），在其他窗口之上显示模态对话框（NSWindow.Level.modalPanel）。通过使用不同的层级，开发人员可以更好地控制窗口的行为和状态，从而提高用户体验。

## 显示隐藏

`makeKeyAndOrderFront` 方法显示的窗口

`orderOut` 方法。这个方法会将窗口从屏幕上移除，但并不会销毁窗口，所以稍后你可以调用窗口的 `makeKeyAndOrderFront` 方法再将其显示在屏幕上。