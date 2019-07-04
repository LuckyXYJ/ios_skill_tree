## 枚举

### 枚举的定义

```
    // 枚举的定义
    enum Season {case spring; case summer; case autumn; case winter}
    
    enum Season1 {
        case spring
        case summer
        case autumn
        case winter
    }
    
    enum Seaso2 { case spring, summer, autumn, winter }
    
```

### 枚举关联值

有时将枚举的成员值跟其他类型的值关联存储在一起，会非常有用

```swift
    //关联值
    enum Date {
        case digit(year: Int, month: Int, day: Int)
        case string(String)
    }
    
    var date = Date.digit(year: 2021, month: 01, day: 18);
    date = .string("20210120")
    
    switch date {
    case let .digit(year: a, month: b, day: c):
        print(a, "-", b, "-", c)
    case let .string(str):
        print(str)
    default:
        print("c")
    }
    
    switch date {
    case .digit(year: let a, month: 02, day: let c):
        print(a, "-", "01", "-", c)
    case .string("20210118"):
        print("20210118")
    case .string("20210119"):
        print("20210119")
    default:
        print("other");
    }
```

### 枚举原始值

枚举成员可以使用相同类型的默认值预先对应，这个默认值叫做：原始值。**原始值不占用枚举类型的内存**

如果枚举的原始值类型是Int、String，Swift会自动分配原始值

```
    //原始值
    enum Season3:String {
        case spring = "春天"
        case summer = "夏天"
        case autumn = "秋天"
        case winter = "冬天"
    }
    
    var season = Season3.winter;
    season = .autumn
    print(season) //autumn
    print(season.rawValue) //秋天
    print(Season3.spring.rawValue) //春天
    
    enum Season4 : Int { case spring, summer, autumn, winter }//默认0123
    enum Season5 : Int { case spring = 1, summer, autumn = 5, winter }//默认1256
    
    
```

### 递归枚举 indirect

递归枚举需要加上indirect 关键字

```
	 //递归枚举
    indirect enum Count {
        case num(Int)
        case sum(Count, Count)
        case difference(Count, Count)
    }
    
    enum Count2 {
        case num(Int)
        indirect case sum(Count2, Count2)
        indirect case difference(Count2, Count2)
    }
```

### 占用内存

```swift
enum Password { 
  case number(Int, Int, Int, Int) 
  case other 
}
MemoryLayout<Password>.stride // 40, 分配占用的空间大小 
MemoryLayout<Password>.size // 33, 实际用到的空间大小 
MemoryLayout<Password>.alignment // 8, 对齐参数

var pwd = Password.number(9, 8, 6, 4) 
pwd = .other 
MemoryLayout.stride(ofValue: pwd) // 40
MemoryLayout.size(ofValue: pwd) // 33 
MemoryLayout.alignment(ofValue: pwd) // 8
```

## 结构体

### 结构体定义

```
	struct Date {
        var year: Int = 2021
        var month: Int
        var day: Int
  }
  var date = Date(year: 2019, month: 6, day: 23)
  //传入所有成员值，用以初始化所有成员（存储属性，Stored Property）
```

### 构造方法

所有的结构体都有一个编译器自动生成的初始化器（initializer，初始化方法、构造器、构造方法）

编译器会根据情况，可能会为结构体生成多个初始化器，宗旨是：**保证所有成员都有初始值**

一旦在定义结构体时自定义了初始化器，编译器就不会再帮它自动生成其他初始化器

### 内存结构

```swift
struct Point { 
	var x: Int = 0 
  var y: Int = 0 
  var origin: Bool = false 
} 
print(MemoryLayout<Point>.size) // 17 
print(MemoryLayout<Point>.stride) // 24 
print(MemoryLayout<Point>.alignment) // 8
```

## 类

### 类的定义

```
	 class Student {
        var age: Int = 18
        var name: String = "xiaoming"
    }
```

### 类的初始化

类的定义和结构体类似，但编译器并没有为类自动生成可以传入成员值的初始化器

如果类的所有成员都在定义的时候指定了初始值，编译器会为类生成无参的初始化器

```swift
class Point { 
  var x: Int = 10 
  var y: Int = 20 
}
let p1 = Point()
```

## struct 与 class对比

### struct是值类型，class是引用类型。

值类型的变量直接包含它们的数据，对于值类型都有它们自己的数据副本，因此对一个变量操作不可能影响另一个变量。

引用类型的变量存储对他们的数据引用，因此后者称为对象，因此对一个变量操作可能影响另一个变量所引用的对象。

### 二者的本质区别：

struct是深拷贝，值拷贝，拷贝的是内容；为了提升性能，String、Array、Dictionary、Set采取了Copy On Write的技术。仅当有“写”操作时，才会真正执行拷贝操作。不需要修改的，尽量定义成let

