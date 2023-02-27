var obj = { name: "why" }

// console.log(obj.address)

// 到底是找到哪一层对象之后停止继续查找了呢?
// 字面对象obj的原型是 [Object: null prototype] {}
// [Object: null prototype] {} 就是顶层的原型
console.log(obj.__proto__)

// obj.__proto__ => [Object: null prototype] {}
console.log(obj.__proto__.__proto__)


