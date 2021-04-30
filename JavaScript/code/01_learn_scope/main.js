
/*
let n = 100
function foo() {
    n = 300
}
foo()
console.log(n);

*/

/*

// 输出 undefined，200
function foo() {
    console.log(n);
    var n = 200
    console.log(n);
}
var n = 100
foo()
*/

/*
// 输出 undefined
var a = 100
function foo() {
    console.log(a);
    return
    var a = 100
}
foo()
*/


// 输出 报错，找不到a
function foo() {
    var a = b = 100
}

foo()
// console.log(a);
console.log(b);


// var n = 100
// function foo1() {
//     console.log(n);
// }
// function foo2() {
//     var n = 200
//     console.log(n);
//     foo1()
// }
// foo2()
// console.log(n);

