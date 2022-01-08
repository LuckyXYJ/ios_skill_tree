## BOM

BOM，Browser Object Model

我们可以将BOM看成是连接JavaScript脚本与浏览器窗口的桥梁。

BOM主要包括一下的对象模型：

- window：包括全局属性、方法，控制浏览器窗口相关的属性、方法； 
- location：浏览器连接到的对象的位置（URL）； 
- history：操作浏览器的历史； 
- document：当前窗口操作文档的对象；

window对象在浏览器中有两个身份：

- 身份一：全局对象。 
  - 我们知道ECMAScript其实是有一个全局对象的，这个全局对象在Node中是global； 
  - 在浏览器中就是window对象； 
- 身份二：浏览器窗口对象。 
  - 作为浏览器窗口时，提供了对浏览器操作的相关的API；

### Window全局对象

在全局通过var声明的变量，会被添加到GO中，也就是会被添加到window上； 

window默认给我们提供了全局的函数和类：setTimeout、Math、Date、Object等；

### Window窗口对象

- 包含大量的属性，localStorage、console、location、history、screenX、scrollX等等（大概60+个属性）； 
- 包含大量的方法，alert、close、scrollTo、open等等（大概40+个方法）； 
- 包含大量的事件，focus、blur、load、hashchange等等（大概30+个事件）； 
- 包含从EventTarget继承过来的方法，addEventListener、removeEventListener、dispatchEvent方法；

#### window属性

```
console.log(window.screenX)
console.log(window.screenY)

window.addEventListener("scroll", () => {
  console.log(window.scrollX, window.scrollY)
})

console.log(window.outerHeight)
console.log(window.innerHeight)
```

#### window常见的方法

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203220320550.png" alt="image-20230203220320550" style="zoom:50%;" />

#### window常见的事件

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203220509987.png" alt="image-20230203220509987" style="zoom:50%;" />

#### EventTarget

Window继承自EventTarget，所以会继承其中的属性和方法：

- addEventListener：注册某个事件类型以及事件处理函数； 
- removeEventListener：移除某个事件类型以及事件处理函数； 
- dispatchEvent：派发某个事件类型到EventTarget上；

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203220753360.png" alt="image-20230203220753360" style="zoom:50%;" />

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203220810613.png" alt="image-20230203220810613" style="zoom:50%;" />

### Location对象

#### 常见的属性

Location对象用于表示window上当前链接到的URL信息。

- href: 当前window对应的超链接URL, 整个URL； 
- protocol: 当前的协议； 
- host: 主机地址； 
- hostname: 主机地址(不带端口)； 
- port: 端口； ppathname: 路径； 
- search: 查询字符串； 
- hash: 哈希值； 
- username：URL中的username（很多浏览器已经禁用）； 
- password：URL中的password（很多浏览器已经禁用）；

#### 常见的方法

- assign：赋值一个新的URL，并且跳转到该URL中； 
- replace：打开一个新的URL，并且跳转到该URL中（不同的是不会在浏览记录中留下之前的记录）； 
- reload：重新加载页面，可以传入一个Boolean类型；

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203221807672.png" alt="image-20230203221807672" style="zoom:50%;" />

### history对象

history对象允许我们访问浏览器曾经的会话历史记录。

有两个属性： 

- length：会话中的记录条数； 
- state：当前保留的状态值； 

有五个方法： 

- back()：返回上一页，等价于history.go(-1)； 
- forward()：前进下一页，等价于history.go(1)； 
- go()：加载历史中的某一页； 
- pushState()：打开一个指定的地址； 
- replaceState()：打开一个新的地址，并且使用replace；

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203221720825.png" alt="image-20230203221720825" style="zoom:50%;" />

## DOM

Document Object Model（DOM，文档对象模型）

### EventTarget

因为继承自EventTarget，所以也可以使用EventTarget的方法：

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203221947669.png" alt="image-20230203221947669" style="zoom:50%;" />

### Node节点

所有的DOM节点类型都继承自Node接口。

Node有几个非常重要的属性：

- nodeName：node节点的名称。 
- nodeType：可以区分节点的类型。 
- nodeValue：node节点的值； 
- childNodes：所有的子节点；

![image-20230203222041720](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203222041720.png)

### Document

Document节点表示的整个载入的网页，我们来看一下常见的属性和方法：

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203222113867.png" alt="image-20230203222113867" style="zoom:50%;" />

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203222138839.png" alt="image-20230203222138839" style="zoom:50%;" />

### Element

我们平时创建的div、p、span等元素在DOM中表示为Element元素

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203222210932.png" alt="image-20230203222210932" style="zoom:50%;" />

## 认识事件监听

浏览器在某个时刻可能会发生一些事件，比如鼠标点击、移动、滚动、获取、失去焦点、输入内容等等一系列 的事件；

监听方式：

- 在script中直接监听； 
- 通过元素的on来监听事件； 
- 通过EventTarget中的addEventListener来监听；

### 事件冒泡和事件捕获

默认情况下事件是从最内层的span向外依次传递的顺序，这个顺序我们称之为**事件冒泡**（Event Bubble）。

还有另外一种监听事件流的方式就是从外层到内层（body -> span），这种称之为**事件捕获**（Event Capture）；

<img src="http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203222534533.png" alt="image-20230203222534533" style="zoom:50%;" />

如果我们同时有事件冒泡和时间捕获的监听，那么会优先监听到事件捕获的：

### 事件对象event

当一个事件发生时，就会有和这个事件相关的很多信息：

- 比如事件的类型是什么，你点击的是哪一个元素，点击的位置是哪里等等相关的信息； 
- 那么这些信息会被封装到一个Event对象中； 
- 该对象给我们提供了想要的一些属性，以及可以通过该对象进行某些操作；

常见的属性：

- type：事件的类型； 
- target：当前事件发生的元素； 
- currentTarget：当前处理事件的元素； 
- offsetX、offsetY：点击元素的位置；

常见的方法： 

- preventDefault：取消事件的默认行为； 
- stopPropagation：阻止事件的进一步传递；