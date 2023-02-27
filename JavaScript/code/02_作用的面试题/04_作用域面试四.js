var a = 100

function foo() {
  console.log(a)
  return
  var a = 200
}

foo()
