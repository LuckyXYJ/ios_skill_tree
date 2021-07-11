
// ES6的代码块级作用域
// 对let/const/function/class声明的类型是有效
{
  let foo = "why"
  function demo() {
    console.log("demo function")
  }
  class Person {}
}

// console.log(foo) // foo is not defined
// 不同的浏览器有不同实现的(大部分浏览器为了兼容以前的代码, 让function是没有块级作用域)
demo()
var p = new Person() // Person is not defined
