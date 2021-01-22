## 面向协议编程

（Protocol Oriented Programming，简称POP）

优先考虑创建协议，而不是父类（基类）

优先考虑值类型（struct、enum），而不是引用类型（class）

巧用协议的扩展功能

不要为了面向协议而使用协议

## 面向对象的编程语言

（Object Oriented Programming，简称OOP）

OOP的三大特性：封装、继承、多态

继承的经典使用场合 ： 当多个类（比如A、B、C类）具有很多共性时，可以将这些共性抽取到一个父类中（比如D类），最后A、B、C类继承D类

OOP存在的问题：如何将 两个类的 的公共方法 抽取出来？

- 将公共方法放到另一个对象A中，然后两个类拥有对象A属性。 多了一些额外的依赖关系
- 将公共方法增加到公共父类的分类中。父类会越来越臃肿，而且会影响它的其他所有子类
- 多继承。会增加程序设计复杂度，产生菱形继承等问题，需要开发者额外解决

## 利用协议实现前缀效果

```swift
// 效果
var string = "123fdsf434" 
print(string.mj.numberCount())

// 
struct MJ<Base> { 
  let base: Base 
  init(_ base: Base) { self.base = base } 
}
protocol MJCompatible {
  
} 
extension MJCompatible{
	static var mj: MJ<Self>.Type { 
    get { MJ<Self>.self } 
    set {} 
  } 
  var mj: MJ<Self> {
    get { MJ(self) }
    set {} 
  }
}

extension String: MJCompatible {} 
extension MJ where Base == String {
  func numberCount() -> Int { 
    var count = 0 
    for c in base where ("0"..."9").contains(c) { 
      count += 1 
    } 
    return count 
  }
}
```

### Base:类

```swift
class Person {} 
class Student: Person {}
extension Person: MJCompatible {} 
extension MJ where Base: Person {
	func run() {}
	static func test() {} 
}

Person.mj.test() 
Student.mj.test()

let p = Person() 
p.mj.run()
let s = Student() 
s.mj.run()
```

### Base: 协议

```swift
var s1: String = "123fdsf434" 
var s2: NSString = "123fdsf434" 
var s3: NSMutableString = "123fdsf434" 
print(s1.mj.numberCount()) 
print(s2.mj.numberCount()) 
print(s3.mj.numberCount())

extension String: MJCompatible {} 
extension NSString: MJCompatible {} 
extension MJ where Base: ExpressibleByStringLiteral {
  func numberCount() -> Int { 
    let string = base as! String 
    var count = 0 
    for c in string where ("0"..."9").contains(c) { 
      count += 1 
    } 
    return count
  }
}
```

## 利用协议实现类型判断

```swift
func isArray(_ value: Any) -> Bool { value is [Any] } 
isArray( [1, 2] ) 
isArray( ["1", 2] ) 
isArray( NSArray() ) 
isArray( NSMutableArray() )

protocol ArrayType {} 
extension Array: ArrayType {} 
extension NSArray: ArrayType {} 
func isArrayType(_ type: Any.Type) -> Bool { type is ArrayType.Type } 
isArrayType([Int].self) 
isArrayType([Any].self) 
isArrayType(NSArray.self) 
isArrayType(NSMutableArray.self)
```

