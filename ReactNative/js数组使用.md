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