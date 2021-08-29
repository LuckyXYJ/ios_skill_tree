// 1.||= 逻辑或赋值运算
// let message = "hello world"
// message = message || "default value"
// message ||= "default value"
// console.log(message)

// 2.&&= 逻辑与赋值运算
// &&
// const obj = {
//   name: "why",
//   foo: function() {
//     console.log("foo函数被调用")
    
//   }
// }

// obj.foo && obj.foo()

// &&=
// let info = {
//   name: "why"
// }

// // 1.判断info
// // 2.有值的情况下, 取出info.name
// // info = info && info.name
// info &&= info.name
// console.log(info)

// 3.??= 逻辑空赋值运算
let message = 0
message ??= "default value"
console.log(message)
