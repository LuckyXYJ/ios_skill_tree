const btns = document.getElementsByTagName('button')

// for (var i = 0; i < btns.length; i++) {
//   (function(n) {
//     btns[i].onclick = function() {
//       console.log("第" + n + "个按钮被点击")
//     }
//   })(i)
// }

// console.log(i)

for (let i = 0; i < btns.length; i++) {
  btns[i].onclick = function() {
    console.log("第" + i + "个按钮被点击")
  }
}

// console.log(i)
