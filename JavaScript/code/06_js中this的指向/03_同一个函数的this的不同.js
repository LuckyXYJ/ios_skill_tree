// this指向什么, 跟函数所处的位置是没有关系的
// 跟函数被调用的方式是有关系

function foo() {
  console.log(this)
}

// 1.直接调用这个函数
foo()

// 2.创建一个对象, 对象中的函数指向foo
var obj = {
  name: 'why',
  foo: foo
}

obj.foo()

// 3.apply调用
foo.apply("abc")
