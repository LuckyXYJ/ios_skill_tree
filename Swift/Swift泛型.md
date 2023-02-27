## 泛型

泛型可以将类型参数化，提高代码复用率，减少代码量

```swift
func swapValues<T>(_ a: inout T, _ b: inout T) { 
  (a, b) = (b, a) 
}

// 泛型函数赋值给变量
func test<T1, T2>(_ t1: T1, _ t2: T2) {} 
var fn: (Int, Double) -> () = test
```

使用泛型实现栈

```swift
class Stack<E> { 
  var elements = [E]() 
  func push(_ element: E) { elements.append(element) } 
  func pop() -> E { elements.removeLast() } 
  func top() -> E { elements.last! } 
  func size() -> Int { elements.count } 
}	

// 泛型栈继承
class SubStack<E> : Stack<E> {}


struct Stack<E> { 
  var elements = [E]() 
  mutating func push(_ element: E) { elements.append(element) } 
  mutating func pop() -> E { elements.removeLast() } 
  func top() -> E { elements.last! }
  func size() -> Int { elements.count } 
}
```

## 关联类型（Associated Type）

关联类型的作用：给协议中用到的类型定义一个占位名称 

协议中可以拥有多个关联类型

```swift
protocol Stackable { 
  associatedtype Element // 关联类型 
  mutating func push(_ element: Element) 
  mutating func pop() -> Element 
  func top() -> Element 
  func size() -> Int 
}


class Stack<E> : Stackable {
	// typealias Element = E 
  var elements = [E]() 
  func push(_ element: E) { elements.append(element) } 
  func pop() -> E { elements.removeLast() } 
  func top() -> E { elements.last! } 
  func size() -> Int { elements.count }
}


class StringStack : Stackable {
  // 给关联类型设定真实类型 
  // typealias Element = String 
  var elements = [String]() 
  func push(_ element: String) { elements.append(element) } 
  func pop() -> String { elements.removeLast() } 
  func top() -> String { elements.last! } 
  func size() -> Int { elements.count }
}
var ss = StringStack() 
ss.push("Jack") 
ss.push("Rose")

```



## 类型约束

```swift
protocol Runnable { } 
class Person { } 
func swapValues<T : Person & Runnable>(_ a: inout T, _ b: inout T) { 
	(a, b) = (b, a) 
}

protocol Stackable { 
  associatedtype Element: Equatable
} 
class Stack<E : Equatable> : Stackable { 
  typealias Element = E 
}

func equal<S1: Stackable, S2: Stackable>(_ s1: S1, _ s2: S2) -> Bool where S1.Element == S2.Element, S1.Element : Hashable { 
  return false 
}

var stack1 = Stack<Int>() 
var stack2 = Stack<String>() 
// error: requires the types 'Int' and 'String' be equivalent 
equal(stack1, stack2)
```

## 协议类型作为返回值

```swift
func get<T : Runnable>(_ type: Int) -> T { 
  if type == 0 { 
    return Person() as! T 
  } 
  return Car() as! T 
} 
var r1: Person = get(0) 
var r2: Car = get(1)
```

## 不透明类型（Opaque Type）

使用some关键字声明一个不透明类型

some限制只能返回一种类型

```swift
func get(_ type: Int) -> some Runnable { 
	Car() 
} 
var r1 = get(0)
var r2 = get(1)
```

![some](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/some.png)

## some

some除了用在返回值类型上，一般还可以用在属性类型上

```swift
protocol Runnable { associatedtype Speed } 
class Dog : Runnable { typealias Speed = Double } 
class Person {
	var pet: some Runnable {
		return Dog()
  } 
}
```

