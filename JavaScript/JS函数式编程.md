## JavaScript函数arguments

arguments 是一个 对应于 传递给函数的参数 的 类数组(array-like)对象。

array-like意味着它不是一个数组类型，而是一个对象类型：

- 它**拥有**数组的一些特性，比如说length，比如可以通过index索引来访问； 
- 它**没有**数组的一些方法，比如forEach、map等；

arguments转数组

```
  // 1.自己遍历
  var newArr = []
  for (var i = 0; i < arguments.length; i++) {
    newArr.push(arguments[i] * 10)
  }
  console.log(newArr)
  
  //Array.prototype.slice将arguments转成array
  var newArr2 = Array.prototype.slice.call(arguments)
  console.log(newArr2)
  var newArr3 = [].slice.call(arguments)
  console.log(newArr3)
  
  // 2.3.ES6的语法
  var newArr4 = Array.from(arguments)
  console.log(newArr4)
  var newArr5 = [...arguments]
  console.log(newArr5)
```

### 箭头函数不绑定arguments

箭头函数是不绑定arguments的，所以我们在箭头函数中使用arguments会去上层作用域查找

```
// 1.案例一:
var foo = () => {
  console.log(arguments) // 找不到，报错
}
foo()

// 2.案例二:
function foo() {
  var bar = () => {
    console.log(arguments) // [123 ...]
  }
  return bar
}
var fn = foo(123)
fn()
```

## JavaScript纯函数

纯函数的定义： 确定的输入，一定会产生确定的输出； 函数在执行过程中，不能产生副作用；

副作用: 表示在执行一个函数时，除了返回函数值之外，还对调用函数产生 了附加的影响，比如修改了全局变量，修改参数或者改变外部的存储；

### 纯函数的案例

slice：slice截取数组时不会对原数组进行任何操作,而是生成一个新的数组；slice就是一个纯函数，不会修改传入的参数；

splice：splice截取数组, 会返回一个新的数组, 也会对原数组进行修改； 非纯函数

### 纯函数优势

只是单纯实现自己的业务逻辑即可，不需要关心传入的内容是如何获得的或者依赖其他的外部变量是否已经发生了修改； 

你在用的时候，你确定你的输入内容不会被任意篡改，并且自己确定的输入，一定会有确定的输出；

实例：React中就要求我们无论是函数还是class声明一个组件，这个组件都必须像纯函数一样，保护它们的props不被修改

## JavaScript柯里化

柯里化：只传递给函数一部分参数来调用它，让它返回一个函数去处理剩余的参数； 

```
function add(x, y, z) {
  return x + y + z
}

var result = add(10, 20, 30)
console.log(result)

function sum1(x) {
  return function(y) {
    return function(z) {
      return x + y + z
    }
  }
}

var result1 = sum1(10)(20)(30)
console.log(result1)
```

柯里化简化代码

```
// 简化柯里化的代码
var sum2 = x => y => z => {
  return x + y + z
}

console.log(sum2(10)(20)(30))

var sum3 = x => y => z => x + y + z
console.log(sum3(10)(20)(30))
```

柯里化意义：希望一个函数处理的问题尽可能的单一，而不是将一大堆的处理过程交给一个 函数来处理；

## 组合函数

组合函数：依次执行的两个函数，每次都需要进行两个函数的调用，可将其组合起来，自动依次调用

```
function hyCompose(...fns) {
  var length = fns.length
  for (var i = 0; i < length; i++) {
    if (typeof fns[i] !== 'function') {
      throw new TypeError("Expected arguments are functions")
    }
  }

  function compose(...args) {
    var index = 0
    var result = length ? fns[index].apply(this, args): args
    while(++index < length) {
      result = fns[index].call(this, result)
    }
    return result
  }
  return compose
}
```

