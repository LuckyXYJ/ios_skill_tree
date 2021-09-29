## Promise

```
const promise = new Promise((resolve, reject) => {
		// Executor
})

promise.then(res => {
	
}, err => {

})
```

Promise使用过程，我们可以将它划分成三个状态：

- 待定（pending）: 初始状态，既没有被兑现，也没有被拒绝； 当执行executor中的代码时，处于该状态； 
- 已兑现（fulfilled）: 意味着操作成功完成；执行了resolve时，处于该状态； 
- 已拒绝（rejected）: 意味着操作失败；执行了reject时，处于该状态；

## Executor

- Executor是在创建Promise时需要传入的一个回调函数，这个回调函数会被立即执行，并且传入两个参数：

- Executor中确定我们的Promise状态：

  - 通过resolve，可以兑现（fulfilled）Promise的状态，我们也可以称之为已决议（resolved）； 
  - 通过reject，可以拒绝（reject）Promise的状态；

- 这里需要注意：一旦状态被确定下来，Promise的状态会被 锁死，该Promise的状态是不可更改的

  - 在我们调用resolve的时候，如果resolve传入的值本身不是一个Promise，那么会将该Promise的状态变成 兑 现（fulfilled）； 
  - 在之后我们去调用reject时，已经不会有任何的响应了（并不是这行代码不会执行，而是无法改变Promise状

  态）；

### resolve不同值的区别

- 如果resolve传入一个普通的值或者对象，那么这个值会作为then回调的参数； 
- 如果resolve中传入的是另外一个Promise，那么这个新Promise会决定原Promise的状态： 
- 如果resolve中传入的是一个对象，并且这个对象有实现then方法，那么会执行该then方法，并且根据 then方法的结果来决定Promise的状态：

![image-20230201213807185](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230201213807185.png)

## then方法 

### 接受两个参数

then方法是Promise对象上的一个方法：它其实是放在Promise的原型上的 Promise.prototype.then

then方法接受两个参数：

- fulfilled的回调函数：当状态变成fulfilled时会回调的函数； 
- reject的回调函数：当状态变成reject时会回调的函数；

### 多次调用

一个Promise的then方法是可以被多次调用的：

- 每次调用我们都可以传入对应的fulfilled回调；
- 当Promise的状态变成fulfilled的时候，这些回调函数都会被执行；

```
promise.then(res => {
  console.log("res1:", res)
})

promise.then(res => {
  console.log("res2:", res)
})

promise.then(res => {
  console.log("res3:", res)
})

// 以上三个都会执行
```

### 返回值

then方法本身是有返回值的，它的返回值是一个Promise

then方法返回的Promise处于什么状态呢？ 

- 当then方法中的回调函数本身在执行的时候，那么它处于pending状态； 
- 当then方法中的回调函数返回一个结果时，那么它处于fulfilled状态，并且会将结果作为resolve的参数； 
  - 情况一：返回一个普通的值； 
  - 情况二：返回一个Promise； 
  - 情况三：返回一个thenable值； 
- 当then方法抛出一个异常时，那么它处于reject状态；

## catch方法

catch方法也是Promise对象上的一个方法：它也是放在Promise的原型上的 Promise.prototype.catch n 一个Promise的catch方法是可以被多次调用的：

### 多次调用

- 每次调用我们都可以传入对应的reject回调； 
- 当Promise的状态变成reject的时候，这些回调函数都会被执行；

### 返回值

catch方法也是会返回一个Promise对象的

## finally方法

finally是在ES9（ES2018）中新增的一个特性：表示无论Promise对象无论变成fulfilled还是reject状态，最终都会被执行的代码。

finally方法是不接收参数的，因为无论前面是fulfilled状态，还是reject状态，它都会执行。

## resolve、reject方法

then、catch、finally方法都属于Promise的实例方法，都是存放在Promise的prototype上的。

resolve、reject是Promise的类方法

Promise.resolve的用法相当于new Promise，并且执行resolve操作

```
const promise = Promise.resolve({ name: "why" })
// 相当于
const promise2 = new Promise((resolve, reject) => {
  resolve({ name: "why" })
})
```

Promise.reject的用法相当于new Promise，只是会调用reject：

```
const promise = Promise.reject("rejected message")
相当于
const promise2 = new Promsie((resolve, reject) => {
  reject("rejected message")
})
```

## all方法

类方法是Promise.all 的作用是将多个Promise包裹在一起形成一个新的Promise； 

新的Promise状态由包裹的所有Promise共同决定：

- 当所有的Promise状态变成fulfilled状态时，新的Promise状态为fulfilled，并且会将所有Promise的返回值 组成一个数组； 
- 当有一个Promise状态为reject时，新的Promise状态为reject，并且会将第一个reject的返回值作为参数；

缺陷：

- 当有其中一个Promise变成reject状态时，新Promise就会立即变成对应的reject状态。
- 那么对于resolved的，以及依然处于pending状态的Promise，我们是获取不到对应的结果的；

## allSettled方法

ES11（ES2020）中，添加了新的API Promise.allSettled。旨在解决all方法的缺陷

该方法会在所有的Promise都有结果（settled），无论是fulfilled，还是reject时，才会有最终的状态； 

并且这个Promise的结果一定是fulfilled的；

```
Promise.allSettled([p1, p2, p3]).then(res => {
  console.log(res)
}).catch(err => {
  console.log(err)
})
```

allSettled打印的结果是一个数组，数组中存放着每一个Promise的结果，并且是对应一个对象的； 

这个对象中包含status状态，以及对应的value值；

## race方法

如果有一个Promise有了结果，我们就希望决定最终新Promise的状态，那么可以使用race方法： 

race是竞技、竞赛的意思，表示多个Promise相互竞争，谁先有结果，那么就使用谁的结果；

```
// race: 竞技/竞赛
// 只要有一个Promise变成fulfilled状态, 那么就结束
// 意外: 
Promise.race([p1, p2, p3]).then(res => {
  console.log("res:", res)
}).catch(err => {
  console.log("err:", err)
})
```

## any方法

any方法是ES12中新增的方法，和race方法是类似的：

- any方法会等到一个fulfilled状态，才会决定新Promise的状态； 
- 如果所有的Promise都是reject的，那么也会等到所有的Promise都变成rejected状态；
- 如果所有的Promise都是reject的，那么会报一个AggregateError的错误。

```
// any方法
Promise.any([p1, p2, p3]).then(res => {
  console.log("res:", res)
}).catch(err => {
  console.log("err:", err.errors)
})
```

