import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/demo/key/global_key_demo.dart';


void keyDemo(context) {
  // Navigator.of(context).push(MaterialPageRoute(
  //     builder: (BuildContext context) =>
  //         KeyDemo()));

  Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          GlobalKeyDemo()));
}

class KeyDemoPage extends StatelessWidget {
  final String title;
  const KeyDemoPage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      // body: Center(
      //   child: Text('$title'),
      // ),
      body: KeyDemo(),
    );
  }
}

class KeyDemo extends StatefulWidget {
  const KeyDemo({Key? key}) : super(key: key);
  @override
  _KeyDemoState createState() => _KeyDemoState();
}

class _KeyDemoState extends State<KeyDemo> {
  //key的作用就非常大了！！
  // key与rn中的key类似，决定了复用机制的判断
  List<Widget> items = [
    // StfulItem('1111'),
    // StfulItem('2222'),
    // StfulItem('3333'),
    StfulItem('1111', key: const ValueKey(111)),
    StfulItem('2222', key: const ValueKey(222)),
    StfulItem('3333', key: const ValueKey(333)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('keyDemo'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: items,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            items.removeAt(0);
            // items.add(StfulItem('4444'));
          });
        },
      ),
    );
  }
}

class StfulItem extends StatefulWidget {
  final String title;

  StfulItem(this.title, {Key? key}) : super(key: key);

  @override
  _StfulItemState createState() => _StfulItemState();
}

class _StfulItemState extends State<StfulItem> {
  final color = Color.fromRGBO(
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Text(widget.title),
      color: color,
    );
  }
}

class StlItem extends StatelessWidget {
  final String title;

  StlItem(this.title, {Key? key}) : super(key: key);
  final color = Color.fromRGBO(
      Random().nextInt(256), Random().nextInt(256), Random().nextInt(256), 1.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      child: Text(title),
      color: color,
    );
  }
}