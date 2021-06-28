var obj = {
  name: "why",
  age: 18
}

var info = Object.create(obj, {
  address: {
    value: "北京市",
    enumerable: true
  }
})

// hasOwnProperty方法判断
// console.log(info.hasOwnProperty("address"))
// console.log(info.hasOwnProperty("name"))

// in 操作符: 不管在当前对象还是原型中返回的都是true
// console.log("address" in info)
// console.log("name" in info)

// // for in
// for (var key in info) {
//   console.log(key)
// }

