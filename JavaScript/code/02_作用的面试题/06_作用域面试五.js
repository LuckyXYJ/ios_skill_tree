function foo() {
  var a = b = 10
  // => 转成下面的两行代码
  // var a = 10
  // b = 10
}

foo()

// console.log(a)
console.log(b)
