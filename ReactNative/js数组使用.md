## 创建数组

### 方式一

var mycars = new Array();
mycars[0] = "Saab";
mycars[1] = "Volvo";
mycars[2] = "BMW";

### 方式二

var myCars=new Array("Saab","Volvo","BMW");

### 方式三

var myCars=["Saab","Volvo","BMW"];

## 数组使用

### 访问某元素

name = myCars[0];

### 数组长度

const length = myCars.length;

### 添加元素

arr.push(5) //尾部添加一个或多个元素，返回数组数量

arr.unshift(-1); //头部添加一个或多个元素，返回数组数量

### 删除元素

arr.pop(); //删除尾部元素，并返回
arr.shift(); //删除头部元素，并返回

### 拼接字符串

join()
数组的每个元素以指定的字符连接形成新字符串返回;

将一个数组（或一个类数组对象）的所有元素连接成一个字符串并返回这个字符串。如果数组只有一个项目，那么将返回该项目而不使用分隔符(默认使用’,'分隔，如果使用""，则所有元素之间都没有任何字符)。

### 字符串切割

selectList.slice(0, index)

### 判断包括

tempSelectList.indexOf(item.type)

### 合并数组    concat()    

于合并两个或多个数组。此方法不会更改现有数组，而是返回一个新数组。

```
var arr1 = ['a', 'b', 'c', 'd'];
var arr2 = ['e','f']
var arr3 = arr1.concat(arr2);
// arr3数组为: ['a', 'b', 'c', 'd','e','f']
```

### 排序  sort()  

```
var arr = [1,5,2,4,3]
arr.sort()
// arr数组被修改: [1,2,3,4,5]
```

### 翻转数组   reverse() 

将数组中元素的位置颠倒，并返回该数组。数组的第一个元素会变成最后一个，数组的最后一个元素变成第一个。该方法修改原数组

### slice(begin?,end?)，

返回一个新的数组对象，这一对象是一个由 begin 和 end 决定的原数组的浅拷贝（包括 begin，不包括end）。原始数组不会被改变。

### splice(start,deleteCount?,item1?)

通过删除或替换现有元素或者原地添加新的元素来修改数组,并以数组形式返回被修改的内容（如果只删除了一个元素，则返回只包含一个元素的数组。如果没有删除元素，则返回空数组）。此方法修改原数组。

myCars.splice(myCars.length - 1, 0, "nission"); //添加到指定位置
起始位置，替换长度，插入内容

## Js高阶函数

### forEach(function(currentValue，index?,array?),thisValue?)，对数组的每个元素执行一次给定的函数。

currentValue 必选 当前元素的值

index 可选 当前元素的索引值

array 可选 当前元素属于的数组对象

thisValue 可选 执行callback函数时值被用作 this。如果省略或传入null,undefined那么callback函数的this为全局对象

```
function logArrayElements(element, index, array) {
  console.log('a[' + index + '] = ' + element);
}

// 注意索引 2 被跳过了，因为在数组的这个位置没有项
[2, 5, , 9].forEach(logArrayElements);
// logs:
// a[0] = 2
// a[1] = 5
// a[3] = 9
```

### map(function(currentValue，index?,array?),thisValue?)，创建一个新数组，其结果是该数组中的每个元素是调用一次提供的函数后的返回值

```
// 使用 map 重新格式化数组中的对象
var kvArray = [{key: 1, value: 10},
               {key: 2, value: 20},
               {key: 3, value: 30}];

var reformattedArray = kvArray.map(function(obj) {
   var rObj = {};
   rObj[obj.key] = obj.value;
   return rObj;
});

// reformattedArray 数组为： [{1: 10}, {2: 20}, {3: 30}],

// kvArray 数组未被修改:
// [{key: 1, value: 10},
//  {key: 2, value: 20},
//  {key: 3, value: 30}]
```

### filter(function(currentValue,index,arr), thisValue)，创建一个新的数组，新数组中的元素是通过检查指定数组中符合条件的所有元素。

```
// 筛选出字符串数组中长度大于6的字符串
const words = ['spray', 'limit', 'elite', 'exuberant', 'destruction', 'present'];

const result = words.filter(word => word.length > 6);

console.log(result);
// log: ["exuberant", "destruction", "present"]
```

### every(function(currentValue,index,arr), thisValue)，测试一个数组内的所有元素是否都能通过某个指定函数的测试。它返回一个布尔值(若收到一个空数组，此方法在一切情况下都会返回 true)。

```
// 检查是否数组中的所有数字都小于40
const isBelowThreshold = (currentValue) => currentValue < 40;

const array1 = [1, 30, 39, 29, 10, 13];

console.log(array1.every(isBelowThreshold));
// log: true
```

### some(function(currentValue,index,arr), thisValue)，测试数组中是不是至少有1个元素通过了被提供的函数测试。它返回的是一个Boolean类型的值(如果用一个空数组进行测试，在任何情况下它返回的都是false)。

```
// 检测数组中是否至少有一个数字大于 18:
var ages = [3, 10, 18, 20];

function checkAdult(age) {
    return age >= 18;
}

function myFunction() {
    document.getElementById("demo").innerHTML = ages.some(checkAdult);
}
```

### find(function(currentValue,index,arr), thisValue)，返回数组中满足提供的测试函数的第一个元素的值。否则返回 undefined。

```
// 获取数组中第一个大于10的值
const array1 = [5, 12, 8, 130, 44];

const found = array1.find(element => element > 10);

console.log(found);
// expected output: 12
```

###  flat(depth?)，按照一个可指定的深度递归遍历数组，并将所有元素与遍历到的子数组中的元素合并为一个新数组返回。此方法不会改变原数组。

depth 可选 指定要提取嵌套数组的结构深度，默认值为 1。

```
const arr1 = [0, 1, 2, [3, 4]];

console.log(arr1.flat());
// log: [0, 1, 2, 3, 4]

const arr2 = [0, 1, 2, [[[3, 4]]]];

console.log(arr2.flat(2));
// log: [0, 1, 2, [3, 4]]
```

