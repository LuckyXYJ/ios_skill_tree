## 创建对象

```
// 1.创建方式一: 通过new Object()创建
var obj = new Object()
obj.name = "why"
obj.age = 18
obj.height = 1.88
obj.running = function() {
  console.log(this.name + "在跑步~")
}

// 2.创建方式二: 字面量形式
var info = {
  name: "kobe",
  age: 40,
  height: 1.98,
  eating: function() {
    console.log(this.name + "在吃东西~")
  }
}
```

## 对象属性控制

对属性进行操作时, 进行一些限制。如：不允许某一个属性被赋值/不允许某个属性被删除/不允许某些属性在遍历时被遍历出来

属性描述符：对一个属性进行比较精准的操作控制。可以精准的添加或修改对象的属性；

属性描述符需要使用 ` Object.defineProperty` 来对属性进行添加或者修改；

### Object.defineProperty

Object.defineProperty() 方法会直接在一个对象上定义一个新属性，或者修改一个对象的现有属性，并返回此 对象。

```
    /**
     * Adds a property to an object, or modifies attributes of an existing property.
     * @param o Object on which to add or modify the property. This can be a native JavaScript object (that is, a user-defined object or a built in object) or a DOM object.
     * @param p The property name.
     * @param attributes Descriptor for the property. It can be for a data property or an accessor property.
     */
    defineProperty<T>(o: T, p: PropertyKey, attributes: PropertyDescriptor & ThisType<any>): T;
```

### 属性描述符分类

属性描述符的类型有两种：数据属性（Data Properties）描述符； 存取属性（Accessor访问器 Properties）描述符；

数据属性描述符有如下四个特性： 

- [[Configurable]]：表示属性是否可以通过delete删除属性，是否可以修改它的特性，或者是否可以将它修改为存取属性描述符； 
  - 当我们直接在一个对象上定义某个属性时，这个属性的[[Configurable]]为true； 
  - 当我们通过属性描述符定义一个属性时，这个属性的[[Configurable]]默认为false； 
- [[Enumerable]]：表示属性是否可以通过for-in或者Object.keys()返回该属性； 
  - 当我们直接在一个对象上定义某个属性时，这个属性的[[Enumerable]]为true； 
  - 当我们通过属性描述符定义一个属性时，这个属性的[[Enumerable]]默认为false； 
- [[Writable]]：表示是否可以修改属性的值； 
  - 当我们直接在一个对象上定义某个属性时，这个属性的[[Writable]]为true； 
  - 当我们通过属性描述符定义一个属性时，这个属性的[[Writable]]默认为false；
- [[value]]：属性的value值，读取属性时会返回该值，修改属性时，会对其进行修改； 
  - 默认情况下这个值是undefined；

```
Object.defineProperty(obj, "address", {
  // 很多配置
  value: "北京市", // 默认值undefined
  // 该特殊不可删除/也不可以重新定义属性描述符
  configurable: false, // 默认值false
  // 该特殊是配置对应的属性(address)是否是可以枚举
  enumerable: true, // 默认值false
  // 该特性是属性是否是可以赋值(写入值) 
  writable: false // 默认值false
})
```

存取属性描述符有如下四个特性：

- [[Configurable]]：表示属性是否可以通过delete删除属性，是否可以修改它的特性，或者是否可以将它修改为存取属性 描述符； 
  - 和数据属性描述符是一致的； 
  - 当我们直接在一个对象上定义某个属性时，这个属性的[[Configurable]]为true； 
  - 当我们通过属性描述符定义一个属性时，这个属性的[[Configurable]]默认为false；
- [[Enumerable]]：表示属性是否可以通过for-in或者Object.keys()返回该属性；和数据属性描述符是一致的； 
  - 当我们直接在一个对象上定义某个属性时，这个属性的[[Enumerable]]为true； 
  - 当我们通过属性描述符定义一个属性时，这个属性的[[Enumerable]]默认为false；
- [[get]]：获取属性时会执行的函数。默认为undefined
- [[set]]：设置属性时会执行的函数。默认为undefined

```
// 存取属性描述符
// 1.隐藏某一个私有属性被希望直接被外界使用和赋值
// 2.如果我们希望截获某一个属性它访问和设置值的过程时, 也会使用存储属性描述符
Object.defineProperty(obj, "address", {
  enumerable: true,
  configurable: true,
  get: function() {
    foo()
    return this._address
  },
  set: function(value) {
    bar()
    this._address = value
  }
})
```

### 同时定义多个属性

Object.defineProperties() 方法直接在一个对象上定义 多个 新的属性或修改现有属性，并且返回该对象。

```
Object.defineProperties(obj, {
  name: {
    configurable: true,
    enumerable: true,
    writable: true,
    value: "why"
  },
  age: {
    configurable: true,
    enumerable: true,
    get: function() {
      return this._age
    },
    set: function(value) {
      this._age = value
    }
  }
})
```

## 对象方法补充

获取对象的属性描述符：

- getOwnPropertyDescriptor 
- getOwnPropertyDescriptors

禁止对象扩展新属性：preventExtensions 

