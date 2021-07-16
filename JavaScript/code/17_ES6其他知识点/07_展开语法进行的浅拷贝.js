const info = {
  name: "why",
  friend: { name: "kobe" }
}

const obj = { ...info, name: "coderwhy" }
// console.log(obj)
obj.friend.name = "james"

console.log(info.friend.name)

