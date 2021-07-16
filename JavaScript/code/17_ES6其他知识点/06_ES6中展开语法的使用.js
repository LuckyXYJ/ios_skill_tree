const names = ["abc", "cba", "nba"]
const name = "why"
const info = {name: "why", age: 18}

// 1.函数调用时
function foo(x, y, z) {
  console.log(x, y, z)
}

// foo.apply(null, names)
foo(...names)
foo(...name)

// 2.构造数组时
const newNames = [...names, ...name]
console.log(newNames)

// 3.构建对象字面量时ES2018(ES9)
const obj = { ...info, address: "广州市", ...names }
console.log(obj)


