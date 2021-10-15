async function foo() {
  console.log("foo function start~")

  console.log("内部的代码执行1")
  console.log("内部的代码执行2")
  console.log("内部的代码执行3")

  console.log("foo function end~")
}


console.log("script start")
foo()
console.log("script end")
