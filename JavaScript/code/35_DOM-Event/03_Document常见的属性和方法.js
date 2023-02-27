// 常见的属性
console.log(document.body)
console.log(document.title)
document.title = "Hello World"

console.log(document.head)
console.log(document.children[0])

console.log(window.location)
console.log(document.location)
console.log(window.location === document.location)

// 常见的方法
// 创建元素
const imageEl = document.createElement("img")
const imageEl2 = new HTMLImageElement()

// 获取元素
const divEl1 = document.getElementById("box")
const divEl2 = document.getElementsByTagName("div")
const divEl3 = document.getElementsByName("title")
const divEl4 = document.querySelector(".content")
const divEl5 = document.querySelectorAll(".content")
