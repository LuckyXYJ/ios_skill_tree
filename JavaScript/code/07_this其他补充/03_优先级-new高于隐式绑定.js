var obj = {
  name: "obj",
  foo: function() {
    console.log(this)
  }
}

// new的优先级高于隐式绑定
var f = new obj.foo()

