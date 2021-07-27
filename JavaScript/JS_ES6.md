## 字面量增强写法

```
var name = "why"
var age = 18

var obj = {
  // 1.property shorthand(属性的简写)
  name,
  age,

  // 2.method shorthand(方法的简写)
  foo: function() {
    console.log(this)
  },
  bar() {
    console.log(this)
  },
  baz: () => {
    console.log(this)
  },

  // 3.computed property name(计算属性名)
  [name + 123]: 'hehehehe'
}

obj.baz()
obj.bar()
obj.foo()

// obj[name + 123] = "hahaha"
console.log(obj)
```

## 数组解构

```
var names = ["abc", "cba", "nba"]
// var item1 = names[0]
// var item2 = names[1]
// var item3 = names[2]

// 对数组的解构: []
var [item1, item2, item3] = names
console.log(item1, item2, item3)

// 解构后面的元素
var [, , itemz] = names
console.log(itemz)

// 解构出一个元素,后面的元素放到一个新数组中
var [itemx, ...newNames] = names
console.log(itemx, newNames)

// 解构的默认值
var [itema, itemb, itemc, itemd = "aaa"] = names
console.log(itemd)

```

## 对象解构

```
var obj = {
  name: "why",
  age: 18,
  height: 1.88
}

// 对象的解构: {}
var { name, age, height } = obj
console.log(name, age, height)

var { age } = obj
console.log(age)

var { name: newName } = obj
console.log(newName)

var { address: newAddress = "广州市" } = obj
console.log(newAddress)


function foo(info) {
  console.log(info.name, info.age)
}

foo(obj)

function bar({name, age}) {
  console.log(name, age)
}

bar(obj)
```

## let/const基本使用

在ES5中我们声明变量都是使用的var关键字，从ES6开始新增了两个关键字可以声明变量：let、const

let、const定义的变量被保存到VariableMap中，没有作用域提升

### var、let、const的选择

var所表现出来的特殊性：比如作用域提升、window全局对象、没有块级作用域等

使用const，这样可以保证数据的安全性不会被随意的篡改； 

只有当我们明确知道一个变量后续会需要被重新赋值时，这个时候再使用let； 

### 块级作用域

在ES6中新增了块级作用域，并且通过let、const、function、class声明的标识符是具备块级作用域的限制的：

## 标签模块字符串

```
const info = `age double is ${age * 2}`
console.log(info)
```

```
function foo(m, n, x) {
  console.log(m, n, x, '---------')
}

foo("Hello", "World")

// 另外调用函数的方式: 标签模块字符串
// foo``
// [ 'Hello World' ] undefined undefined ---------
foo`Hello World`
const name = "why"
const age = 18
// [ 'Hello', 'Wo', 'rld' ] why 18 ---------
foo`Hello${name}Wo${age}rld`
```

## 函数的默认参数

在ES6中，我们允许给函数一个默认值

```
function foo(x = 20, y = 31) {
  console.log(x, y);
}

foo() // 20 31
```

默认参数与解构

```
// 2.对象参数和默认值以及解构
function printInfo({name, age} = {name: "why", age: 18}) {
  console.log(name, age)
}

printInfo({name: "kobe", age: 40})

// 另外一种写法
function printInfo1({name = "why", age = 18} = {}) {
  console.log(name, age)
}

printInfo1()
```

## 函数的剩余参数

ES6中引用了rest parameter，可以将不定数量的参数放入到一个数组中

如果最后一个参数是 ... 为前缀的，那么它会将剩余的参数放到该参数中，并且作为一个数组；

剩余参数和arguments有什么区别呢？

- 剩余参数只包含那些没有对应形参的实参，而 arguments 对象包含了传给函数的所有实参； 
- arguments对象不是一个真正的数组，而rest参数是一个真正的数组，可以进行数组的所有操作； 
- arguments是早期的ECMAScript中为了方便去获取所有的参数提供的一个数据结构，而rest参数是ES6中提供 并且希望以此来替代arguments的；
- 剩余参数必须放到最后一个位置，否则会报错

