## 迭代器（iterator）

next方法有如下的要求： 一个无参数或者一个参数的函数，返回一个应当拥有以下两个属性的对象：

- done（boolean） 
  - 如果迭代器可以产生序列中的下一个值，则为 false。（这等价于没有指定 done 这个属性。） 
  - 如果迭代器已将序列迭代完毕，则为 true。这种情况下，value 是可选的，如果它依然存在，即为迭代结束之后的默认返回值。 
- value 
  - 迭代器返回的任何 JavaScript 值。done 为 true 时可省略。

迭代器代码：

```
function createArrayIterator(arr) {
  let index = 0
  return {
    next: function() {
      if (index < arr.length) {
        return { done: false, value: arr[index++] }
      } else {
        return { done: true, value: undefined } 
      }
    }
  }
}

const names = ["abc", "cba", "nba"]

const namesIterator = createArrayIterator(names)
console.log(namesIterator.next())
console.log(namesIterator.next())
console.log(namesIterator.next())
```

## 可迭代对象

当一个对象实现了iterable protocol协议时，它就是一个可迭代对象； 这个对象的要求是必须实现 @@iterator 方法，在代码中我们使用 Symbol.iterator 访问该属性

当一个对象变成一个可迭代对象的时候，进行某些迭代操作，比如 for...of 操作时，其实就会调用它的 @@iterator 方法；

```
const iterableObj = {
  names: ["abc", "cba", "nba"],
  [Symbol.iterator]: function() {
    let index = 0
    return {
      next: () => {
        if (index < this.names.length) {
          return { done: false, value: this.names[index++] }
        } else {
          return { done: true, value: undefined }
        }
      }
    }
  }
}

for (const item of iterableObj) {
  console.log(item)
}
```

可迭代对象应用

- JavaScript中语法：for ...of、展开语法（spread syntax）、yield*（后面讲）、解构赋值（Destructuring_assignment）； 
- 创建一些对象时：new Map([Iterable])、new WeakMap([iterable])、new Set([iterable])、new WeakSet([iterable]); 
- 一些方法的调用：Promise.all(iterable)、Promise.race(iterable)、Array.from(iterable);

![image-20230202113841244](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230202113841244.png)

## 迭代器的中断

比如遍历的过程中通过break、continue、return、throw中断了循环操作；比如在解构的时候，没有解构所有的值；

想要监听迭代器中断的话，可以添加return方法：

```js
[Symbol.iterator]() {
    let index = 0
    return {
      next: () => {
        if (index < this.students.length) {
          return { done: false, value: this.students[index++] }
        } else {
          return { done: true, value: undefined }
        }
      },
      return: () => {
        console.log("迭代器提前终止了~")
        return { done: true, value: undefined }
      }
    }
  }
```

## 生成器 Generator

生成器是ES6中新增的一种函数控制、使用的方案，它可以让我们更加灵活的控制函数什么时候继续执行、暂停执 行等。

生成器特点：

- 生成器函数需要在function的后面加一个符号：* 
- 生成器函数可以通过yield关键字来控制函数的执行流程： 
- 生成器函数的返回值是一个Generator（生成器）：生成器事实上是一种特殊的迭代器；
- 调用next函数的时候，可以给它传递参数，那么这个参数会作为上一个yield语句的返回值；

```js
function* foo() {
  console.log("函数开始执行~")

  const value1 = 100
  console.log("第一段代码:", value1)
  const temp = yield

  const value2 = 200
  console.log("第二段代码:", value2 + temp) // 323
  yield(value2)

  console.log("函数执行结束~")
}

const generator = foo()
// 开始执行第一段代码
console.log(generator.next().value) // { value: undefined, done: false }
// 开始执行第二段代码
console.log(generator.next(123).value) // { value: 200, done: false } // temp = 123
// 最后一行代码
generator.next()
```

### 生成器提前结束 – return函数

是通过return函数传值后这个生成器函数就会结束，之后调用next不会继续生成值了；

```js
function* foo(num) {
  console.log("函数开始执行~")

  const value1 = 100 * num
  console.log("第一段代码:", value1)
  const n = yield value1

  const value2 = 200 * n
  console.log("第二段代码:", value2)
  const count = yield value2

  console.log("函数执行结束~")
  return "123"
}

console.log(generator.next())
// 第二段代码的执行, 使用了return
// 那么就意味着相当于在第一段代码的后面加上return, 就会提前终端生成器函数代码继续执行
console.log(generator.return(15)) // 执行完该代码后，后面的next都不会再执行
console.log(generator.next()) // { value: undefined, done: true }

// 输出：
// 函数开始执行~
// 第一段代码: 1000
// { value: 1000, done: false }
// { value: 15, done: true }
// { value: undefined, done: true }
```

### 生成器抛出异常 – throw函数

除了给生成器函数内部传递参数之外，也可以给生成器函数内部抛出异常：

抛出异常后我们可以在生成器函数中捕获异常；

但是在catch语句中不能继续yield新的值了，但是可以在catch语句外使用yield继续中断函数的执行；

![image-20230202143343547](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230202143343547.png)

### 生成器替代迭代器

我们还可以使用yield*来生产一个可迭代对象：

这个时候相当于是一种yield的语法糖，只不过会依次迭代这个可迭代对象，每次迭代其中的一个值；

```
// 1.生成器来替代迭代器
function* createArrayIterator(arr) {

  // 3.第三种写法 yield*
  yield* arr

  // 2.第二种写法
  // for (const item of arr) {
  //   yield item
  // }
  // 1.第一种写法
  // yield "abc" // { done: false, value: "abc" }
  // yield "cba" // { done: false, value: "abc" }
  // yield "nba" // { done: false, value: "abc" }
}
```

## 生成器Generator使用

![image-20230202143849783](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230202143849783.png)