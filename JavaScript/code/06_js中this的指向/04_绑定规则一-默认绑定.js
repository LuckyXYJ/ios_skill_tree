// 默认绑定: 独立函数调用
// 1.案例一:
// function foo() {
//   console.log(this)
// }

// foo()

// 2.案例二:
// function foo1() {
//   console.log(this)
// }

// function foo2() {
//   console.log(this)
//   foo1()
// }

// function foo3() {
//   console.log(this)
//   foo2()
// }

// foo3()


// 3.案例三:
// var obj = {
//   name: "why",
//   foo: function() {
//     console.log(this)
//   }
// }

// var bar = obj.foo
// bar() // window
// obj.foo()


// 4.案例四:
// function foo() {
//   console.log(this)
// }
// var obj = {
//   name: "why",
//   foo: foo
// }

// var bar = obj.foo
// bar() // window
// obj.foo()

// 5.案例五:
// function foo() {
//   function bar() {
//     console.log(this)
//   }
//   return bar
// }

// var fn = foo()
// fn() // window

// var obj = {
//   name: "why",
//   eating: fn
// }

// obj.eating() // 隐式绑定
