const info = {
  name: "why",
  // friend: {
  //   girlFriend: {
  //     name: "hmm"
  //   }
  // }
}


// console.log(info.friend.girlFriend.name)
if (info && info.friend && info.friend.girlFriend) {
  console.log(info.friend.girlFriend.name)
}

// ES11提供了可选链(Optional Chainling)
console.log(info.friend?.girlFriend?.name)

console.log('其他的代码逻辑')

