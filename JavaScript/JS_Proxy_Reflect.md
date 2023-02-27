## Proxy-代理

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

## Reflect-反射

Reflect也是ES6新增的一个API，它是一个对象，字面的意思是**反射**。

Reflect作用呢？ 

- 它主要提供了很多操作JavaScript对象的方法，有点像Object中操作对象的方法； 
- 比如Reflect.getPrototypeOf(target)类似于 Object.getPrototypeOf()； 
-  比如Reflect.defineProperty(target, propertyKey, attributes)类似于Object.defineProperty() ；

可以将上面Proxy案例中对原对象的操作，都修改为Reflect来操作：

![image-20230201161421236](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230201161421236.png)

### Reflect的常见方法

- Reflect.getPrototypeOf(target) 
  - 类似于 Object.getPrototypeOf()。
- Reflect.setPrototypeOf(target, prototype)
  - 设置对象原型的函数. 返回一个 Boolean， 如果更新成功，则返 回true。
- Reflect.isExtensible(target) 
  - 类似于 Object.isExtensible()
- Reflect.preventExtensions(target) 
  - 类似于 Object.preventExtensions()。返回一个Boolean。
- Reflect.getOwnPropertyDescriptor(target, propertyKey)
  - 类似于 Object.getOwnPropertyDescriptor()。如果对象中存在 该属性，则返回对应的属性描述符, 否则返回 undefined.
- Reflect.defineProperty(target, propertyKey, attributes) 
  - 和 Object.defineProperty() 类似。如果设置成功就会返回 true
- Reflect.ownKeys(target)
  - 返回一个包含所有自身属性（不包含继承属性）的数组。(类似于 Object.keys(), 但不会受enumerable影响).
- Reflect.has(target, propertyKey) 
  - 判断一个对象是否存在某个属性，和 in 运算符 的功能完全相同。
- Reflect.get(target, propertyKey[, receiver]) 
  - 获取对象身上某个属性的值，类似于 target[name]。
- Reflect.set(target, propertyKey, value[, receiver]) 
  - 将值分配给属性的函数。返回一个Boolean，如果更新成功，则返回true。
- Reflect.deleteProperty(target, propertyKey) 
  - 作为函数的delete操作符，相当于执行 delete target[name]。
- Reflect.apply(target, thisArgument, argumentsList)
  - 对一个函数进行调用操作，同时可以传入一个数组作为调用参数。和 Function.prototype.apply() 功能类似。
- Reflect.construct(target, argumentsList[, newTarget]) 
  - 对构造函数进行 new 操作，相当于执行 new target(...args)。

### Receiver的作用

如果我们的源对象（obj）有setter、getter的访问器属性，那么可以通过receiver来改变里面的this；

![image-20230201162549952](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230201162549952.png)

### Reflect的construct

![image-20230201162640560](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230201162640560.png)