- 给一个对象添加新的属性会失败（在严格模式下会报错）；

密封对象，不允许配置和删除属性：seal 

- 实际是调用preventExtensions 
- 并且将现有属性的configurable:false

冻结对象，不允许修改现有属性： freeze 

- 实际上是调用seal 
- 并且将现有属性的writable: false

## JS构造函数

JS中构造函数也是一个普通的函数，从表现形式来说，和千千万万个普通的函数没有任何区别； 

如果这么一个普通的函数被使用new操作符来调用了，那么这个函数就称之为是一个构造函数；

构造函数首字母一般是大写

### new操作符调用的作用

如果一个函数被使用new操作符调用了，那么它会执行如下操作：

1. 在内存中创建一个新的对象（空对象）；
2. 这个对象内部的[[prototype]]属性会被赋值为该构造函数的prototype属性；（后面详细讲）； 
3. 构造函数内部的this，会指向创建出来的新对象； 
4. 执行函数的内部代码（函数体代码）； 
5. 如果构造函数没有返回非空对象，则返回创建出来的新对象；

```
function Person(name, age, height, address) {
  this.name = name
  this.age = age
  this.height = height
  this.address = address

  this.eating = function() {
    console.log(this.name + "在吃东西~")
  }

  this.running = function() {
    console.log(this.name + "在跑步")
  }
}


var p1 = new Person("张三", 18, 1.88, "广州市")
```

构造函数缺点：我们需要为每个对象的函数去创建一个函数对象实例；

解决方案：将这些函数放到Person.prototype的对象上即可；

```
function Person(name, age, height, address) {
  this.name = name
  this.age = age
  this.height = height
  this.address = address
}

Person.prototype.eating = function() {
  console.log(this.name + "在吃东西~")
}

Person.prototype.running = function() {
  console.log(this.name + "在跑步~")
}

var p1 = new Person("why", 18, 1.88, "北京市")
```

## 对象的原型

JavaScript当中每个对象都有一个特殊的内置属性 [[prototype]]，这个特殊的对象可以指向另外一个对象。 

prototype执行对象的作用 

- 当我们通过引用对象的属性key来获取一个value时，它会触发 [[Get]]的操作； 
- 这个操作会首先检查该属性是否有对应的属性，如果有的话就使用它； 
- 如果对象中没有改属性，那么会访问对象[[prototype]]内置属性指向的对象上的属性； 

那么如果通过字面量直接创建一个对象，这个对象也会有这样的属性吗？如果有，应该如何获取这个属性呢？ 

- 答案是有的，只要是对象都会有这样的一个内置属性； 
- 获取的方式有两种： 
  - 方式一：通过对象的 `__proto__` 属性可以获取到（但是这个是早期浏览器自己添加的，存在一定的兼容性问 题）； 
  - 方式二：通过 Object.getPrototypeOf 方法可以获取到；

## 函数的原型 prototype

所有的函数都有一个prototype的属性

```
function foo() {
}

// 函数也是一个对象
// console.log(foo.__proto__) // 函数作为对象来说, 它也是有[[prototype]] 隐式原型

// 函数它因为是一个函数, 所以它还会多出来一个显示原型属性: prototype
console.log(foo.prototype)
```

new关键字创建一个对象时，这个对象内部的[[prototype]]属性会被赋值为该构造函数的prototype属性；

```
function Person() {

}

var p = new Person()

// 以上操作类等同如下操作
p = {}
p.__proto__ = Person.prototype
```

## constructor属性

事实上原型对象上面是有一个属性的：constructor

默认情况下原型上都会添加一个属性叫做constructor，这个constructor指向当前的函数对象；

```
function Person() {}
console.log(Person.prototype.constructor); // [Function: person]
console.log(p.__proto__.constructor); // [Function: person]
console.log(p.__proto__.constructor.name); // Person
```

## 重写原型对象

给prototype重新赋值了一个对象, 那么这个新对象的constructor属性, 会指向Object构造函 数, 而不是Person构造函数了

```
function Person() {}
Person.prototype = {
  name: "why",
  age: 18,
}
```

如果希望constructor指向Person，那么可以手动添加：

```
function Person() {}
Person.prototype = {
	constructor: Person,
  name: "why",
  age: 18,
}
```

以上存在问题：造成constructor的[[Enumerable]]特性被设置了true.

- 默认情况下, 原生的constructor属性是不可枚举的.
- 如果希望解决这个问题, 就可以使用我们前面介绍的Object.defineProperty()函数了.

```
// 真实开发中我们可以通过Object.defineProperty方式添加constructor
Object.defineProperty(Person.prototype, "constructor", {
  enumerable: false,
  configurable: true,
  writable: true,
  value: foo
})
```

## 对象的方法补充

- hasOwnProperty 对象是否有某一个属于自己的属性（不是在原型上的属性）
- in/for in  操作符判断某个属性是否在某个对象或者对象的原型上
- instanceof 用于检测构造函数的pototype，是否出现在某个实例对象的原型链上
- isPrototypeOf 用于检测某个对象，是否出现在某个实例对象的原型链上