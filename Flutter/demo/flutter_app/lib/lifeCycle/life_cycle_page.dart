

import 'package:flutter/material.dart';
import 'package:flutter_app/lifeCycle/inherited_demo.dart';

void lifeCycleDemo(context) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          LifeCycle(title: '生命周期')));
}

class LifeCycle extends StatelessWidget {
  final String title;
  const LifeCycle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      // body: Center(
      //   child: Text('$title'),
      // ),
      body: InheritedDemo(),
    );
  }
}

class FulLifeCycle extends StatefulWidget {

  final String? title;

  // const FulLifeCycle({Key? key, this.title}) : super(key: key);

  FulLifeCycle({this.title}) {
    print('Widget构造函数被调用了！');
  }

  @override
  State<FulLifeCycle> createState() {
    print('createState来了！');
    return _FulLifeCycleState();
  }
}

class _FulLifeCycleState extends State<FulLifeCycle> {

  int _count = 0;

  _FulLifeCycleState() {
    print('State的构造方法');
  }

  @override
  void initState() {
    print('State的init方法');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('State的build方法被调用了！');
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              _count++;
              setState(() {});
            },
            child: const Icon(Icons.add)),
        Text('$_count')
      ],
    );
  }

  @override
  void dispose() {
    print('State的dispose');
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    print('didChangeDependencies');
    super.didChangeDependencies();
  }
}
