## with语句

with语句用来扩展一个语句的作用域链。

缺点：它可能是混淆错误和兼容性问题的根源。

```
var obj = {name: "why", age: 18, message: "obj message"}

with(obj) {
	console.log(name)
	console.log(age)
}
```

## eval函数

eval是一个特殊的函数，它可以将传入的字符串当做JavaScript代码来运行。

缺点：

- eval代码的可读性非常的差（代码的可读性是高质量代码的重要原则）；
- eval是一个字符串，那么有可能在执行的过程中被刻意篡改，那么可能会造成被攻击的风险； 
- eval的执行必须经过JS解释器，不能被JS引擎优化；

```
var jsString = 'var message = "Hello World"; console.log(message);'

var message = "Hello World"
console.log(message)

eval(jsString)
```

## 严格模式（strict Mode）

在ECMAScript5标准中，JavaScript提出了严格模式的概念（Strict Mode）：

严格模式: 是一种具有限制性的JavaScript模式，从而使代码隐式的脱离了 ”懒散（sloppy）模式“； 

支持严格模式的浏览器在检测到代码中有严格模式时，会以更加严格的方式对代码进行检测和执行；

严格模式对正常的JavaScript语义进行了一些限制：

- 严格模式通过 抛出错误 来消除一些原有的 静默（silent）错误； 
- 严格模式让JS引擎在执行代码时可以进行更多的优化（不需要对一些特殊的语法进行处理）； 
- 严格模式禁用了在ECMAScript未来版本中可能会定义的一些语法；

### 开启严格模式

可以支持在js文件中，或者某一个函数中，通过使用` use strict`开启严格模式

```
// "use strict"

var message = "Hello World"
console.log(message)

// 静默错误
// true.foo = "abc"

function foo() {
  "use strict";
  true.foo = "abc"
}
```

### 严格模式限制

1. 无法意外的创建全局变量 
2. 严格模式会使引起静默失败(silently fail,注:不报错也没有任何效果)的赋值操作抛出异常 
3. 严格模式下试图删除不可删除的属性 
4. 严格模式不允许函数参数有相同的名称 
5. 不允许0的八进制语法 
6. 在严格模式下，不允许使用with 
7. 在严格模式下，eval不再为上层引用变量 
8. 严格模式下，this绑定不会默认转成对象

