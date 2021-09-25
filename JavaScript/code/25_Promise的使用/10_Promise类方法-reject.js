// const promise = Promise.reject("rejected message")
// 相当于
// const promise2 = new Promsie((resolve, reject) => {
//   reject("rejected message")
// })

// 注意: 无论传入什么值都是一样的
const promise = Promise.reject(new Promise(() => {}))

promise.then(res => {
  console.log("res:", res)
}).catch(err => {
  console.log("err:", err)
})
