
import 'package:flutter/material.dart';

class GlobalKeyDemo extends StatelessWidget {

  final GlobalKey<_ChildPageState> _globalKey = GlobalKey();

  GlobalKeyDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GlobalKeyDemo'),
      ),
      body: ChildPage(
        key: _globalKey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _globalKey.currentState!.setState(() {
            _globalKey.currentState!.data =
                'old:' + _globalKey.currentState!.count.toString();
            _globalKey.currentState!.count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChildPage extends StatefulWidget {
  const ChildPage({Key? key}) : super(key: key);

  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> {
  int count = 0;
  String data = 'hello';
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(count.toString()),
          Text(data),
        ],
      ),
    );
  }
}