import 'package:flutter/material.dart';
import 'package:flutter_app/demo/key/key_demo_page.dart';
import 'package:flutter_app/discover/discover_cell.dart';
import 'package:flutter_app/demo/lifeCycle/life_cycle_page.dart';

import '../tools/thread.dart';

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {

  // void lifeCycleDemo() {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (BuildContext context) =>
  //           LifeCycle(title: '生命周期')));
  // }

  Widget headerWidget() {
    return Container(
      color: Colors.white,
      height: 200,
      child: Container(
//        color: Colors.yellow,
        margin: EdgeInsets.only(top: 100, bottom: 20),
//        padding: EdgeInsets.all(10),
        child: Container(
          margin: EdgeInsets.only(left: 30),
//          padding: EdgeInsets.all(5),
//          color: Colors.red,
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: AssetImage('images/photo_icon.png'), fit: BoxFit.cover),
                ),
              ), //头像
              Container(
                margin:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
                width: MediaQuery.of(context).size.width - 95,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        '胖杰',
                        style: TextStyle(fontSize: 25, color: Colors.black),
                      ),
                    ), //昵称
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            '微信号:1234',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Image(
                            image: AssetImage('images/icon_right.png'),
                            width: 15,
                          )
                        ],
                      ),
                    ), //微信号+箭头
                  ],
                ),
              ), //右边的部分
            ],
          ),
        ),
//        padding: ,
      ), //头部
    ); //整个头部
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              color: Color.fromRGBO(220, 220, 220, 1),
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView(
                  children: <Widget>[
                    headerWidget(), //头部
                    SizedBox(
                      height: 10,
                    ),
                    DiscoverCell(
                      imageName: 'images/微信 支付.png',
                      title: '支付',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DiscoverCell(
                      imageName: 'images/微信收藏.png',
                      title: '收藏',
                    ),
                    Row(
                      children: <Widget>[
                        Container(width: 50, height: 0.5, color: Colors.white),
                        Container(height: 0.5, color: Colors.grey)
                      ],
                    ), //分割线
                    DiscoverCell(
                      imageName: 'images/微信相册.png',
                      title: '相册',
                    ),
                    Row(
                      children: <Widget>[
                        Container(width: 50, height: 0.5, color: Colors.white),
                        Container(height: 0.5, color: Colors.grey)
                      ],
                    ), //分割线
                    DiscoverCell(
                      imageName: 'images/微信卡包.png',
                      title: '卡包--key与复用',
                      onPress: ()=>{keyDemo(context)},
                    ),
                    Row(
                      children: <Widget>[
                        Container(width: 50, height: 0.5, color: Colors.white),
                        Container(height: 0.5, color: Colors.grey)
                      ],
                    ), //分割线
                    DiscoverCell(
                      imageName: 'images/微信表情.png',
                      title: '表情--生命周期',
                      onPress: ()=>{lifeCycleDemo(context)},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DiscoverCell(
                      imageName: 'images/微信设置.png',
                      title: '异步操作',
                      onPress: computeTest,
                    ),
                  ],
                ),
              )), //列表
          Container(
            height: 25,
            color: Color.fromRGBO(0, 0, 0, 0),
            margin: EdgeInsets.only(top: 40, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image(
                  image: AssetImage('images/相机.png'),
                )
              ],
            ),
          ), //相机
        ],
      ),
    );
  }
}
