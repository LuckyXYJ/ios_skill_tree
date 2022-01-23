const divEl = document.querySelector("#box")


// 常见的属性
console.log(divEl.id)
console.log(divEl.tagName)
console.log(divEl.children)
console.log(divEl.className)
console.log(divEl.classList)
console.log(divEl.clientWidth)
console.log(divEl.clientHeight)
console.log(divEl.offsetLeft)
console.log(divEl.offsetTop)

// 常见的方法
const value = divEl.getAttribute("age")
console.log(value)
divEl.setAttribute("height", 1.88)
