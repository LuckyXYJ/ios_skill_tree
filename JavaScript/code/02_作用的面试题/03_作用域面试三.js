var n = 100
function foo1() {
    console.log(n);
}
function foo2() {
    var n = 200
    console.log(n);
    foo1()
}
foo2()
console.log(n);