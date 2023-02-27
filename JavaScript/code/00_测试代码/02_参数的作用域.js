var x = 0

// 当函数的参数有默认值时, 会形成一个新的作用域, 这个作用域用于保存参数的值
function foo(x, y = function() { x = 3; console.log(x) }) {
  console.log(x)
  var x = 2
  console.log(x)
  y()
  console.log(x)
}

foo(1)
console.log(x)

// 1
// 2
// 3
// 2
// 0