```
function foo(n, m, ...args) {
  console.log(m, n)
  console.log(args)

  console.log(arguments)
}
```

## ES6数值表示

```
const num1 = 100 // 十进制
// b -> binary
const num2 = 0b100 // 二进制
// o -> octonary
const num3 = 0o100 // 八进制
// x -> hexadecimal
const num4 = 0x100 // 十六进制
// 大的数值的连接符(ES2021 ES12)
const num = 10_000_000_000_000_000
```

## Symbol的基本使用

Symbol是ES6中新增的一个基本数据类型，翻译为符号。

那么为什么需要Symbol呢？ 

- 在ES6之前，对象的属性名都是字符串形式，那么很容易造成属性名的冲突； 
- 比如原来有一个对象，我们希望在其中添加一个新的属性和值，但是我们在不确定它原来内部有什么内容的情况下， 很容易造成冲突，从而覆盖掉它内部的某个属性； 
- 比如我们前面在讲apply、call、bind实现时，我们有给其中添加一个fn属性，那么如果它内部原来已经有了fn属性了 呢？ 
- 比如开发中我们使用混入，那么混入中出现了同名的属性，必然有一个会被覆盖掉；

Symbol的作用，用来生成一个独一无二的值。 

- Symbol值是通过Symbol函数来生成的，生成后可以作为属性名； 
- 也就是在ES6中，对象的属性名可以使用字符串，也可以使用Symbol值；

Symbol即使多次创建值，它们也是不同的：Symbol函数执行后每次创建出来的值都是独一无二的；

我们也可以在创建Symbol值的时候传入一个描述description：这个是ES2019（ES10）新增的特性；

```
// ES6中Symbol的基本使用
const s1 = Symbol()
const s2 = Symbol()

console.log(s1 === s2) // false

// ES2019(ES10)中, Symbol还有一个描述(description)
const s3 = Symbol("aaa")
console.log(s3.description) // aaa
```

可以使用Symbol.for方法来创建相同的Symbol

```
const sa = Symbol.for("aaa")
const sb = Symbol.for("aaa")
console.log(sa === sb) // true
```

## ES6新增数据结构

在ES6之前，我们存储数据的结构主要有两种：数组、对象。

ES6中新增了另外两种数据结构：Set、Map，以及它们的另外形式WeakSet、WeakMap。

### Set

创建Set我们需要通过Set构造函数（暂时没有字面量创建的方式）

```
const set = new Set()
set.add(10)
```

Set有一个非常常用的功能就是给数组去重

```
const arrSet = new Set(arr)
const newArr = Array.from(arrSet)
const newArr = [...arrSet]
console.log(newArr)
```

set常见方法：

- Set常见的属性：
  - size：返回Set中元素的个数；
- Set常用的方法：
  - add(value)：添加某个元素，返回Set对象本身； 
  - delete(value)：从set中删除和这个值相等的元素，返回boolean类型； 
  - has(value)：判断set中是否存在某个元素，返回boolean类型； 
  - clear()：清空set中所有的元素，没有返回值； 
  - forEach(callback, [, thisArg])：通过forEach遍历set；
- 另外Set是支持for of的遍历的。

### WeakSet

和Set有什么区别呢？

1. WeakSet中只能存放对象类型，不能存放基本数据类型；
2. WeakSet对元素的引用是弱引用，如果没有其他引用对某个对象进行引用，那么GC可以对该对象进行回收
3. WeakSet不能遍历,存储到WeakSet中的对象是没办法获取的

WeakSet常见的方法：

1. add(value)：添加某个元素，返回WeakSet对象本身；
2. delete(value)：从WeakSet中删除和这个值相等的元素，返回boolean类型； 
3. has(value)：判断WeakSet中是否存在某个元素，返回boolean类型；

WeakSet的作用：

```
const personSet = new WeakSet()
class Person {
  constructor() {
    personSet.add(this)
  }

  running() {
    if (!personSet.has(this)) {
      throw new Error("不能通过非构造方法创建出来的对象调用running方法")
    }
    console.log("running~", this)
  }
}
```

