"use strict"

// 在严格模式下, 自执行函数(默认绑定)会指向undefined
// 之前编写的代码中, 自执行函数我们是没有使用过this直接去引用window
function foo() {
  console.log(this)
}

var obj = {
  name: "why",
  foo: foo
}

foo()

obj.foo()
var bar = obj.foo
bar()


// setTimeout的this
// fn.apply(this = window)
setTimeout(function() {
  console.log(this)
}, 1000);
