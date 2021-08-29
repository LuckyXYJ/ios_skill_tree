## ES7 - Array Includes

在ES7之前，如果我们想判断一个数组中是否包含某个元素，需要通过 indexOf 获取结果，并且判断是否为 -1。 

在ES7中，我们可以通过includes来判断一个数组中是否包含一个指定的元素，根据情况，如果包含则返回 true， 否则返回false。

```
indexOf(searchElement: T, fromIndex?: number): number;

includes(searchElement: T, fromIndex?: number): boolean;
```

```
const names = ["abc", "cba", "nba", "mba", NaN]
console.log(names.indexOf(NaN)) // -1
console.log(names.includes(NaN)) // true
```

## ES7 –指数(乘方) exponentiation运算符

在ES7之前，计算数字的乘方需要通过 Math.pow 方法来完成。 

在ES7中，增加了 ** 运算符，可以对数字来计算乘方。

```
const result1 = Math.pow(3, 3)
// ES7: **
const result2 = 3 ** 3
console.log(result1, result2)
```

## ES8 Object values

之前我们可以通过 Object.keys 获取一个对象所有的key，在ES8中提供了 Object.values 来获取所有的value值：

```
const obj = {
  name: "why",
  age: 18
}

console.log(Object.keys(obj)) // [ 'name', 'age' ]
console.log(Object.values(obj)) // [ 'why', 18 ]

// 用的非常少
console.log(Object.values(["abc", "cba", "nba"])) // [ 'abc', 'cba', 'nba' ]
console.log(Object.values("abc")) // [ 'a', 'b', 'c' ]
```

## ES8 Object entries

通过Object.entries 可以获取到一个数组，数组中会存放可枚举属性的键值对数组。

```
const obj = {
  name: "why",
  age: 18
}

console.log(Object.entries(obj)) // [ [ 'name', 'why' ], [ 'age', 18 ] ]
const objEntries = Object.entries(obj)
objEntries.forEach(item => {
  console.log(item[0], item[1]) // name why  // age 18
})

console.log(Object.entries(["abc", "cba", "nba"])) //[ [ '0', 'abc' ], [ '1', 'cba' ], [ '2', 'nba' ] ]
console.log(Object.entries("abc")) // [ [ '0', 'a' ], [ '1', 'b' ], [ '2', 'c' ] ]
```

## ES8 - String Padding

某些字符串我们需要对其进行前后的填充，来实现某种格式化效果，ES8中增加了 padStart 和 padEnd 方法，分 别是对字符串的首尾进行填充的。

```
const message = "Hello World"

const newMessage = message.padStart(15, "*").padEnd(20, "-")
console.log(newMessage) // ****Hello World-----
```

## ES8 - Trailing Commas

在ES8中，我们允许在函数定义和调用时多加一个逗号：

```
function foo(m, n,) {
    
}

foo(20, 30,)
```

## ES10 - flat flatMap

flat() 方法会按照一个可指定的深度递归遍历数组，并将所有元素与遍历到的子数组中的元素合并为一个新数组返 回。

flatMap() 方法首先使用映射函数映射每个元素，然后将结果压缩成一个新数组。

注意一：flatMap是先进行map操作，再做flat的操作； 

注意二：flatMap中的flat相当于深度为1；

```
const nums = [10, 20, [2, 9], [[30, 40], [10, 45]], 78, [55, 88]]
console.log(nums.flat()) // [ 10, 20, 2, 9, [ 30, 40 ], [ 10, 45 ], 78, 55, 88 ]
console.log(nums.flat(2)) // [10, 20,  2,  9, 30, 40, 10, 45, 78, 55, 88]

const messages = ["Hello World", "hello lhy", "my name is zxq"]
const words = messages.flatMap(item => {
  return item.split(" ")
})

console.log(words) // ['Hello', 'World', 'hello', 'lhy', 'my', 'name', 'is', 'zxq']
```

## ES10 - Object fromEntries

我们可以通过 Object.entries 将一个对象转换成 entries

ES10提供了 Object.formEntries，可以将entries转化为对象

```
const obj = {
  name: "why",
  age: 18,
  height: 1.88
}

const entries = Object.entries(obj)
console.log(entries)

const newObj = Object.fromEntries(entries)
console.log(newObj)
```

