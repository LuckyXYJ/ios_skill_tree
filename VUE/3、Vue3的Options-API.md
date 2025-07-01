## 计算属性computed

对于任何包含响应式数据的复杂逻辑，你都应该使用计算属性；

计算属性将被混入到组件实例中。所有 getter 和 setter 的 this 上下文自动地绑定为组件实例；

 计算属性的用法：

- 选项：computed 
- 类型：{ [key: string]: Function | { get: Function, set: Function } }



### 计算属性案例

我们来看三个案例：

案例一：我们有两个变量：firstName和lastName，希望它们拼接之后在界面上显示；

案例二：我们有一个分数：score

- 当score大于60的时候，在界面上显示及格；
- 当score小于60的时候，在界面上显示不及格；

案例三：我们有一个变量message，记录一段文字：比如Hello World

- 某些情况下我们是直接显示这段文字；
- 某些情况下我们需要对这段文字进行反转；

#### 实现方式：模板语法

```html
<template id="my-app">
  <h2>{{firstName + " " + lastName}}</h2>
  <h2>{{score >= 60 ? '及格': '不及格'}}</h2>
  <h2>{{message.split(" ").reverse().join(" ")}}</h2>
</template>
```

#### 实现方式：methods

```html
<template id="my-app">
  <h2>{{getFullName()}}</h2>
  <h2>{{getResult()}}</h2>
  <h2>{{getReverseMessage()}}</h2>
</template>


<script>
  const App = {
    template: '#my-app',
    data() {
      return {
        firstName: "Kobe",
        lastName: "Bryant",
        score: 80,
        message: "Hello World"
      }
    },
    methods: {
      getFullName() {
        return this.firstName + " " + this.lastName;
      },
      getResult() {
        return this.score >= 60 ? "及格": "不及格";
      },
      getReverseMessage() {
        return this.message.split(" ").reverse().join(" ");
      }
    }
  }

  Vue.createApp(App).mount('#app');
</script>
```



#### 实现方式：计算属性computed

```html
<template id="my-app">
  <h2>{{fullName}}</h2>
  <h2>{{result}}</h2>
  <h2>{{reverseMessage}}</h2>
</template>

<script>
  const App = {
    template: '#my-app',
    data() {
      return {
        firstName: "Kobe",
        lastName: "Bryant",
        score: 80,
        message: "Hello World"
      }
    },
    computed: {
      // 定义了一个计算属性叫fullname
      fullName() {
        return this.firstName + " " + this.lastName;
      },
      result() {
        return this.score >= 60 ? "及格": "不及格";
      },
      reverseMessage() {
        return this.message.split(" ").reverse().join(" ");
      }
    }
  }

  Vue.createApp(App).mount('#app');
</script>
```



### 计算属性 vs methods

计算属性和methods的实现看起来是差别是不大的

区别是计算属性有缓存的：

- 这是因为计算属性会基于它们的依赖关系进行缓存；
- 在数据不发生变化时，计算属性是不需要重新计算的；
- 但是如果依赖的数据发生变化，在使用时，计算属性依然会重新进行计算；

### 计算属性的setter和getter

计算属性在大多数情况下，只需要一个getter方法即可，所以我们会将计算属性直接写成一个函数。

但是，如果我们确实想设置计算属性的值呢？

- 这个时候我们也可以给计算属性设置一个setter的方法；

```javascript
fullName: {
  get: function() {
    return this.firstName + " " + this.lastName;
  },
    set: function(newValue) {
      console.log(newValue);
      const names = newValue.split(" ");
      this.firstName = names[0];
      this.lastName = names[1];
    }
}
```



## 侦听器watch

 什么是侦听器呢？

- 开发中我们在data返回的对象中定义了数据，这个数据通过插值语法等方式绑定到template中；
- 当数据变化时，template会自动进行更新来显示最新的数据；
- 但是在某些情况下，我们希望在代码逻辑中监听某个数据的变化，这个时候就需要用侦听器watch来完成了；



### 侦听器案例

比如现在我们希望用户在input中输入一个问题；

- 每当用户输入了最新的内容，我们就获取到最新的内容，并且使用该问题去服务器查询答案；
- 那么，我们就需要实时的去获取最新的数据变化；

```
<template id="my-app">
    您的问题: <input type="text" v-model="question">
    <!-- <button @click="queryAnswer">查找答案</button> -->
  </template>
  
  watch: {
        // question侦听的data中的属性的名称
        // newValue变化后的新值
        // oldValue变化前的旧值
        question: function(newValue, oldValue) {
          console.log("新值: ", newValue, "旧值", oldValue);
          this.queryAnswer();
        }
      },
      methods: {
        queryAnswer() {
          console.log(`你的问题${this.question}的答案是哈哈哈哈哈`);
          this.anwser = "";
        }
      }
```

### 侦听器watch的配置选项

我们先来看一个例子：

- 当我们点击按钮的时候会修改info.name的值；
- 这个时候我们使用watch来侦听info，可以侦听到吗？答案是不可以。

这是因为默认情况下，watch只是在侦听info的引用变化，对于内部属性的变化是不会做出响应的：

- 这个时候我们可以使用一个选项deep**进行更深层的侦听**；
- 注意前面我们说过watch里面侦听的属性对应的也可以是一个Object；

还有另外一个属性，是希望**一开始的就会立即执行一次：**

- 这个时候我们使用**immediate选项；**
- 这个时候无论后面数据是否有变化，侦听的函数都会有限执行一次；

```javascript
watch: {
  // 默认情况下我们的侦听器只会针对监听的数据本身的改变(内部发生的改变是不能侦听)
  // info(newInfo, oldInfo) {
  //   console.log("newValue:", newInfo, "oldValue:", oldInfo);
  // }

  // 深度侦听/立即执行(一定会执行一次)
  info: {
    handler: function(newInfo, oldInfo) {
      console.log("newValue:", newInfo.nba.name, "oldValue:", oldInfo.nba.name);
    },
      deep: true, // 深度侦听
        // immediate: true // 立即执行
  }
},
```

### 侦听器watch的其他方式

Vue2文档中有提到的是侦听对象的属性：

```
watch: {
        info(newValue, oldValue) {
          console.log(newValue, oldValue);
        },
        "info.name": function(newName, oldName) {
          console.log(newName, oldName);
        },
        "friends[0].name": function(newName, oldName) {
          console.log(newName, oldName);
        }
}
```

另外一种方式就是使用 $watch 的API：

我们可以在created的生命周期中，使用 this.$watchs 来侦听；

- 第一个参数是要侦听的源；
- 第二个参数是侦听的回调函数callback；
- 第三个参数是额外的其他选项，比如deep、immediate；

```
created() {
        const unwatch = this.$watch("info", function(newInfo, oldInfo) {
          console.log(newInfo, oldInfo);
        }, {
          deep: true,
          immediate: true
        })
        // unwatch()
      }
```

