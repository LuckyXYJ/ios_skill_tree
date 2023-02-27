document.addEventListener("click", () => {
  console.log("document被点击")
})

const divEl = document.querySelector("#box")
const spanEl = document.querySelector(".content")

divEl.addEventListener("click", () => {
  console.log("div元素被点击")
})

spanEl.addEventListener("click", () => {
  console.log("span元素被点击")
})


