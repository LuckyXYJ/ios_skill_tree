## 响应式

自动响应数据变量的代码机制，我们就称之为是响应式的。

简单实现：将数据变化后需要执行的代码加入函数数组中，数据变化后，执行数组中函数

```js
let reactiveFns = []
function watchFn(fn) {
  reactiveFns.push(fn)
}

// 对象的响应式
const obj = {
  name: "why",
  age: 18
}

watchFn(function() {
  const newName = obj.name
  console.log("Hello World")
})

function bar() {
  console.log("这个函数不需要有任何响应式")
}

obj.name = "kobe"
reactiveFns.forEach(fn => {
  fn()
})
```

简单实现封装

```
class Depend {
  constructor() {
    this.reactiveFns = []
  }

  addDepend(reactiveFn) {
    this.reactiveFns.push(reactiveFn)
  }

  notify() {
    this.reactiveFns.forEach(fn => {
      fn()
    })
  }
}
```

## 监听对象的变化

通过 Object.defineProperty的方式（vue2采用的方式）；

通过new Proxy的方式（vue3采用的方式）；

```
const objProxy = new Proxy(obj, {
  get: function(target, key, receiver) {
    return Reflect.get(target, key, receiver)
  },
  set: function(target, key, newValue, receiver) {
    Reflect.set(target, key, newValue, receiver)
    depend.notify()
  }
})
```

## 对象的依赖管理

以上简单实现创建了一个Depend对象，用来管理对于name变化需要监听的响应函数： 

但是实际开发中我们会有不同的对象，另外会有不同的属性需要管理。需要使用一种数据结构来管理不同对象的不同依赖关系

![image-20230201173524463](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230201173524463.png)

可以写一个getDepend函数专门来管理这种依赖关系：

```
// 封装一个获取depend函数
const targetMap = new WeakMap()
function getDepend(target, key) {
  // 根据target对象获取map的过程
  let map = targetMap.get(target)
  if (!map) {
    map = new Map()
    targetMap.set(target, map)
  }

  // 根据key获取depend对象
  let depend = map.get(key)
  if (!depend) {
    depend = new Depend()
    map.set(key, depend)
  }
  return depend
}
```
### 收集依赖

如果一个函数中使用了某个对象的key，那么它应该被收集依赖；

```js
// 监听对象的属性变量: Proxy(vue3)/Object.defineProperty(vue2)
const objProxy = new Proxy(obj, {
  get: function(target, key, receiver) {
    const depend = getDepend(target, key)
    // 给depend对象中添加响应函数
    depend.addDepend(activeReactiveFn)

    return Reflect.get(target, key, receiver)
  },
  set: function(target, key, newValue, receiver) {
    Reflect.set(target, key, newValue, receiver)
    const depend = getDepend(target, key)
    depend.notify()
  }
})
```

### 对depend重构

存在问题：

- 如果函数中有用到两次key，比如name，那么这个函数会被收集两次； 
- 我们并不希望将添加reactiveFn放到get中，以为它是属于Dep的行为；

解决方案：

- 不使用数组，而是使用Set；
- 添加一个新的方法，用于收集依赖；

```
class Depend {
  constructor() {
    this.reactiveFns = new Set()
  }
  
  depend() {
    if (activeReactiveFn) {
      this.reactiveFns.add(activeReactiveFn)
    }
  }

  notify() {
    this.reactiveFns.forEach(fn => {
      fn()
    })
  }
}
```

## 创建响应式对象

以上是针对于obj一个对象的，我们可以创建出来一个函数，针对所有的对象都可以变成响应式对象：

```
function reactive(obj) {
  return new Proxy(obj, {
    get: function(target, key, receiver) {
      // 根据target.key获取对应的depend
      const depend = getDepend(target, key)
      // 给depend对象中添加响应函数
      // depend.addDepend(activeReactiveFn)
      depend.depend()
  
      return Reflect.get(target, key, receiver)
    },
    set: function(target, key, newValue, receiver) {
      Reflect.set(target, key, newValue, receiver)
      // depend.notify()
      const depend = getDepend(target, key)
      depend.notify()
    }
  })
}
```

使用：

```
const infoProxy = reactive({
  address: "广州市",
  height: 1.88
})

watchFn(() => {
  console.log(infoProxy.address)
})

infoProxy.address = "北京市"
```

Vue2响应式原理

```
function reactive(obj) {
  // {name: "why", age: 18}
  // ES6之前, 使用Object.defineProperty
  Object.keys(obj).forEach(key => {
    let value = obj[key]
    Object.defineProperty(obj, key, {
      get: function() {
        const depend = getDepend(obj, key)
        depend.depend()
        return value
      },
      set: function(newValue) {
        value = newValue
        const depend = getDepend(obj, key)
        depend.notify()
      }
    })
  })
  return obj
}
```

