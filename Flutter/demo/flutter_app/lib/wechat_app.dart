import 'package:flutter/material.dart';
import 'package:flutter_app/root_page.dart';


class WechatApp extends StatelessWidget {
  // const WechatApp({Key key}) : super(key: key);
  const WechatApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // title: 'Flutter Demo',
      theme: ThemeData(
        highlightColor: const Color.fromRGBO(1, 0, 0, 0.0),
        splashColor: const Color.fromRGBO(1, 0, 0, 0.0),
        cardColor: const Color.fromRGBO(1, 1, 1, 0.65),
        primarySwatch: Colors.blue,
      ),
      home: WechatAppRootPage(),
    );
  }
}