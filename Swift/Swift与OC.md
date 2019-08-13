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

## Swift调用OC

新建1个桥接头文件，文件名格式默认为：{targetName}-Bridging-Header.h

在 {targetName}-Bridging-Header.h 文件中 #import OC需要暴露给Swift的内容

## Swift调用OC – @_silgen_name

如果C语言暴露给Swift的函数名跟Swift中的其他函数名冲突了 

可以在Swift中使用 @_silgen_name 修改C函数名

```swift
// C语言 int sum(int a, int b) { return a + b; }

// Swift 
@_silgen_name("sum") func swift_sum(_ v1: Int32, _ v2: Int32) -> Int32 
print(swift_sum(10, 20)) // 30 
print(sum(10, 20)) // 30
```

## OC调用Swift

Xcode已经默认生成一个用于OC调用Swift的头文件，文件名格式是： {targetName}-Swift.h

Swift暴露给OC的类最终继承自NSObject

使用@objc修饰需要暴露给OC的成员

使用@objcMembers修饰类 :1、代表默认所有成员都会暴露给OC（包括扩展中定义的成员） 2、最终是否成功暴露，还需要考虑成员自身的访问级别

Xcode会根据Swift代码生成对应的OC声明，写入 {targetName}-Swift.h 文件

可以通过 @objc 重命名Swift暴露给OC的符号名（类名、属性名、函数名等）

Swift

```swift
@objc(MYCar) 
@objcMembers class Car: NSObject {
  var price: Double 
  @objc(name) 
  var band: String 
  init(price: Double, band: String) {
    self.price = price
    self.band = band 
  } 
  @objc(drive) 
  func run() { print(price, band, "run") } 
  static func run() { print("Car run") }
} 
extension Car {
  @objc(exec:v2:)
  func test() { 
    print(price, band, "test") 
  } 
}

```

OC

```objective-c
MYCar *c = [[MYCar alloc] initWithPrice:10.5 band:@"BMW"];
c.name = @"Bently";
c.price = 100.00;
[c drive]; // 100.00 Bently run
[c exec:10 v2:20]; // 100.00 Bently test 
[MYCar run]; // Car run
  
```

