// rest parameters
function sum(...nums) {
  console.log(nums)
}

sum(10)
sum(10, 20)
sum(10, 20, 30)
sum(10, 20, 30, 40, 50)

// 展开运算符 spread
var names = ["abc", "cba", "nba"]
// var newNames = [...names]
function foo(name1, name2, name3) {}
foo(...names)
