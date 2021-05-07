var nums = [10, 5, 11, 100, 55]

// var newNums = []
// for (var i = 0; i < nums.length; i++) {
//   var num = nums[i]
//   if (num % 2 === 0) {
//     newNums.push(num)
//   }
// }
// console.log(newNums)

// 函数和方法的区别:
// 函数function: 独立的function, 那么称之为是一个函数
function foo() {}
// 方法method: 当我们的一个函数属于某一个对象时, 我们成这个函数是这个对象的方法
var obj = {
  foo: function() {}
}
obj.foo()

// 1.filter: 过滤
// [10, 5, 11, 100, 55]
// 10 => false => 不会被放到newNums
// 5 => false => 不会被放到newNums
// 11 => false => 不会被放到newNums
// 100 => false => 不会被放到newNums
// 55 => false => 不会被放到newNums
// var newNums = nums.filter(function(item) {
//   return item % 2 === 0 // 偶数
// })
// console.log(newNums)

// 2.map: 映射
// [10, 5, 11, 100, 55]
// var newNums2 = nums.map(function(item) {
//   return item * 10
// })
// console.log(newNums2)

// 3.forEach: 迭代
// nums.forEach(function(item) {
//   console.log(item)
// })

// 4.find/findIndex
// es6~12
// var item = nums.find(function(item) {
//   return item === 11
// })
// console.log(item)
// var friends = [
//   {name: "why", age: 18},
//   {name: "kobe", age: 40},
//   {name: "james", age: 35},
//   {name: "curry", age: 30},
// ]

// var findFriend = friends.find(function(item) {
//   return item.name === 'james'
// })
// console.log(findFriend)

var friendIndex = friends.findIndex(function(item) {
  return item.name === 'james'
})
// console.log(friendIndex)


// 5.reduce: 累加
// nums.reduce
// [10, 5, 11, 100, 55]
// var total = 0
// for (var i = 0; i < nums.length; i++) {
//   total += nums[i]
// }
// console.log(total)
// prevValue: 0, item: 10
// prevValue: 10, item: 5
// prevValue: 15, item: 11
var total = nums.reduce(function(prevValue, item) {
  return prevValue + item
}, 0)
console.log(total)
