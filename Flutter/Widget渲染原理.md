## Flutter 渲染原理

并不是所有的Widget都会被独立渲染。只有继承RenderObjectWidget的Widget才会创建RenderObject对象！

在Flutter渲染的流程中，有Widget树，Element树，Render树等三棵重要的树。Flutter引擎是针对Render树进行渲染；

三棵重要的树：

- Widget树 -- 区分 StatelessWidget, StateFullWidget
- Element树 -- 区分是否继承 RenderObjectWidget
- Render树 -- 渲染引擎渲染的树

## Render树

- 每一个Widget都会创建一个Element对象
  - 隐式调用createElement方法。Element加入Element树中，都会调用mount方法
  - RenderElement主要创建RenderObject对象。继承RenderObjectWidget的widget会创建RenderElement
    - 创建RenderElement
    - Flutter会调用mount方法，调用createRanderObject方法
  - StatefulElement继承ComponentElement。StatefulWidget会创建 StatefulElement
    - 调用createState方法，创建State
    - 将Widget赋值给state
    - 调用state的build方法，并将自己（Element）传出去。build里面的context就是Widget的Element
  - StatelessElement继承ComponentElement。StatelessWidget会创建 StatelessElement
    - 主要就是调用build方法，并且将自己（Element）传出去

