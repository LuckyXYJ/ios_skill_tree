

import 'package:flutter/material.dart';

class MyData extends InheritedWidget {
  final int data; //需要在子组件中共享的数据（保存点击次数）

  //构造方法
  const MyData({required this.data, required Widget child})
      : super(child: child);

  //定义一个便捷方法，方便子组件中的Widget去获取共享的数据
  static MyData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyData>();
  }

  //该回调决定当前data发生变化时，是否通知子组件依赖data的Widget
  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // 如果返回true,子部件中依赖数据的Widget（build函数中有数据）的didChangeDependencies会调用！
    return (oldWidget as MyData).data != data;
  }
}

class InheritedDemo extends StatefulWidget {
  const InheritedDemo({Key? key}) : super(key: key);

  @override
  State<InheritedDemo> createState() => _InheritedDemoState();
}

class _InheritedDemoState extends State<InheritedDemo> {

  int _counts = 0;

  @override
  Widget build(BuildContext context) {
    return MyData(
        data: _counts,
        child: Column(
          children: [
            Test1(1),
            ElevatedButton(
                onPressed: () {
                  _counts++;
                  setState(() {});
                },
                child: const Text('我是按钮')
            )
          ],
        )
    );
  }
}

class Test1 extends StatelessWidget {
  final int count;
  const Test1(this.count);
  @override
  Widget build(BuildContext context) {
    return Test2(count);
    throw UnimplementedError();
  }
}

class Test2 extends StatelessWidget {
  final int count;
  const Test2(this.count);
  @override
  Widget build(BuildContext context) {
    return Test3(count);
    throw UnimplementedError();
  }
}

class Test3 extends StatefulWidget {
  final int count;
  const Test3(this.count);
  @override
  _Test3State createState() => _Test3State();
}

class _Test3State extends State<Test3> {
  @override
  void didChangeDependencies() {
    print('didChangeDependencies来了');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('哥么我来了！');
    return Text(MyData.of(context)!.data.toString());
  }
}