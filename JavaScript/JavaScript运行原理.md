## 浏览器的内核

不同的浏览器有不同的内核组成

- Gecko：早期被Netscape和Mozilla Firefox浏览器浏览器使用； 
- Trident：微软开发，被IE4~IE11浏览器使用，但是Edge浏览器已经转向Blink； 
- Webkit：苹果基于KHTML开发、开源的，用于Safari，Google Chrome之前也在使用； 
- Blink：是Webkit的一个分支，Google开发，目前应用于Google Chrome、Edge、Opera等； 
- 等等...

我们经常说的浏览器内核指的是浏览器的**排版引擎**（layout engine），也称为**浏览器引擎**（browser engine）、**页面渲染引擎**（rendering engine） 或**样版引擎**。

浏览器内核由两部分组成

- webCore：负责HTML解析、布局、渲染等等相关的工作；
- JavaScriptCore：解析、执行JavaScript代码；

## JavaScript引擎

JavaScript引擎帮助我们将JavaScript代码翻译成CPU指令来执行

常见的JavaScript引擎有哪些呢？ 

- SpiderMonkey：第一款JavaScript引擎，由Brendan Eich开发（也就是JavaScript作者）； 
- Chakra：微软开发，用于IT浏览器； 
- JavaScriptCore：WebKit中的JavaScript引擎，Apple公司开发； 
- V8：Google开发的强大JavaScript引擎，也帮助Chrome从众多浏览器中脱颖而出； 
- 等等…

## V8引擎架构

### v8引擎的原理：

![image-20221223150538902](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20221223150538902.png)

- Parse模块会将JavaScript代码转换成AST（抽象语法树），这是因为解释器并不直接认识JavaScript代码； 
  - 如果函数没有被调用，那么是不会被转换成AST的； 
- Ignition是一个解释器，会将AST转换成ByteCode（字节码） 同时会收集TurboFan优化所需要的信息（比如函数参数的类型信息，有了类型才能进行真实的运算）； 
  - 如果函数只调用一次，Ignition会执行解释执行ByteCode；
- TurboFan是一个编译器，可以将字节码编译为CPU可以直接执行的机器码；
  - 如果一个函数被多次调用，那么就会被标记为热点函数，那么就会经过TurboFan转换成优化的机器码，提高代码的执行性能； 
  - 但是，机器码实际上也会被还原为ByteCode，这是因为如果后续执行函数的过程中，类型发生了变化（比如sum函数原来执行的是 number类型，后来执行变成了string类型），之前优化的机器码并不能正确的处理运算，就会逆向的转换成字节码；

### V8引擎的解析图：

![image-20221223145640494](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20221223145640494.png)

JavaScript源码解析的过程

- Blink将源码交给V8引擎，Stream获取到源码并且进行编码转换； 
- Scanner会进行词法分析（lexical analysis），词法分析会将代码转换成tokens； 
- 接下来tokens会被转换成AST树，经过Parser和PreParser：
  - Parser就是直接将tokens转成AST树架构； 
  - PreParser称之为预解析，为什么需要预解析呢？ 
    - 这是因为并不是所有的JavaScript代码，在一开始时就会被执行。那么对所有的JavaScript代码进行解析，必然会 影响网页的运行效率； 
    - 所以V8引擎就实现了Lazy Parsing（延迟解析）的方案，它的作用是将不必要的函数进行预解析，也就是只解析暂 时需要的内容，而对函数的全量解析是在函数被调用时才会进行； 
    - 比如我们在一个函数outer内部定义了另外一个函数inner，那么inner函数就会进行预解析；
- 生成AST树后，会被Ignition转成字节码（bytecode），之后的过程就是代码的执行过程（后续会详细分析）。

## JavaScript的执行过程

### 初始化全局对象

js引擎会在执行代码之前，会在堆内存中创建一个全局对象：Global Object（GO） 

- 该对象 所有的作用域（scope）都可以访问； 
- 里面会包含Date、Array、String、Number、setTimeout、setInterval等等； 
- 其中还有一个window属性指向自己；

### 执行上下文栈

js引擎内部有一个执行上下文栈（Execution Context Stack，简称**ECS**），它是用于执行代码的调用栈。

ECS 执行的是全局的代码块： 

- 全局的代码块为了执行会构建一个 Global Execution Context（**GEC**）；
- GEC会 被放入到ECS中 执行； 

GEC被放入到ECS中里面包含两部分内容：

- 第一部分：在代码执行前，在parser转成AST的过程中，会将全局定义的变量、函数等加入到GlobalObject中， 但是并不会赋值； 这个过程也称之为变量的**作用域提升**（hoisting）
- 第二部分：在代码执行中，对变量赋值，或者执行其他的函数；

### 函数执行上下文

执行的过程中执行到一个函数时，就会根据函数体创建一个函数执行上下文（Functional Execution Context，简称**FEC**），并且压入到EC Stack中。

FEC中包含三部分内容：

1. 在解析函数成为AST树结构时，会创建一个Activation Object（AO）
   1. AO中包含形参、arguments、函数定义和指向函数对象、定义的变量； 
2. 作用域链：由VO（在函数中就是AO对象）和父级VO组成，查找时会一层层查找； 
3. this绑定的值

## 作用域提升练习

```
let n = 100
function foo() {
    n = 300
}
foo()
console.log(n);


// 输出 undefined，200
function foo() {
    console.log(n);
    var n = 200
    console.log(n);
}
var n = 100
foo()


// 输出 undefined
var a = 100
function foo() {
    console.log(a);
    return
    var a = 100
}
foo()


// 输出 报错，找不到a
function foo() {
    var a = b = 100
}
foo()
// console.log(a);
console.log(b);


var n = 100
function foo1() {
    console.log(n);
}
function foo2() {
    var n = 200
    console.log(n);
    foo1()
}
foo2()
console.log(n);
```

