// "use strict"

var message = "Hello World"
console.log(message)

// 静默错误
// true.foo = "abc"


function foo() {
  "use strict";

  true.foo = "abc"
}

foo()
