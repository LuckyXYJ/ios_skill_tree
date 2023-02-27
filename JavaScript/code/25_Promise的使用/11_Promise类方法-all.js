// 创建多个Promise
const p1 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(11111)
  }, 1000);
})

const p2 = new Promise((resolve, reject) => {
  setTimeout(() => {
    reject(22222)
  }, 2000);
})

const p3 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(33333)
  }, 3000);
})

// 需求: 所有的Promise都变成fulfilled时, 再拿到结果
// 意外: 在拿到所有结果之前, 有一个promise变成了rejected, 那么整个promise是rejected
Promise.all([p2, p1, p3, "aaaa"]).then(res => {
  console.log(res)
}).catch(err => {
  console.log("err:", err)
})
