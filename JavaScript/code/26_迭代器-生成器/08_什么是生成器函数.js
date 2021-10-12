function* foo() {
  console.log("函数开始执行~")

  const value1 = 100
  console.log("第一段代码:", value1)
  const temp = yield

  const value2 = 200
  console.log("第二段代码:", value2)
  console.log(temp)
  yield(value2)

  const value3 = 300
  console.log("第三段代码:", value3)
  yield(value3)

  console.log("函数执行结束~")
}

// 调用生成器函数时, 会给我们返回一个生成器对象
const generator = foo()

// 开始执行第一段代码
// generator.next()

// 开始执行第二端代码
// console.log("-------------")
// generator.next()
// console.log("----------")
console.log(generator.next())
console.log(generator.next(123))
console.log("----------")
generator.next()
