## VUE引入方式

```html
<!-- CDN引入 -->
<script src="https://cdn.bootcdn.net/ajax/libs/vue/3.3.4/vue.global.prod.js"></script>

<!-- 本地文件引入 -->
<script src="../js/vue.js"></script>
```



## hello Word实现

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
</head>
<body>
  
  <div id="app">
    <h2>Hello World1</h2>
  </div>
	<script src="https://cdn.bootcdn.net/ajax/libs/vue/3.3.4/vue.global.prod.js"></script>
  <script>
    const why = {
      template: '<h2>Hello World</h2>'
    }

    const app = Vue.createApp(why);
    app.mount("#app")
  </script>

</body>
</html>
```



## 计数器实现对比

1、原生实现

```js
			const counterEl = document.querySelector(".counter");
      const incrementEl = document.querySelector(".increment");
      const decrementEl = document.querySelector(".decrement");

      // 2.定义变量
      let counter = 110;
      counterEl.innerHTML = counter;

      // 3.监听按钮的点击
      incrementEl.addEventListener("click", () => {
        counter += 1;
        counterEl.innerHTML = counter;
      });
      decrementEl.addEventListener("click", () => {
        counter -= 1;
        counterEl.innerHTML = counter;
      });
```

2、vue实现

```html
<body>
  
  <div id="app"></div>

  <template id="why">
    <div>
      <h2>{{message}}</h2>
      <h2>{{counter}}</h2>
      <button @click='increment'>+1</button>
      <button @click='decrement'>-1</button>
    </div>
  </template>

  <script src="../js/vue.js"></script>
  <script>
    document.querySelector("#why")
    const App = {
      template: '#why',
      data: function() {
        return {
          message: "Hello World",
          counter: 100
        }
      },
      // 定义各种各样的方法
      methods: {
        increment() {
          console.log("点击了+1");
          this.counter++;
        },
        decrement() {
          console.log("点击了-1");
          this.counter--;
        }
      }
    }
    Vue.createApp(App).mount('#app');

  </script>
</body>
```



## Vue源码

1、在GitHub上搜索 vue-next，下载源代码；

```
git clone git@github.com:vuejs/core.git
```

2、安装Vue源码项目相关的依赖；

执行 yarn install

3、对项目执行打包操作

执行yarn dev（执行前修改脚本）

```
node scripts/dev.js --sourcemap
```

`--sourcemap` 选项的作用是启用源映射（Source Maps）。源映射是一种将编译后的代码映射回源代码的技术，它可以帮助开发者在调试时更方便地查看和分析代码。

具体来说，启用源映射后，浏览器可以将编译后的 JavaScript 代码和原始的 Vue 组件（如 `.vue` 文件）之间建立关联。当你在浏览器的开发者工具中查看代码时，可以直接看到原始的源代码，而不是经过编译和混淆后的代码，这样可以更容易地定位错误和调试。

总之，使用 `--sourcemap` 可以提高开发和调试的效率，使得在生产环境中也可以更好地追踪错误。

4、通过 packages/vue/dist/vue.global.js 调试代码



## template三种写法

1、直接写在template中

```html
<body>
    <div id="app"></div>
    <script src="vue.js"></script>
    <script>
        const why = {
        template: '<h2>Hello World</h2>'
        }
        const app = Vue.createApp(why);
        app.mount("#app")
    </script>
</body>
```

2、使用script标签，并且标记它的类型为 x-template

```html
<body>
    <div id="app"></div>
    <script type="x-template" id="temp">
        <h2>Hello World2</h2>
    </script>
    <script src="vue.js"></script>
    <script>
        const why = {
        template: "#temp"
        }
        const app = Vue.createApp(why);
        app.mount("#app")
    </script>
</body>
```

3、使用任意标签（通常使用template标签，因为不会被浏览器渲染），设置id

```html
<body>
    <div id="app"></div>
    <template id="temp">
        <h2>Hello World3</h2>
    </template>
    <script src="vue.js"></script>
    <script>
        const why = {
        template: "#temp"
        }
        const app = Vue.createApp(why);
        app.mount("#app")
    </script>
</body>
```



