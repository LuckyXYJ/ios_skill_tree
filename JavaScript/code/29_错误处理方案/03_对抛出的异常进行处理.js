function foo(type) {
  if (type === 0) {
    throw new Error("foo error message~")
  }
}

// 1.第一种是不处理, bar函数会继续将收到的异常直接抛出去
function bar() {
  // try {
  foo(0)
  //   console.log("bar函数后续的继续运行")
  // } catch(err) {
  //   console.log("err:", err.message)
  //   // alert(err.message)
  // } finally {
  //   console.log("finally代码执行~, close操作")
  // }
}

function test() {
  try {
    bar()
  } catch (error) {
    console.log("error:", error)
  }
}

function demo() {
  test()
}


// 两种处理方法:
// 1.第一种是不处理, 那么异常会进一步的抛出, 直到最顶层的调用
// 如果在最顶层也没有对这个异常进行处理, 那么我们的程序就会终止执行, 并且报错
// foo()

// 2.使用try catch来捕获异常

try {
  demo()
} catch (err) {

}

console.log("后续的代码执行~")
