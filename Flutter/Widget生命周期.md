## 生命周期

回调函数，通知当前widget所处的状态

生命周期函数作用：

- 初始化数据
  - 常量，变量的创建
  - 网络请求
- 监听小部件事件
- 管理内存
  - 销毁对象，销毁监听者
  - 销毁timer等

## StatelessWidget 生命周期

1. 构造方法
2. build方法

## StatefulWidget生命周期

1. widget构造方法
2. widget的CreateState
3. State的构造方法
4. State的initState方法
5. didChageDependencies 方法 
   1. 依赖的inheritedWidget发生变化后，方法会调用
6. state的build    
   1. 当调用setState方法，会重新调用build进行渲染
      1. setState内部主要是用_element(本质是context对象)调用markNeedsBuild
7. 当Widget销毁的时候，调用State的dispose