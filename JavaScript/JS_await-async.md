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

