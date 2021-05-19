## JS内存回收

JS 有自动垃圾回收机制，就是找出那些不再继续使用的值，然后释放其占用的内存。

垃圾回收算法：

- 引用计数垃圾收集
- 标记清楚算法

## 内存泄露

如果连续五次垃圾回收之后，内存占用一次比一次大，就有内存泄漏。

### 在 Chrome 浏览器中，我们可以这样查看内存占用情况

1. 打开页面，右键选择检查，打开开发者工具
2. 在顶部勾选 Memory
3. 模拟用户操作，并进行多次内存快照

判定当前是否有内存泄漏：

1. 多次快照后，比较每次快照中内存的占用情况，如果呈上升趋势，那么可以认为存在内存泄漏
2. 某次快照后，看当前内存占用的趋势图，如果走势不平稳，呈上升趋势，那么可以认为存在内存泄漏

### 在 Node环境 查看内存情况

```
console.log(process.memoryUsage());
// { 
//     rss: 27709440,
//     heapTotal: 5685248,
//     heapUsed: 3449392,
//     external: 8772 
// }
```

该对象包含四个字段，单位是字节，含义如下:

- rss（resident set size）：所有内存占用，包括指令区和堆栈。
- heapTotal："堆"占用的内存，包括用到的和没用到的。
- heapUsed：用到的堆的部分。
- external： V8 引擎内部的 C++ 对象占用的内存。

### 常见内存泄露：

1、非必要的全局变量。如下代码，就是创建了两个全局变量name1,name2

```
function foo() {
    name1 = 'xyj'; // 没有声明变量 实际上是全局变量 => window.name1
    this.name2 = 'why' // 全局变量 => window.name2
}
foo();
```

2、被遗忘的定时器和回调函数

```
var serverData = loadData();
setInterval(function() {
    var renderer = document.getElementById('renderer');
    if(renderer) {
        renderer.innerHTML = JSON.stringify(serverData);
    }
}, 5000); // 每 5 秒调用一次
```

如果后续 renderer 元素被移除，整个定时器实际上没有任何作用。 但如果你没有回收定时器，整个定时器依然有效, 不但定时器无法被内存回收， 定时器函数中的依赖也无法回收。在这个案例中的 serverData 也无法被回收。

3、闭包

在 JS 开发中，我们会经常用到闭包，一个内部函数，有权访问包含其的外部函数中的变量。 下面这种情况下，闭包也会造成内存泄露:

```
var theThing = null;
var replaceThing = function () {
  var originalThing = theThing;
  var unused = function () {
    if (originalThing) // 对于 'originalThing'的引用
      console.log("hi");
  };
  theThing = {
    longStr: new Array(1000000).join('*'),
    someMethod: function () {
      console.log("message");
    }
  };
};
setInterval(replaceThing, 1000);
```

这段代码，每次调用 replaceThing 时，theThing 获得了包含一个巨大的数组和一个对于新闭包 someMethod 的对象。 同时 unused 是一个引用了 originalThing 的闭包。

这个范例的关键在于，闭包之间是共享作用域的，尽管 unused 可能一直没有被调用，但是 someMethod 可能会被调用，就会导致无法对其内存进行回收。 当这段代码被反复执行时，内存会持续增长。

4、DOM 引用

很多时候, 我们对 Dom 的操作, 会把 Dom 的引用保存在一个数组或者 Map 中。

```javascript
var elements = {
    image: document.getElementById('image')
};
function doStuff() {
    elements.image.src = 'http://example.com/xxx.png';
}
function removeImage() {
    document.body.removeChild(document.getElementById('image'));
    // 这个时候我们对于 #image 仍然有一个引用, Image 元素, 仍然无法被内存回收.
}
复制代码
```

上述案例中，即使我们对于 image 元素进行了移除，但是仍然有对 image 元素的引用，依然无法对齐进行内存回收。

另外需要注意的一个点是，对于一个 Dom 树的叶子节点的引用。 举个例子: 如果我们引用了一个表格中的td元素，一旦在 Dom 中删除了整个表格，我们直观的觉得内存回收应该回收除了被引用的 td 外的其他元素。 但是事实上，这个 td 元素是整个表格的一个子元素，并保留对于其父元素的引用。 这就会导致对于整个表格，都无法进行内存回收。所以我们要小心处理对于 Dom 元素的引用。