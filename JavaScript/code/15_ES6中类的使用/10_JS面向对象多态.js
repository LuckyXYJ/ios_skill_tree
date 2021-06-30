// 多态: 当对不同的数据类型执行同一个操作时, 如果表现出来的行为(形态)不一样, 那么就是多态的体现.
function calcArea(foo) {
  console.log(foo.getArea())
}

var obj1 = {
  name: "why",
  getArea: function() {
    return 1000
  }
}

class Person {
  getArea() {
    return 100
  }
}

var p = new Person()

calcArea(obj1)
calcArea(p)


// 也是多态的体现
function sum(m, n) {
  return m + n
}

sum(20, 30)
sum("abc", "cba")
