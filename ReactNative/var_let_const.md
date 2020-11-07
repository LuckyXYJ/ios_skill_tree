## var

var定义的变量会成为它所在的函数的局部变量，在一个函数中用var声明变量后，当函数执行完成后，变量也会随之销毁。

```
function test(){
    var text = "hello word" 
}
test()
console.log(text) // 报错
```

如果不用var声明，则这个text会变成全局变量。如下，是可以在test外使用text的。但是这种做法不合法，不推荐这样做，局部作用域中定义全局变量很难维护

```
function test(){
 		text = "hello word" 
}
test()
console.log(text) // hello word
```

