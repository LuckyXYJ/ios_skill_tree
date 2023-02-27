var obj = {
  name: "why",
  age: 18
}
obj.__proto__ = {
  address: "北京市"
}
console.log(obj.address) // 北京市
console.log(obj.__proto__.__proto__) // [Object: null prototype] {}
console.log(obj.__proto__.__proto__.__proto__)
