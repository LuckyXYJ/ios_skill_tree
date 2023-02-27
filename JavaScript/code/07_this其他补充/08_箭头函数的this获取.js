// 1.测试箭头函数中this指向
var name = "why"

var foo = () => {
  console.log(this)
}

foo()
var obj = {foo: foo}
obj.foo()
foo.call("abc")

// 2.应用场景
var obj = {
  data: [],
  getData: function() {
    // 发送网络请求, 将结果放到上面data属性中
    // 在箭头函数之前的解决方案
    // var _this = this
    // setTimeout(function() {
    //   var result = ["abc", "cba", "nba"]
    //   _this.data = result
    // }, 2000);
    // 箭头函数之后
    setTimeout(() => {
      var result = ["abc", "cba", "nba"]
      this.data = result
    }, 2000);
  }
}

obj.getData()

const boxDiv = document.querySelector('.box')
boxDiv.onclick = function() {
  console.log(obj.data)
}
