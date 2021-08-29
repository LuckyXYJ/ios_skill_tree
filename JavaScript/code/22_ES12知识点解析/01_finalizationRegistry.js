// ES12: FinalizationRegistry类
const finalRegistry = new FinalizationRegistry((value) => {
  console.log("注册在finalRegistry的对象, 某一个被销毁", value)
})

let obj = { name: "why" }
let info = { age: 18 }

finalRegistry.register(obj, "obj")
finalRegistry.register(info, "value")

obj = null
info = null