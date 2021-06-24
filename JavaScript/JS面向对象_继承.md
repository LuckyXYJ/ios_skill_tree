## JavaScript原型链

从一个对象上获取属性，如果在当前对象中没有获取到就会去它的原型上面获取。

从Object直接创建出来的对象的原型都是 [Object: null prototype] {}。

原型链最顶层的原型对象就是Object的原型对象

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

通过原型链即可实现继承

```
// 父类构造方法
function Person() {
  this.name = "why"
  this.friends = []
}
// 父类原型上添加内容
Person.prototype.eating = function() {
  console.log(this.name + " eating~")
}
// 子类构造方法
function Student() {
  this.sno = 111
}
// 创建父类对象，并且作为子类的原型对象
var p = new Person()
Student.prototype = p
// 在子类原型上添加内容
Student.prototype.studying = function() {
  console.log(this.name + " studying~")
}
```

![image-20230105153931902](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230105153931902.png)

原型链继承缺点：某些属性其实是保存在p对象上的

- 我们通过直接打印对象是看不到这个属性的；
- 这个属性会被多个对象共享，如果这个对象是一个引用类型，那么就会造成问题； 
- 不能给Person传递参数，因为这个对象是一次性创建的（没办法定制化）

## 借用构造函数继承

为了解决原型链继承中存在的问题，开发人员提供了一种新的技术: constructor stealing(借用构造函数、经典继承、伪造对象)：

具体方法：在子类型构造函数的内部调用父类型构造函数。因为函数可以在任意的时刻被调用； 因此通过apply()和call()方法也可以在新创建的对象上执行构造函数；

```
function Student(name, age, friends, sno) {
  Person.call(this, name, age, friends)
  this.sno = 111
}
Student.prototype = Person.prototype
```

存在问题：

- 最大的问题就是无论在什么情况下，都会调用两次父类构造函数。 
  - 一次在创建子类原型的时候； 
  - 另一次在子类构造函数内部(也就是每次创建子类实例的时候)； 
- 所有的子类实例事实上会拥有两份父类的 
  - 一份在当前的实例自己里面(也就是person本身的)，另一份在子类对应的原型对象中(也就是 ` person.__proto__`里面)； 
  - 当然，这两份属性我们无需担心访问出现问题，因为默认一定是访问实例本身这一部分的；



## 原型式继承函数

```
function object(obj) {
  function Func() {}
  Func.prototype = obj
  return new Func()
}
function object(obj) {
  var newObj = {}
  Object.setPrototypeOf(newObj, obj)
  return newObj
}
var student = Object.create(person, {
  address: {
    value: "xxx",
    enumerable: true
  }
})
```



## 寄生式继承函数

寄生式继承的思路是结合原型类继承和工厂模式的一种方式；

即创建一个封装继承过程的函数, 该函数在内部以某种方式来增强对象，最后再将这个对象返回；

```
function object(obj) {
  function Func() {}
  Func.prototype = obj
  return new Func()
}
function creatStudent(person) {
  var newObj = object(person)
  newObj.studying = function() {
    console.log(this.name + "studying")
  }
  return newObj
}
```



## 寄生组合继承的代码

```
function object(obj) {
  function Func() {}
  Func.prototype = obj
  return new Func()
}

function inheritPrototype(subType, superType) {
  subType.prototype = object(superType.prototype)
  subType.prototype.console = subType
}

inheritPrototype(Student, Person)
```



