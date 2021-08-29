// ES11: 空值合并运算 ??

const foo = ""
const bar1 = foo || "default value"
const bar2 = foo ?? "defualt value"

console.log(bar1)
console.log(bar2)

// ts 是 js 的超级
