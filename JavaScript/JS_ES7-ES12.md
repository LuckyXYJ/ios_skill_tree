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

