## 数据类型

### Swift分为值类型和引用类型：

1、值类型分为枚举enum 和 结构体 struct

- 枚举：Optional
- 结构体：Bool、Int、Float、Double、Character、String、Array、Dictionary、Set

2、引用类型 ：class

### Swift 与OC对比

1、其中字符串，数组，字典，集合在OC中为引用类型，在Swift中为值类型

2、Swift是强类型语言，所有的变量必须先声明，后使用；指定类型的变量只能接收类型与之匹配的值

3、Swift中Bool只有true和false。而OC中非0即为真

4、新增可选类型Optional

## 常量 与 变量

常量一旦设定，在程序运行时就无法修改，常量可以是任何的数据类型，用let修饰

变量指定类型，类型决定占用内存大小，变量的值可以修改，用var修饰

```
var age1 = 12
let age2 = 26
age1 = age1 + 1
age2 = age2 + 1 //这里对常量进行修改，会报错
```

常量或者变量在初始化的时候可加上类型标注

``var constantName:<data type> = <optional initial value>``

## 可选类型

Swift 的可选（Optional）类型，表示值可以为空。最初使用Swift的时候被这个可选类型很难受，后端接口返回的字符串数据解析后是可选类型字符串，显示在页面上成Optional("xxxx")的样子，值为空的时候使用强制解包'!'又会发生运行时错误

```
var age: Int?
var age: Optional<Int>

```

### 解包方式

可选类型在使用的时候需要进行解包，解包方式有以下几种：

1、强制解包

```
if age != nil {
	print(age!)//只有确定值非空的时候才能使用强制解包
}
```

2、可选值绑定 与 自动解包

可以使用可选项绑定来判断可选项是否包含值

如果包含就自动解包，把值赋给一个临时的常量(let)或者变量(var)，并返回true，否则返回false

```
var str:String!
str = "Hello, Swift!"
if let str1 = str {
   print(str1)
}else{
   print("myString 值为 nil")
}
```

3、空合并运算符 '??' ,这个用起来比较方便
`` a ?? b ``

- a是可选项
- b可以是可选项，也可以是非可选项
- a和b的存储类型必须相同
- 如果a不为nil，返回a
- 如果a为nil，返回b
- 如果b不为可选项，返回a时会自动解包

下面代码可以做到str为空时不显示，str非空的时候显示解包后的值

``leb.text = optionStr ?? ""``

4、隐式解包

在某些情况下，可选项一旦被设定值之后，就会一直拥有值 

在这种情况下，可以去掉检查，也不必每次访问的时候都进行解包，因为它能确定每次访问的时候都有值 

可以在类型后面加个感叹号 ! 定义一个隐式解包的可选项

```
let num1: Int! = 10 
let num2: Int = num1 
if num1 != nil {
	print(num1 + 6) // 16 
} 
if let num3 = num1 {
	print(num3) 
}
```

### 多重可选项

```
var num1: Int? = 10 
var num2: Int?? = num1 
var num3: Int?? = 10

print(num2 == num3) // true		
```



```
var num1: Int? = nil 
var num2: Int?? = num1 
var num3: Int?? = nil

print(num2 == num3) // false
(num2 ?? 1) ?? 2 // 2 
(num3 ?? 1) ?? 2 // 1
```

### 可选链

多个?可以链接在一起，如果链中任何一个节点是nil，那么整个链就会调用失败

如果可选项为nil，调用方法、下标、属性失败，结果为nil 

如果可选项不为nil，调用方法、下标、属性成功，结果会被包装成可选项

如果结果本来就是可选项，不会进行再次包装

### 可选项本质

可选项的本质是enum类型

```swift
public enum Optional<Wrapped> : ExpressibleByNilLiteral { 
  case none 
  case some(Wrapped) 
  public init(_ some: Wrapped) 
}
```

## 元组

```
let httpError = (404, "Not Fount")
print("status code is \(httpError.0)")

// let (code, message) = httpError
let (code, _) = httpError
print("status code is \(code)")

// 带默认键值
let httpError = (code:404, message:"Not Fount")
print("status code is \(httpError.code)")
```

## 字面量

常见字面量类型

- public typealias IntegerLiteralType = Int 
- public typealias FloatLiteralType = Double 
- public typealias BooleanLiteralType = Bool 
- public typealias StringLiteralType = String

```
// 可以通过typealias修改字面量的默认类型 
typealias FloatLiteralType = Float 
typealias IntegerLiteralType = UInt8 
var age = 10 // UInt8 
var height = 1.68 // Float
```

Swift自带类型之所以能够通过字面量初始化，是因为它们遵守了对应的协议

- Bool : ExpressibleByBooleanLiteral
- Int : ExpressibleByIntegerLiteral 
- Float、Double : ExpressibleByIntegerLiteral、ExpressibleByFloatLiteral
- Dictionary : ExpressibleByDictionaryLiteral  
- String : ExpressibleByStringLiteral
- Array、Set : ExpressibleByArrayLiteral 
- Optional : ExpressibleByNilLiteral

字面量协议应用

```swift
class Student : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, CustomStringConvertible {
  var name: String = "" 
  var score: Double = 0 
  required init(floatLiteral value: Double) { self.score = value } 
  required init(integerLiteral value: Int) { self.score = Double(value) } 
  required init(stringLiteral value: String) { self.name = value } 
  required init(unicodeScalarLiteral value: String) { self.name = value } 
  required init(extendedGraphemeClusterLiteral value: String) { self.name = value } 
  var description: String { "name=\(name),score=\(score)" }
} 
var stu: Student = 90 
print(stu) // name=,score=90.0 
stu = 98.5 
print(stu) // name=,score=98.5 
stu = "Jack" print(stu) // name=Jack,score=0.0
```

