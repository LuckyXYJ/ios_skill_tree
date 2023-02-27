## JS中this指向

this在全局作用于下指向window

函数中使用的this指向：

- 函数在调用时，JavaScript会默认给this绑定一个值； 
- this的绑定和定义的位置（编写的位置）没有关系； 
- this的绑定和调用方式以及调用的位置有关系； 
- this是在运行时被绑定的；

## this绑定方式

- 默认绑定； 
- 隐式绑定； 
- 显式绑定； 
- new绑定

### 默认绑定

独立函数调用时

独立的函数调用我们可以理解成函数没有被绑定到某个对象上进行调用；

```
function foo() {
  console.log(this)
}
foo() // wwindow
```

### 隐式绑定

通过某个对象进行调用的，会绑定该对象

隐式绑定有一个前提条件：

- 必须在调用的对象内部有一个对函数的引用（比如一个属性）； 
- 如果没有这样的引用，在进行调用时，会报找不到该函数的错误； 
- 正是通过这个引用，间接的将this绑定到了这个对象上；

```
var obj = {
  name: "why",
  foo: foo
}

obj.foo() // obj对象
```

### 显式绑定

使用call和apply调用函数。

call和apply区别：第一个参数是相同的，后面的参数，apply为数组，call为参数列表；

这两个函数的第一个参数都要求是一个对象。在调用这个函数时，会将this绑定到这个传入的对象上。

```
function sum(num1, num2, num3) {
  console.log(num1 + num2 + num3, this)
}

sum.call("call", 20, 30, 40)
sum.apply("apply", [20, 30, 40])
```

bind显式绑定，可以将一个函数总是显式地绑定到一个对象上

```
function foo() {
  console.log(this)
}
// 默认绑定和显示绑定bind冲突: 优先级(显示绑定)
var newFoo = foo.bind("aaa")
newFoo()
```

## new绑定

JavaScript中的函数可以当做一个类的构造函数来使用，也就是使用new关键字。

使用new关键字来调用函数是，会执行如下的操作：

1. 创建一个全新的对象； 
2. 这个新对象会被执行prototype连接； 
3. 这个新对象会绑定到函数调用的this上（this的绑定在这个步骤完成）； 
4. 如果函数没有返回其他对象，表达式会返回这个新对象；

```
function Person(name, age) {
  this.name = name
  this.age = age
}

var p1 = new Person("why", 18)
console.log(p1.name, p1.age)
```

### 绑定规则优先级

1. 默认规则的优先级最低 
2. 显示绑定优先级高于隐式绑定 
3. new绑定优先级高于隐式绑定
4. new绑定优先级高于bind
   1. new绑定可以和bind一起使用，new绑定优先级更高
5. new绑定和call、apply是不允许同时使用的，所以不存在谁的优先级更高 

## 其他绑定

### 内置函数的绑定

```
setTimeout(function() {
  console.log(this) // window
}, 2000)
```

```
const boxDiv = document.querySelector('.box')
boxDiv.onclick = function() {
  console.log(this) // box
}
boxDiv.addEventListener('click', function() {
  console.log(this) // box
})
```

```
var names = ["abc", "cba", "nba"]
names.forEach(function(item) {
  console.log(this) // abcd
}, "abcd")
```

### 忽略显示绑定

在显示绑定中，我们传入一个null或者undefined，那么这个显示绑定会被忽略，使用默认规则

```
function foo() {
  console.log(this)
}
// apply/call/bind: 当传入null/undefined时, 自动将this绑定成全局对象
foo.apply(null)
foo.apply(undefined)
```

### 间接函数引用

赋值(obj2.foo = obj1.foo)的结果是foo函数； 

foo函数被直接调用，那么是默认绑定；

```
var obj1 = {
  name: "obj1",
  foo: function() {
    console.log(this)
  }
}
var obj2 = {
  name: "obj2"
};
obj2.bar = obj1.foo
obj2.bar() // obj2
(obj2.bar = obj1.foo)() // window
```

### ES6箭头函数this

箭头函数并不绑定this对象，那么this引用就会从上层作用于中找到对应的this

```
var obj = {
  data: [],
  getData: function() {
    setTimeout(() => {
      var result = ["abc", "cba", "nba"]
      this.data = result
    }, 2000);
  }
}
obj.getData()
const boxDiv = document.querySelector('.box')
boxDiv.onclick = function() {
  console.log(obj.data) // ["abc", "cba", "nba"]
}
```

如果getData也是一个箭头函数， 则不会赋值到data

```
var obj = {
  data: [],
  getData: function() {
    setTimeout(() => {
      var result = ["abc", "cba", "nba"]
      this.data = result
    }, 2000);
  }
}
obj.getData()
const boxDiv = document.querySelector('.box')
boxDiv.onclick = function() {
  console.log(obj.data) // []
}
```

