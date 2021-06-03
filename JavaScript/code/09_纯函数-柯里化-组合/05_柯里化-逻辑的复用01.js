// function sum(m, n) {
//   return m + n
// }

// // 假如在程序中,我们经常需要把5和另外一个数字进行相加
// console.log(sum(5, 10))
// console.log(sum(5, 14))
// console.log(sum(5, 1100))
// console.log(sum(5, 555))

function makeAdder(count) {
  count = count * count

  return function(num) {
    return count + num
  }
}

// var result = makeAdder(5)(10)
// console.log(result)
var adder5 = makeAdder(5)
adder5(10)
adder5(14)
adder5(1100)
adder5(555)
