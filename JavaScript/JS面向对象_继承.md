## JavaScript原型链

从一个对象上获取属性，如果在当前对象中没有获取到就会去它的原型上面获取。通过原型链即可实现继承

从Object直接创建出来的对象的原型都是 [Object: null prototype] {}。

[Object: null prototype] {} 原型的原型属性已经指向的是null，也就是已经是顶层原型了

```
var obj = {
  name: "why",
  age: 18
}
obj.__proto__ = {
  address: "北京市"
}
console.log(obj.address) // 北京市
console.log(obj.__proto__.__proto__) // [Object: null prototype] {}
console.log(obj.__proto__.__proto__.__proto__) // null
```

