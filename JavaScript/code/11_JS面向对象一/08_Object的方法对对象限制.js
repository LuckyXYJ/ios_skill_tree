var obj = {
  name: 'why',
  age: 18
}

// 1.禁止对象继续添加新的属性
Object.preventExtensions(obj)

obj.height = 1.88
obj.address = "广州市"

console.log(obj)

// 2.禁止对象配置/删除里面的属性
// for (var key in obj) {
//   Object.defineProperty(obj, key, {
//     configurable: false,
//     enumerable: true,
//     writable: true,
//     value: obj[key]
//   })
// }

Object.seal(obj)

delete obj.name
console.log(obj.name)

// 3.让属性不可以修改(writable: false)
Object.freeze(obj)

obj.name = "kobe"
console.log(obj.name)
