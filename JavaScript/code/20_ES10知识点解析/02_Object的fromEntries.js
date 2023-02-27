// const obj = {
//   name: "why",
//   age: 18,
//   height: 1.88
// }

// const entries = Object.entries(obj)
// console.log(entries)

// const newObj = {}
// for (const entry of entries) {
//   newObj[entry[0]] = entry[1]
// }

// 1.ES10中新增了Object.fromEntries方法
// const newObj = Object.fromEntries(entries)

// console.log(newObj)


// 2.Object.fromEntries的应用场景
const queryString = 'name=why&age=18&height=1.88'
const queryParams = new URLSearchParams(queryString)
console.log(queryParams)
for (const param of queryParams) {
  console.log(param)
}

const paramObj = Object.fromEntries(queryParams)
console.log(paramObj)
