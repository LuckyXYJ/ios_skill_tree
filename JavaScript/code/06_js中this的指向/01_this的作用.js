// 从某些角度来说, 开发中如果没有this, 很多的问题我们也是有解决方案
// 但是没有this, 会让我们编写代码变得非常的不方便
var obj100 = {
  name: "why",
  eating: function() {
    console.log(this.name + "在吃东西")
  },
  running: function() {
    console.log(this.name + "在跑步")
  },
  studying: function() {
    console.log(this.name + "在学习")
  }
}

var info = {
  name: "why",
  eating: function() {
    console.log(this.name + "在吃东西")
  },
  running: function() {
    console.log(this.name + "在跑步")
  },
  studying: function() {
    console.log(this.name + "在学习")
  }
}

var person = {
  name: "kobe",
  eating: function() {
    console.log(this.name + "在吃东西")
  },
  running: function() {
    console.log(this.name + "在跑步")
  },
  studying: function() {
    console.log(this.name + "在学习")
  }
}

obj100.eating()
obj100.running()
obj100.studying()

