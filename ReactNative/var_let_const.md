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

### 声明提升

使用var关键字声明变量会存在变量提升，就是使用var关键字声明的变量会自动提升到函数作用域的顶部。所以以下写法不会报错。但是只是把声明提上去，但是赋值没有提上去，依旧打印不出hello word

反复用var多次声明同一个变量也是不会报错的

```
function test(){
    console.log(text)
    text = "hello word" 
}
test() 
```

## let

let关键字和var关键字的作用差不多，但是有着非常重要的区别，最明显的就是let声明的范围是块级作用域，而var声明的范围是函数作用域。

### 暂时性死区

let不会出现变量提升,JS引擎会注意出现在块后面的let声明，只不过在此之前不能以任何方式来引用未声明的变量。在let声明之前的执行瞬间被称为"暂时性死区(temporal dead zone)"