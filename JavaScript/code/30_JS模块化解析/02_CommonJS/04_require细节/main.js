// 情况一: 核心模块
// const path = require("path")
// const fs = require("fs")

// path.resolve()
// path.extname()

// fs.readFile()

// 情况二: 路径 ./ ../ /
const abc = require("./abc")

// console.log(abc.name)

// 情况三: X不是路径也不是核心模块
const axios = require("axios")

// axios.get()

console.log(module.paths)