可以用来处理HTTP请求中参数

```
const queryString = 'name=why&age=18&height=1.88'
const queryParams = new URLSearchParams(queryString)
console.log(queryParams)
for (const param of queryParams) {
  console.log(param)
}

const paramObj = Object.fromEntries(queryParams)
console.log(paramObj) // { name: 'why', age: '18', height: '1.88' }
```

## ES10 - trimStart trimEnd

去除一个字符串首尾的空格，我们可以通过trim方法

ES10中给我们提供了trimStart和trimEnd 用来单独去除前面或者后面的空格

```
const message = "    Hello World    "

console.log(message.trim())
console.log(message.trimStart())
console.log(message.trimEnd())
```

## ES11 - BigInt

在早期的JavaScript中，我们不能正确的表示过大的数字： 大于MAX_SAFE_INTEGER的数值，表示的可能是不正确的。

那么ES11中，引入了新的数据类型BigInt，用于表示大的整数： BitInt的表示方法是在数值的后面加上n

```
const maxInt = Number.MAX_SAFE_INTEGER
console.log(maxInt) // 9007199254740991
console.log(maxInt + 1)
console.log(maxInt + 2)

// ES11之后: BigInt
const bigInt = 900719925474099100n
console.log(bigInt + 10n)
```

## ES11 - 空值合并操作符 Nullish Coalescing Operator

ES11，Nullish Coalescing Operator增加了空值合并操作符：

```
const foo = ""
const bar1 = foo || "default value"
const bar2 = foo ?? "defualt value"

console.log(bar1) // "default value"
console.log(bar2) // ""
```

## ES11 - 可选链 Optional Chaining

可选链也是ES11中新增一个特性，主要作用是让我们的代码在进行null和undefined判断时更加清晰和简洁：

```
const info = {
  name: "why",
  // friend: {
  //   girlFriend: {
  //     name: "hmm"
  //   }
  // }
}


// console.log(info.friend.girlFriend.name)
// if (info && info.friend && info.friend.girlFriend) {
//   console.log(info.friend.girlFriend.name)
// }

// ES11提供了可选链(Optional Chainling)
console.log(info.friend?.girlFriend?.name)
```

## ES11 - Global This

在之前我们希望获取JavaScript环境的全局对象，不同的环境获取的方式是不一样的

比如在浏览器中可以通过this.window来获取； 

比如在Node中我们需要通过global来获取；

那么在ES11中对获取全局对象进行了统一的规范：globalThis

```
// 在浏览器下
// console.log(window)
console.log(this)

// 在node下
console.log(global)

// ES11
console.log(globalThis)
```

## ES11 - for..in标准化

在ES11之前，虽然很多浏览器支持for...in来遍历对象类型，但是并没有被ECMA标准化。 

在ES11中，对其进行了标准化，for...in是用于遍历对象的key的：

```
const obj = {
  name: "why",
  age: 18
}

for (const item in obj) {
  console.log(item) // name age
}
```

## ES12 - FinalizationRegistry

FinalizationRegistry 对象可以让你在对象被垃圾回收时请求一个回调。

FinalizationRegistry 提供了这样的一种方法：当一个在注册表中注册的对象被回收时，请求在某个时间点上调用一个清理回调。（清理回调有时被称为 finalizer ）; 

你可以通过调用register方法，注册任何你想要清理回调的对象，传入该对象和所含的值;

```
const finalRegistry = new FinalizationRegistry((value) => {
  console.log("注册在finalRegistry的对象, 某一个被销毁", value)
})

let obj = { name: "why" }
let info = { age: 18 }

finalRegistry.register(obj, "obj")
finalRegistry.register(info, "value")

obj = null  
info = null 

// 注册在finalRegistry的对象, 某一个被销毁 value
// 注册在finalRegistry的对象, 某一个被销毁 obj
```

## ES12 - WeakRefs

如果我们默认将一个对象赋值给另外一个引用，那么这个引用是一个强引用： 

如果我们希望是一个弱引用的话，可以使用WeakRef；

```
let obj = { name: "why" }
let info = new WeakRef(obj)
```

