// 你不知道的JavaScript
function foo(el) {
    console.log(el,this.id)
  }
  
  var obj = {
    id:'awesome'
  }
  
  var nums = [1,2,3]
  nums.forEach(foo,obj)
  