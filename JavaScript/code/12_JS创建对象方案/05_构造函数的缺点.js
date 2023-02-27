function foo() {
  function bar() {

  }
  return bar
}

var fn1 = foo()
var fn2 = foo()

console.log(fn1 === fn2)

