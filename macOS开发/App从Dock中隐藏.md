## App从Dock中隐藏

如果您想要将您的 macOS 应用程序从 Dock 中隐藏，可以通过程序编码方式或应用程序属性设置来实现。以下是两种方法：

1.程序编码方式

您可以在应用程序启动时使用以下代码将应用程序从 Dock 中隐藏：

```
NSApplication.shared().setActivationPolicy(.accessory)
```

2.应用程序属性设置

您可以在应用程序的 Info.plist 文件中添加以下代码，来设置应用程序启动时是否在 Dock 中显示：

```
<key>LSUIElement</key>
<true/>
```

如果将值设置为 true，则应用程序启动时将不会出现在 Dock 中；如果将值设置为 false，则应用程序将在 Dock 中显示。