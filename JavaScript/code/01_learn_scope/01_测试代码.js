const name = "why"
console.log(name)

function foo() {
  console.log("foo")
}

foo()

function outer() {
  function inner() {
    var inner = "inner"
    console.log(inner)
  }
}

outer()

