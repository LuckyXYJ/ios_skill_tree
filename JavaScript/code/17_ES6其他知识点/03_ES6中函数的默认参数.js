// ES5以及之前给参数默认值
/**
 * 缺点:
 *  1.写起来很麻烦, 并且代码的阅读性是比较差
 *  2.这种写法是有bug
 */
// function foo(m, n) {
//   m = m || "aaa"
//   n = n || "bbb"

//   console.log(m, n)
// }

// 1.ES6可以给函数参数提供默认值
function foo(m = "aaa", n = "bbb") {
  console.log(m, n)
}

// foo()
foo(0, "")

// 2.对象参数和默认值以及解构
function printInfo({name, age} = {name: "why", age: 18}) {
  console.log(name, age)
}

printInfo({name: "kobe", age: 40})

// 另外一种写法
function printInfo1({name = "why", age = 18}) {
  console.log(name, age)
}

printInfo1()

// 3.有默认值的形参最好放到最后
function bar(x, y, z = 30) {
  console.log(x, y, z)
}

// bar(10, 20)
bar(undefined, 10, 20)

// 4.有默认值的函数的length属性
function baz(x, y, z, m, n = 30) {
  console.log(x, y, z, m, n)
}

console.log(baz.length)

function foo(x = 20, y = 31) {
  console.log(x, y);
}

foo() // 20 31