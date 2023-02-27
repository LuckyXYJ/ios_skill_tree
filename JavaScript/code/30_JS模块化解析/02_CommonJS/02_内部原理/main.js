const why = require("./why.js")

console.log(why)

setTimeout(() => {
  // console.log(why.name)
  why.name = "james"
}, 1000)
