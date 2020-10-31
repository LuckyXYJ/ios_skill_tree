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