# 简单总结手写Promise

## 一. Promise规范

https://promisesaplus.com/



## 二. Promise类设计

```js
class HYPromise {}
```

```js
function HYPromise() {}
```



## 三. 构造函数的规划

```js
class HYPromise {
  constructor(executor) {
   	// 定义状态
    // 定义resolve、reject回调
    // resolve执行微任务队列：改变状态、获取value、then传入执行成功回调
    // reject执行微任务队列：改变状态、获取reason、then传入执行失败回调
    
    // try catch
    executor(resolve, reject)
  }
}
```



## 四. then方法的实现

```js
class HYPromise {
  then(onFulfilled, onRejected) {
    // this.onFulfilled = onFulfilled
    // this.onRejected = onRejected
    
    // 1.判断onFulfilled、onRejected，会给默认值
    
    // 2.返回Promise resolve/reject
    
    // 3.判断之前的promise状态是否确定
    // onFulfilled/onRejected直接执行（捕获异常）
    
    // 4.添加到数组中push(() => { 执行 onFulfilled/onRejected 直接执行代码})
  }
}
```



## 五. catch方法

```js
class HYPromise {
  catch(onRejected) {
    return this.then(undefined, onRejected)
  }
}
```



## 六. finally

```js
class HYPromise {
  finally(onFinally) {
    return this.then(() => {onFinally()}, () => {onFinally()})
  }
}
```



## 七. resolve/reject



## 八. all/allSettled

核心：要知道new Promise的resolve、reject在什么情况下执行

all：

* 情况一：所有的都有结果
* 情况二：有一个reject

allSettled：

* 情况：所有都有结果，并且一定执行resolve



## 九.race/any

race:

* 情况：只要有结果

any:

* 情况一：必须等到一个resolve结果
* 情况二：都没有resolve，所有的都是reject