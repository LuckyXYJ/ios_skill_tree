var n = 100

function foo() {
  n = 200
  // console.log(this);
}

foo()

console.log(n)

console.log(this);