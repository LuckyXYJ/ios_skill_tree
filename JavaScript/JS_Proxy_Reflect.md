## Proxy类

用于帮助我们创建一个代理的：

- 如果我们希望监听一个对象的相关操作，那么我们可以先创建一个代理对象（Proxy对象）； 
- 之后对该对象的所有操作，都通过代理对象来完成，代理对象可以监听我们想要对原对象进行哪些操作；

```
const obj = {
  name: "xiaoming", // 数据属性描述符
  age: 18
}

const objProxy = new Proxy(obj, {
  // 获取值时的捕获器
  get: function(target, key) {
    console.log(`监听到对象的${key}属性被访问了`, target)
    return target[key]
  },

  // 设置值时的捕获器
  set: function(target, key, newValue) {
    console.log(`监听到对象的${key}属性被设置值`, target)
    target[key] = newValue
  },

  // 监听in的捕获器
  has: function(target, key) {
    console.log(`监听到对象的${key}属性in操作`, target)
    return key in target
  },

  // 监听delete的捕获器
  deleteProperty: function(target, key) {
    console.log(`监听到对象的${key}属性delete操作`, target)
    delete target[key]
  }
})

// in操作符
console.log("name" in objProxy) // 监听到对象的name属性in操作 { name: 'xiaoming', age: 18 } //true

// delete操作
delete objProxy.name // 监听到对象的name属性delete操作 { name: 'xiaoming', age: 18 }
```

### proxy所有的捕获器

- handler.getPrototypeOf()
  - Object.getPrototypeOf 方法的捕捉器。 
- handler.setPrototypeOf()
  - Object.setPrototypeOf 方法的捕捉器。 
- handler.isExtensible()
  - Object.isExtensible 方法的捕捉器。 
- handler.preventExtensions()
  - Object.preventExtensions 方法的捕捉器。 
- handler.getOwnPropertyDescriptor()
  - Object.getOwnPropertyDescriptor 方法的捕捉器。 
- handler.defineProperty()
  - Object.defineProperty 方法的捕捉器。
- handler.ownKeys()
  - Object.getOwnPropertyNames 方法和 Object.getOwnPropertySymbols 方法的捕捉器。
- handler.has()
  - in 操作符的捕捉器。
- handler.get()
  - 属性读取操作的捕捉器。
- handler.set()
  - 属性设置操作的捕捉器。
- handler.deleteProperty()
  - delete 操作符的捕捉器。
- handler.apply()
  - 函数调用操作的捕捉器。
- handler.construct()
  - new 操作符的捕捉器。

### Proxy的construct和apply

它们是应用于函数对象的

```
function foo() {

}

const fooProxy = new Proxy(foo, {
  apply: function(target, thisArg, argArray) {
    console.log("对foo函数进行了apply调用")
    return target.apply(thisArg, argArray)
  },
  construct: function(target, argArray, newTarget) {
    console.log("对foo函数进行了new调用")
    return new target(...argArray)
  }
})

fooProxy.apply({}, ["abc", "cba"])
new fooProxy("abc", "cba")
```

