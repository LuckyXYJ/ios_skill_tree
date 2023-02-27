const spanEl = document.querySelector(".span")
const divEl = document.querySelector(".container")

spanEl.addEventListener("click", () => {
  console.log("事件冒泡:span元素被点击了")
})

divEl.addEventListener("click", () => {
  console.log("事件冒泡:div元素被点击了")
})

document.body.addEventListener("click", () => {
  console.log("事件冒泡:body元素被点击了")
})

// 再次监听
spanEl.addEventListener("click", (event) => {
  console.log("事件捕获:span元素被点击了")
  event.stopPropagation()
}, true)

divEl.addEventListener("click", () => {
  console.log("事件捕获:div元素被点击了")
}, true)

document.body.addEventListener("click", (event) => {
  console.log("事件捕获:body元素被点击了")
}, true)

