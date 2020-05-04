import 'dart:async';
import 'dart:io';

import 'dart:isolate';

import 'package:flutter/foundation.dart';

String _data = '0';

void computeTest() {
  print('外部代码1');

  compute(func2, 100000000000).then((value) => print(value));

  print('外部代码2');
}

int func2(int count) {
  print('外部代码3');
  sleep(Duration(seconds: 1));
  return 10000;
}

void test1() async {
  print('外部代码1');
  //创建Port
  ReceivePort port = ReceivePort();
  //创建isolate
  Isolate iso = await Isolate.spawn(func, port.sendPort);
  port.listen((message) {
    print(a);
    a = message;
    print(a);
    port.close();
    iso.kill();
  });

  //创建Port
  ReceivePort port1 = ReceivePort();
  Isolate iso1 = await Isolate.spawn(func1, port1.sendPort);
  port1.listen((message) {
    print(a);
    a = message;
    print(a);
    port.close();
    iso.kill();
  });

  Future(() {
    print('任务2');

    sleep(Duration(seconds: 1));
    return '任务2';
  });

  Future((){
    sleep(Duration(seconds: 1));
    print('h很是期待');
  });
  print('回来之后的A是$a');
  print('外部代码2');
}

int a = 10;

void func(SendPort send) {
  print('第一个来了!!');
  send.send(1000);
}
void func1(SendPort send) {
  print('第一个来了!!');
  send.send(10001);
}


void testFuture4() {
  Future x1 = Future(() => null);
  x1.then((value) {
    print('6');
    scheduleMicrotask(() => print('7'));
  }).then((value) => print('8'));

  Future x = Future(() => print('1'));
  x.then((value) {
    print('4');
    Future(() => print('9'));
  }).then((value) => print('10'));

  Future(() => print('2'));

  scheduleMicrotask(() => print('3'));

  print('5');
}

void testFuture3() {
  print('外部代码1');
  Future(() => print('A')).then((value) => print('A结束'));
  Future(() => print('B')).then((value) => print('B结束'));

  scheduleMicrotask(() {
    print('微任务A');
  });
  sleep(Duration(seconds: 1));
  print('外部代码2');
}

void testFuture2() {
  Future.wait([
    Future(() {
      print('任务1');
      return '任务1';
    }),
    Future(() {
      print('任务2');
      sleep(Duration(seconds: 1));
      return '任务2';
    })
  ]).then((value) => print(value[0] + value[1]));
}

//then 比Future默认的队列优先级高!!
void testFuture() {
  Future(() {
    sleep(Duration(seconds: 1));
    return '任务1';
  })
      .then((value) {
    print('$value结束');
    // throw Exception('异常');
  })
      .then((value) {
    print('$value结束');
    return '任务2';
  })
      .then((value) {
    print('$value结束');
    return '任务3';
  })
      .then((value) => print('$value结束'))
      .catchError((e) => print(e));

  print('任务添加完毕');
}

void getData() async {
  print('开始data = $_data');
  //1.后面的操作必须是异步才能用await
  //2.当前函数必须是异步函数
  Future future = Future(() {
    //耗时操作
    for (int i = 0; i < 1000000000; i++) {}
//    throw Exception('网络异常');
    return '哈哈';
  });

  //处理错误
  future.then((value) {
    print('then  来了!!');
    print(value);
  }).catchError((e) {
    print('捕获到了:' + e.toString());
  }).whenComplete(() {
    print('完成了!');
  });

  //使用then来接收数据
//  future.then((value) {
//    print('then  来了!!');
//    print(value);
//  }, onError: (e) {
//    print(e.toString());
//  });

  print('干点其他的事情!');
}

getDatas() async {
  print('开始data=$_data');

  thenFunc(value) {
    print('then 进来了!');
    print('结束data=$value');
  }

  errorFunc(e) {
    print('error来了');
    print('捕获到了:' + e.toString());
  }

  Future future = Future(() {
    //耗时操作
    //1.后面的操作必须是异步才能用await修饰
    //2.当前行数也必须是异步函数
//    for (int i = 0; i < 1000000000; i++) {}
    sleep(Duration(seconds: 2)); //确定时间!
  })
      .then((value) {
    print('then 进来了!');
    print('结束data=$value');
  })
      .catchError(errorFunc)
      .whenComplete(() {
    print('完成了!');
  });

  print('再多干点事情');
}
