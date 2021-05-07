function foo() {
  // AO: 销毁
  var name = "foo"
  function bar() {
    console.log("bar", name)
  }

  return bar
}

var fn = foo()
fn()


var name = "why"
function demo() {
  console.log(name)
}


// 可以访问: test就是闭包
// 有访问到: test就是不是闭包
function test() {
  // 1
  // 10000
}
