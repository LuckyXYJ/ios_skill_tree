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
7. 当Widget销毁的时候，调用State的dispose