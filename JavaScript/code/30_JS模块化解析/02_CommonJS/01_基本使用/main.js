// 使用另外一个模块导出的对象, 那么就要进行导入 require
// const { aaa, bbb } = require("./why.js")
const { name, age, sum } = require("./why.js")

// console.log(aaa)
// console.log(bbb)

console.log(name)
console.log(age)
console.log(sum(20, 30))
