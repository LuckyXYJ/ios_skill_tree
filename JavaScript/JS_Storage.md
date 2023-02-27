## Storage

WebStorage主要提供了一种机制，可以让浏览器提供一种比cookie更直观的key、value存储方式：

- localStorage：本地存储，提供的是一种永久性的存储方法，在关闭掉网页重新打开时，存储的内容依然保留； 
- sessionStorage：会话存储，提供的是本次会话的存储，在关闭掉会话时，存储的内容会被清除；

localStorage和sessionStorage区别：

1. 关闭网页后重新打开，localStorage会保留，而sessionStorage会被删除； 
2. 在页面内实现跳转，localStorage会保留，sessionStorage也会保留； 
3. 在页面外实现跳转（打开新的网页），localStorage会保留，sessionStorage不会被保留；

## Storage常见的方法和属性

属性： 

- Storage.length：只读属性 
  - 返回一个整数，表示存储在Storage对象中的数据项数量； 

方法： 

- Storage.key()：该方法接受一个数值n作为参数，返回存储中的第n个key名称； 
- Storage.getItem()：该方法接受一个key作为参数，并且返回key对应的value； 
- Storage.setItem()：该方法接受一个key和value，并且将会把key和value添加到存储中。 
  - 如果key存储，则更新其对应的值； 
- Storage.removeItem()：该方法接受一个key作为参数，并把该key从存储中删除； 
- Storage.clear()：该方法的作用是清空存储中的所有key；

## 封装Storage

```js
class HYCache {
  constructor(isLocal = true) {
    this.storage = isLocal ? localStorage: sessionStorage
  }

  setItem(key, value) {
    if (value) {
      this.storage.setItem(key, JSON.stringify(value))
    }
  }

  getItem(key) {
    let value = this.storage.getItem(key)
    if (value) {
      value = JSON.parse(value)
      return value
    } 
  }

  removeItem(key) {
    this.storage.removeItem(key)
  }

  clear() {
    this.storage.clear()
  }

  key(index) {
    return this.storage.key(index)
  }

  length() {
    return this.storage.length
  }
}

const localCache = new HYCache()
const sessionCache = new HYCache(false)

export {
  localCache,
  sessionCache
}
```

## IndexedDB

IndexedDB是一种底层的API，用于在客户端存储大量的结构化数据。

### IndexDB的连接数据库

第一步：打开indexDB的某一个数据库；

- 通过indexDB.open(数据库名称, 数据库版本)方法； 
- 如果数据库不存在，那么会创建这个数据； 
- 如果数据库已经存在，那么会打开这个数据库；

第二步：通过监听回调得到数据库连接结果；

- 数据库的open方法会得到一个IDBOpenDBRequest类型 
- 我们可以通过下面的三个回调来确定结果： 
  - onerror：当数据库连接失败时； 
  - onsuccess：当数据库连接成功时回调； 
  - onupgradeneeded：当数据库的version发生变化并且高于之前版本时回调； 
    - 通常我们在这里会创建具体的存储对象：db.createObjectStore(存储对象名称, { keypath: 存储的主键 }) 
- 我们可以通过onsuccess回调的event获取到db对象：event.target.result

### IndexedDB的数据库操作

我们对数据库的操作要通过事务对象来完成：

- 第一步：通过db获取对应存储的事务 db.transaction(存储名称, 可写操作)； 
- 第二步：通过事务获取对应的存储对象 transaction.objectStore(存储名称)；

增删改查操作了：

- 新增数据 store.add 
- 查询数据 
  - 方式一：store.get(key) 
  - 方式二：通过 store.openCursor 拿到游标对象 
    - 在request.onsuccess中获取cursor：event.target.result 
    - 获取对应的key：cursor.key； 
    - 获取对应的value：cursor.value； 
    - 可以通过cursor.continue来继续执行； 
- 修改数据 cursor.update(value) 
- 删除数据 cursor.delete()

![image-20230203210441067](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230203210441067.png)