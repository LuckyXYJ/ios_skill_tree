{

}

// if语句的代码就是块级作用域
// if (true) {
//   var foo = "foo"
//   let bar = "bar"
// }

// console.log(foo)
// console.log(bar)

// switch语句的代码也是块级作用域
// var color = "red"

// switch (color) {
//   case "red":
//     var foo = "foo"
//     let bar = "bar"
// }

// console.log(foo)
// console.log(bar)

// for语句的代码也是块级作用域
// for (var i = 0; i < 10; i++) {
//   // console.log("Hello World" + i)
// }

// console.log(i)

for (let i = 0; i < 10; i++) {
}

console.log(i)
