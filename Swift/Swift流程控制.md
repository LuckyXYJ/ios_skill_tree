## if - else 

与其他编程语言一样，Swift也可以使用**if**，**if - else** ，**if- else if - else **

需要注意的是Swift中条件语句可以省略'()'，但是不能省略 执行语句的'{}'。且if后面只能跟bool值，oc中if后可以跟对象(非空即真)

```
if age >= 18 {
	print("成年人")
}else {
	pring("未成年人")
}
```

## while 

while 又跟其他语言不一样了， 没有**do - while**，可以使用**repeat - while**

while 也是条件语句可以省略'()'，但是不能省略 执行语句的'{}'，Swift取消了自加、自减符号

```
var num = 5;
while num > 0 {
    num -= 1
    print(num)
}

repeat {
    num += 1
    print(num)
}while num < 5

```

## for - in 和区间运算符

Swift取消了自加自减符号"++"、"--"。for (var i = 0, i < 5, i ++)这种语法也不能用了

for - in 可以结合 区间运算符使用 **a...b**，**a..<b**。这里需要注意的是Swift只支持左边小右边打这种情况，且半开区间只有 **a <= 取值 < b**这一种情况

Swift还支持单侧空间**...a**，**a...**，**..<a**。单侧空间不能直接用在**for - in**中，但是可以与数组结合使用.

字符字符串也能使用区间运算符，但是这种不能用在**for - in**中

for - in 也可以使用带间隔的区间值 **stride(from: , through: , by: )**、**stride(from: , to: , by: )**，具体区别看下面代码

区间类型分为ClosedRange，Range，PartialRangeThrough三种

```
let names = ["小王", "老王", "小任", "大任"];
let range1: ClosedRange<Int> = 1...2	//闭区间
let range2: Range<Int> = 1..<2	//半开区间
let range3: PartialRangeThrough<Int> = ...2	//单侧区间
    
for name in names[range1] {
    print(name)
}
    
for name in names[range2] {
    print(name)
}
    
for name in names[range3] {
    print(name)
}

//带字符串的区间运算符
let strRange:ClosedRange = "aa"..."dd"
print(strRange)//aa...dd
print(strRange.contains("Ac")) //false
print(strRange.contains("cc")) //true
print(strRange.contains("cac")) //true
print(strRange.contains("cfffffff")) //true
print(strRange.contains("ddd")) //false

//带间隔区间值
//表示 从 0 开始，间隔为2 ，最大为10，即<=10
for i in stride(from: 0, through: 10, by: 2) {
    print("i = \(i)")
}
//表示 从 0 开始，间隔为2 ，小10，及 < 10
for i in stride(from: 0, to: 10, by: 2) {
    print("i = \(i)")
}
```

## switch

switch又是与众不同的，支持Character、String、元组 类型的switch。各种情况在下面代码中均有提现，且都有备注

- 1、case和default后面不能跟“{}”，直接跟执行语句就行
- 2、case默认不会贯穿，后面不需要写**break**，可以使用**fallthrouh**实现贯穿效果
- 3、但是每个条件下至少有一个执行语句，如果没有任何操作，可写**break**
- 4、switch确保处理完所有情况，可以省略default
- 5、支持复合条件,case后可以跟多个条件，用","隔开
- 6、元组的switch，可以分别匹配元组各个值。
- 7、元组的switch，可以实现值绑定，获取到符合条件的元组内的值，具体看下面代码举例
- 8、元组可以与where结合使用，具体看下面代码举例



```swift
	let a = 3
    
    switch a {
    case 2:
        break//必须有一个执行语句
    case 3:
        print("等于3")//不会贯穿
    default:
        break//必须有一个执行语句
    }
    
    enum Season {case spring; case summer; case autumn; case winter}
    let season = Season.summer
    //确保处理完所有情况，可以省略default
    switch season {
    case Season.spring:
        print("春")
    case .summer:   //可以省略类型Season.summer --> .summer
        print("夏")
    case Season.autumn:
        print("秋")
    case .winter:
        print("冬")
    }
    
    //swift中switch支持啊Character、String类型
    
    let str:String = "abc"
    switch str {
    case "abc":
        print(str)
    default:
        break
    }
    
    //复合条件,case后可以跟多个条件，用","隔开
    switch str {
    case "abc","def":
        print("abc 或者 def")
    default:
        break
    }
    
    //区间匹配
    switch a {
    case 0...3:
        print("0<= a <= 3")
    default:
        break
    }
    
    
    let point = (1, 1)
    
    //元祖匹配
    switch point {
    case (0, 0):
        print("原点")
    case (_, 0):
        print("x轴")
    case (0, _):
        print("y轴")
    case (0..., 0...):
        print("第一象限")
    case (-2...2, -2...2):
        //这句仍然符合条件，但是并不会不打印，可以看出swift中switch不会贯穿，且switch从上到下命中case后就直接跳出
        print("正方形格子")
    default:
        break
    }
    
    //值绑定
    switch point {
    case (let x, 0):
        print("x = \(x)")
    case (0, let y):
        print("y = \(y)")
    case let (x, y):
        print("(x, y) = (\(x), \(y))") }
    
    // 元组值绑定与where结合使用
    switch point {
    case let (x, y) where x == y:   //条件1：当x==y时进入该case
        print("x = y")
    case let (x, y) where x == -y: //条件2：当x==-y时进入该case
        print("x = -y")
    case let (x, y):    //条件3：非前面两种情况，进入该条件语句，相当于default，
        print("(\(x), \(y))")
    default:    //前面三个条件包含所有的情况，这个不需要写了。default后面不能进行值绑定
        print(point)
    }
```

## 标签语句

```swift
outer: for i in 1...4 {
	for k in 1...4 {
    if k == 3 {
      continue outer 
    } if i == 3 { 
      break outer 
    } 
    print("i == \(i), k == \(k)")
	}
}
```

## guard语句

当guard语句的条件为false时，就会执行大括号里面的代码 

当guard语句的条件为true时，就会跳过guard语句 

guard语句特别适合用来“提前退出”

```
guard 条件 else { 
	// do something....
	退出当前作用域 
	// return、break、continue、throw error 
}
```

当使用guard语句进行可选项绑定时，绑定的常量(let)、变量(var)也能在外层作用域中使用

```swift
func login(_ info: [String : String]) {

  guard let username = info["username"] else { 
  	print("请输入用户名") 
  	return 
  } 
  guard let password = info["password"] else {
  	print("请输入密码")
  	return 
  } 
  // if username ....
  // if password ....
  print("用户名：\(username)", "密码：\(password)", "登陆ing")
}
```
