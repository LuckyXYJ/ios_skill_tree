## MARK、TODO、FIXME

// MARK: 类似于OC中的 #pragma mark  

// MARK: - 类似于OC中的 #pragma mark 

// TODO: 用于标记未完成的任务 

// FIXME: 用于标记待修复的问题

## 条件编译

```swift
// 操作系统：macOS\iOS\tvOS\watchOS\Linux\Android\Windows\FreeBSD 
#if os(macOS) || os(iOS) 
// CPU架构：i386\x86_64\arm\arm64 
#elseif arch(x86_64) || arch(arm64) 
// swift版本 
#elseif swift(<5) && swift(>=3) 
// 模拟器 
#elseif targetEnvironment(simulator) 
// 可以导入某模块 
#elseif canImport(Foundation) 
#else
#endif
```

![swift条件编译设置](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/swift%E6%9D%A1%E4%BB%B6%E7%BC%96%E8%AF%91%E8%AE%BE%E7%BD%AE.png)

```swift
// debug模式 
#if DEBUG 
// release模式 
#else 
#endif

#if TEST 
print("test") 
#endif

#if OTHER 
print("other") 
#endif
```

## 打印

```swift
func log<T>(_ msg: T, file: NSString = #file, line: Int = #line, fn: String = #function) { 
  #if DEBUG 
  let prefix = "\(file.lastPathComponent)_\(line)_\(fn):" 
  print(prefix, msg) 
  #endif
}
```

## 系统版本检测

```swift
if #available(iOS 10, macOS 10.12, *) { 
  // 对于iOS平台，只在iOS10及以上版本执行 
  // 对于macOS平台，只在macOS 10.12及以上版本执行 
  // 最后的*表示在其他所有平台都执行 
}
```

## API可用性说明

```swift
@available(iOS 10, macOS 10.15, *) 
class Person {}

struct Student {
  @available(*, unavailable, renamed: "study") 
  func study_() {} 
  func study() {}
  @available(iOS, deprecated: 11) 
  @available(macOS, deprecated: 10.12) 
  func run() {}
}
```

## iOS程序的入口

在AppDelegate上面默认有个@UIApplicationMain标记，这表示 :编译器自动生成入口代码（main函数代码），自动设置AppDelegate为APP的代理

也可以删掉@UIApplicationMain，自定义入口代码：新建一个main.swift文件

![main](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/main.png)

