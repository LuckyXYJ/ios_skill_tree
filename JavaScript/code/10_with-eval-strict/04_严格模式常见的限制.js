// "use strict"

// 1. 禁止意外创建全局变量
// message = "Hello World"
// console.log(message)

// function foo() {
//   age = 20
// }

// foo()
// console.log(age)

// 2.不允许函数有相同的参数名称
// function foo(x, y, x) {
//   console.log(x, y, x)
// }

// foo(10, 20, 30)


// 3.静默错误
// true.name = "abc"
// NaN = 123
// var obj = {}
// Object.defineProperty(obj, "name", {
//   configurable: false,
//   writable: false,
//   value: "why"
// })
// console.log(obj.name)
// // obj.name = "kobe"

// delete obj.name

// 4.不允许使用原先的八进制格式 0123
// var num = 0o123 // 八进制
// var num2 = 0x123 // 十六进制
// var num3 = 0b100 // 二进制
// console.log(num, num2, num3)

// 5.with语句不允许使用

// 6.eval函数不会向上引用变量了
var jsString = '"use strict"; var message = "Hello World"; console.log(message);'
eval(jsString)

console.log(message)
