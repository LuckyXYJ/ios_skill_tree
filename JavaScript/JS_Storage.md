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

