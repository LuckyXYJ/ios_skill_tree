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

## 

