## throw关键字

throw语句用于抛出一个用户自定义的异常； 

当遇到throw语句时，当前的函数执行会被停止（throw后面的语句不会执行）；

throw关键字可以跟上基本数据类型：比如number、string、Boolean ，对象类型：对象类型可以包含更多的信息

## Error类型

JavaScript已经给我们提供了一个Error类，我们可以直接创建这个类的对象：

Error包含三个属性：

- messsage：创建Error对象时传入的message； 
- name：Error的名称，通常和类的名称一致； 
- stack：整个Error的错误信息，包括函数的调用栈，当我们直接打印Error对象时，打印的就是stack；

Error有一些自己的子类：

- RangeError：下标值越界时使用的错误类型； 
- SyntaxError：解析语法错误时使用的错误类型； 
- TypeError：出现类型错误时，使用的错误类型；

## 异常的处理

一个函数抛出了异常，调用它的时候程序会被强制终止：

因为如果我们在调用一个函数时，这个函数抛出了异常，但是我们并没有对这个异常进行处理，那么这个异常会继续传 递到上一个函数调用中； 而如果到了最顶层（全局）的代码中依然没有对这个异常的处理代码，这个时候就会报错并且终止程序的运行；

## 异常的捕获

使用try catch 可以避免 程序直接退出

```
function test() {
  try {
    bar()
  } catch (error) {
    console.log("error:", error)
  }
}
```

如果有一些必须要执行的代码，我们可以使用finally来执行：

finally表示最终一定会被执行的代码结构； 

注意：如果try和finally中都有返回值，那么会使用finally当中的返回值；