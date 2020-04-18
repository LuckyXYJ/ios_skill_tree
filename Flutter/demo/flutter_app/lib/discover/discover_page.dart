import 'package:flutter/material.dart';

import 'discover_cell.dart';

class DiscoverPage extends StatefulWidget {
  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final Color _themeColor = const Color.fromRGBO(220, 220, 220, 1.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: _themeColor,
          //一下三个是专门为了安卓使用的属性
          centerTitle: true,
          title: const Text('发现'),
          elevation: 0.0, //底部边栏~~~
        ),
        body: Container(
          color: _themeColor,
          height: 800,
          child: ListView(
            children: <Widget>[
              const DiscoverCell(
                imageName: 'images/朋友圈.png',
                title: '朋友圈',
                subTitle: '测试有误',
              ),
              const SizedBox(
                height: 10,
              ),
              const DiscoverCell(
                imageName: 'images/扫一扫2.png',
                title: '扫一扫',
              ),
              Row(
                children: <Widget>[
                  Container(width: 50, height: 0.5, color: Colors.white),
                  Container(height: 0.5, color: Colors.grey)
                ],
              ),
              const DiscoverCell(
                imageName: 'images/摇一摇.png',
                title: '摇一摇',
              ),
              const SizedBox(
                height: 10,
              ),
              const DiscoverCell(
                imageName: 'images/看一看icon.png',
                title: '看一看',
              ),
              Row(
                children: <Widget>[
                  Container(width: 50, height: 0.5, color: Colors.white),
                  Container(height: 0.5, color: Colors.grey)
                ],
              ),
              const DiscoverCell(
                imageName: 'images/搜一搜 2.png',
                title: '搜一搜',
              ),
              const SizedBox(
                height: 10,
              ),
              const DiscoverCell(
                imageName: 'images/附近的人icon.png',
                title: '附近的人',
              ),
              const SizedBox(
                height: 10,
              ),
              const DiscoverCell(
                imageName: 'images/购物.png',
                title: '购物',
                subTitle: '618限时特价',
                subImageName: 'images/badge.png',
              ),
              Row(
                children: <Widget>[
                  Container(width: 50, height: 0.5, color: Colors.white),
                  Container(height: 0.5, color: Colors.grey)
                ],
              ),
              const DiscoverCell(
                imageName: 'images/游戏.png',
                title: '游戏',
              ),
              const SizedBox(
                height: 10,
              ),
              const DiscoverCell(
                imageName: 'images/小程序.png',
                title: '小程序',
              ),
            ],
          ),
        ));
  }
}