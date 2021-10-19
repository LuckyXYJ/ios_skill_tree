## 异步函数 async function

async关键字用于声明一个异步函数：

- async是asynchronous单词的缩写，异步、非同步； 
- sync是synchronous单词的缩写，同步、同时；

async异步函数可以有很多中写法：

```
async function foo1() {
}

const foo2 = async () => {
}

const foo3 = async function() {
}

class Foo {
  async bar() {
  }
}
```

声明async的函数执行完成才能继续执行后面的语句

### Async 返回值

异步函数有返回值时，和普通函数会有区别：

- 情况一：异步函数也可以有返回值，但是异步函数的返回值会被包裹到Promise.resolve中； 
- 情况二：如果我们的异步函数的返回值是Promise，Promise.resolve的状态会由Promise决定； 
- 情况三：如果我们的异步函数的返回值是一个对象并且实现了thenable，那么会由对象的then方法来决定；

如果我们在async中抛出了异常，那么程序它并不会像普通函数一样报错，而是会作为Promise的reject来传递

## await关键字

async函数另外一个特殊之处就是可以在它内部使用await关键字，而普通函数中是不可以的。 

await关键字有什么特点呢？

- 通常使用await是后面会跟上一个表达式，这个表达式会返回一个Promise； 
- 那么await会等到Promise的状态变成fulfilled状态，之后继续执行异步函数；

如果await后面是一个普通的值，那么会直接返回这个值； 

如果await后面是一个thenable的对象，那么会根据对象的then方法调用来决定后续的值； 

如果await后面的表达式，返回的Promise是reject的状态，那么会将这个reject结果直接作为函数的Promise的 reject值；

```
async function foo() {
  const res1 = await 123
  const res1 = await {
    then: function(resolve, reject) {
      resolve("abc")
    }
  }
  const res1 = await new Promise((resolve) => {
    resolve("why")
  })
  console.log("res1:", res1)
}
```