class是浅拷贝，引用拷贝，拷贝的是指针。在Mac、iOS中的malloc函数分配的内存大小总是16的倍数。通过class_getInstanceSize可以得知：类的对象至少需要占用多少内存

```swift
class Point {
  var x = 11
  var test = true
  var y = 22
} 
var p = Point() 
class_getInstanceSize(type(of: p)) // 40 class_getInstanceSize(Point.self)
```

### property的初始化不同：

class 在初始化时不能直接把 property 放在 默认的constructor 的参数里，而是需要自己创建一个带参数的constructor；

而struct可以，把属性放在默认的constructor 的参数里。

### immutable变量：

swift的可变内容和不可变内容用var和let来甄别，如果初始为let的变量再去修改会发生编译错误。

struct遵循这一特性；class不存在这样的问题。

### mutating function： 

struct 和 class 的差別是 struct 的 function 要去改变 property 的值的时候要加上 mutating，而 class 不用。

### 继承： 

struct不可以继承，class可以继承。

struct比class更轻量：struct分配在栈中，class分配在堆中。

## 枚举、结构体、类都可以定义方法

```swift
class Size { 
  var width = 10 
  var height = 10 
  func show() { 
    print("width=\(width), height=\(height)") 
  } 
} 
let s = Size() 
s.show() // width=10, height=10


struct Point { 
  var x = 10 
  var y = 10 
  func show() { 
    print("x=\(x), y=\(y)") 
  } 
}
let p = Point() 
p.show() // x=10, y=10


enum PokerFace : Character { 
  case spades = "♠", hearts = "♥", diamonds = "♦", clubs = "♣" 
  func show() { 
    print("face is \(rawValue)") 
  } 
}
let pf = PokerFace.hearts 
pf.show() // face is ♥

```

### 方法占用对象的内存么？ 

不占用 

方法的本质就是函数 

方法、函数都存放在代码段

## 下标

使用subscript可以给任意类型（枚举、结构体、类）增加下标功能，有些地方也翻译为：下标脚本 

subscript的语法类似于实例方法、计算属性，本质就是方法（函数）

```swift
// subscript中定义的返回值类型决定了 get方法的返回值类型 pset方法中newValue的类型

//subscript可以接受多个参数，并且类型任意

class Point {
	var p = Point()
  var x = 0.0, y = 0.0
  subscript(index: Int) -> Double { 
    set { 
      if index == 0 { 
        x = newValue 
      } else if index == 1 { 
        y = newValue 
      } 
    } 
    get { 
      if index == 0 { 
        return x 
      } else if index == 1 { 
        return y 
      } 
      return 0 
    }
  }
}

p[0] = 11.1
p[1] = 22.2

print(p.x) // 11.1 
print(p.y) // 22.2 
print(p[0]) // 11.1 
print(p[1]) // 22.2

```



subscript可以没有set方法，但必须要有get方法 

如果只有get方法，可以省略get

```swift
class Point {
	var x = 0.0, y = 0.0
  subscript(index: Int) -> Double { 
    get { 
      if index == 0 { 
        return x 
      } else if index == 1 { 
        return y 
      } 
      return 0
    }
  }
}


class Point {
  var x = 0.0, y = 0.0
  subscript(index: Int) -> Double { 
    if index == 0 { 
      return x 
    } else if index == 1 { 
      return y 
    } 
    return 0
  }
}
```

下标可以设置参数标签

```swift
class Point {
	var x = 0.0, y = 0.0 
  subscript(index i: Int) -> Double { 
    if i == 0 { 
      return x 
    } else if i == 1 { 
      return y 
    } 
    return 0
  }
}

var p = Point() 
p.y = 22.2 
print(p[index: 1]) // 22.2
```

下标可以是类型方法

```swift
class Sum { 
  static subscript(v1: Int, v2: Int) -> Int { 
    return v1 + v2 
  } 
} 

print(Sum[10, 20]) // 30

```

结构体、类作为返回值对比

```swift
class Point { 
	var x = 0, y = 0 
} 
class PointManager { 
  var point = Point() 
  subscript(index: Int) -> Point { 
    get { point } 
  }
}


struct Point { 
  var x = 0, y = 0 
} 
class PointManager { 
  var point = Point() 
  subscript(index: Int) -> Point { 
    set { point = newValue } 
    get { point } 
  }
}
```

接收多个参数的下标

```swift
class Grid {
  var data = [ 
    [0, 1, 2], 
    [3, 4, 5], 
    [6, 7, 8] 
  ] 
  subscript(row: Int, column: Int) -> Int { 
    set { 
      guard row >= 0 && row < 3 && column >= 0 && column < 3 else { 
        return 
      }
      data[row][column] = newValue
    } get { 
      guard row >= 0 && row < 3 && column >= 0 && column < 3 else { 
        return 0 
      } 
      return data[row][column]
    }
  }
}

var grid = Grid()

grid[0, 1] = 77
grid[1, 2] = 88
grid[2, 0] = 99
print(grid.data)
```

