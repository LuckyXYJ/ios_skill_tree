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

