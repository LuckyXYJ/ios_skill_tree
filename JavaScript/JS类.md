## class 定义 类

可以使用两种方式来声明类：类声明和类表达式；

```
class Person = {}

var Student = class {

}
```

## 类和构造函数的异同

类的一些特性和我们的构造函数的特性其实是一致的；

![image-20230106230014003](http://xingyajie.oss-cn-hangzhou.aliyuncs.com/uPic/image-20230106230014003.png)

## 类的构造函数

每个类都可以有一个自己的构造函数（方法），这个方法的名称是固定的constructor

当我们通过new操作符，操作一个类的时候会调用这个类的构造函数constructor； 

每个类只能有一个构造函数，如果包含多个构造函数，那么会抛出异常；

调用这个constructor函数，执行如下操作：

1. 在内存中创建一个新的对象（空对象）；
2. 这个对象内部的[[prototype]]属性会被赋值为该类的prototype属性； 
3. 构造函数内部的this，会指向创建出来的新对象； 
4. 执行构造函数的内部代码（函数体代码）； 
5. 如果构造函数没有返回非空对象，则返回创建出来的新对象；

## 类的实例方法

对于实例的方法，我们是希望放到原型上的，这样可以被多个实例来共享； 这个时候我们可以直接在类中定义；

```
class Person {
  constructor(name, age) {
    this.name = name
    this.age = age
  }
  // 普通的实例方法
  // 创建出来的对象进行访问
  // var p = new Person()
  // p.eating()
  eating() {
    console.log(this.name + " eating~")
  }
  running() {
    console.log(this.name + " running~")
  }
}
```

## 类的访问器方法

对象可以添加setter和getter函数的，那么类也是可以的

```
class Person {
  constructor(name, age) {
    this._address = "xxx"
  }

  // 类的访问器方法
  get address() {
    console.log("拦截访问操作")
    return this._address
  }

  set address(newAddress) {
    console.log("拦截设置操作")
    this._address = newAddress
  }
}
```

## 类的静态方法

静态方法通常用于定义直接使用类来执行的方法，不需要有类的实例，使用static关键字来定义

```
class Person {
  constructor(name, age) {
    this.name = name
    this.age = age
    this._address = "广州市"
  }
  
  // 类的静态方法(类方法)
  // Person.createPerson()
  static randomPerson() {
    var nameIndex = Math.floor(Math.random() * names.length)
    var name = names[nameIndex]
    var age = Math.floor(Math.random() * 100)
    return new Person(name, age)
  }
}
```

