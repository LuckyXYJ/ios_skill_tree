## JSON序列化方法

ES5中引用了JSON全局对象，该对象有两个常用的方法： 

- stringify方法：将JavaScript类型转成对应的JSON字符串； 
- parse方法：解析JSON字符串，转回对应的JavaScript类型；

## stringify

toJSON ： 如果obj对象中有toJSON方法，那么会直接使用toJSON方法的结果：

```
stringify(value: any, replacer?: (this: any, key: string, value: any) => any, space?: string | number): string;
```

- value : 需要转换成json字符串的 数据
- replacer：
  - 传入数组: 设定哪些是需要转换
  - 传入回调函数: ` (key, value) => { retuen value }`。可以根据key返回不同的value
- space
  - 传入number，换行缩进位数
  - 传入string，缩进替换字符

```
const obj = {
  name: "why",
  age: 18,
  friends: {
    name: "kobe"
  },
  hobbies: ["篮球", "足球"],
  // toJSON: function() {
  //   return "123456"
  // }
}

// 1.直接转化
const jsonString1 = JSON.stringify(obj)
console.log(jsonString1)

// 2.stringify第二个参数replacer
// 2.1. 传入数组: 设定哪些是需要转换
const jsonString2 = JSON.stringify(obj, ["name", "friends"])
console.log(jsonString2)

// 2.2. 传入回调函数:
const jsonString3 = JSON.stringify(obj, (key, value) => {
  if (key === "age") {
    return value + 1
  }
  return value
})
console.log(jsonString3)

// 3.stringify第三参数 space
const jsonString4 = JSON.stringify(obj, null, '*')
console.log(jsonString4)
```

## parse方法

```
parse(text: string, reviver?: (this: any, key: string, value: any) => any): any;
```

```
const info = JSON.parse(JSONString, (key, value) => {
  if (key === "age") {
    return value - 1
  }
  return value
})
```

## JSON序列化深拷贝

JSON序列化生成的新对象和之前的对象并不是同一个对象：深拷贝

