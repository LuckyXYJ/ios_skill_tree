import 'package:flutter/material.dart';

import '../const.dart';
import '../discover/discover_child_page.dart';
import 'friends_data.dart';
import 'index_bar.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {


  //字典里面放item和高度的对应数据
  final Map _groupOffsetMap = {
    INDEX_WORDS[0]: 0.0,
    INDEX_WORDS[1]: 0.0,
  };

  late ScrollController _scrollController;

  final List<Friends> _listDatas = [];

  @override
  void initState() {
    super.initState();
    //    _listDatas.addAll(datas);
//    _listDatas.addAll(datas);
    _listDatas..addAll(datas)..addAll(datas);
    _listDatas.sort((Friends a, Friends b) {
      return a.indexLetter!.compareTo(b.indexLetter!);
      // return a.name.compareTo(b.name);
    });
    _scrollController = ScrollController();
    var _groupOffset = 54.5 * 4;
    //经过循环计算,将每一个头的位置算出来,放入字典
    for (int i = 0; i < _listDatas.length; i++) {
      if (i < 1) {
        //第一个Cell是有头部的
        _groupOffsetMap.addAll({_listDatas[i].indexLetter: _groupOffset});
        //保存完了再加_groupOffset
        _groupOffset += 84.5;
      } else if (_listDatas[i].indexLetter == _listDatas[i - 1].indexLetter) {
        //此时没有头部,只需要加偏移量就行了!
        _groupOffset += 54.5;
      } else {
        //这部分就是有头部的了
        _groupOffsetMap.addAll({_listDatas[i].indexLetter: _groupOffset});
        _groupOffset += 84.5;
      }
    }
  }

  final List<Friends> _headerData = [
    Friends(imageUrl: 'images/新的朋友.png', name: '新的朋友'),
    Friends(imageUrl: 'images/群聊.png', name: '群聊'),
    Friends(imageUrl: 'images/标签.png', name: '标签'),
    Friends(imageUrl: 'images/公众号.png', name: '公众号'),
  ];

  Widget _itemForRow(BuildContext context, int index) {
    //系统图标的Cell
    if (index < _headerData.length) {
      print(index);
      return _FriendCell(
        imageAssets: _headerData[index].imageUrl,
        name: _headerData[index].name,
      );
    }

    //显示剩下的Cell
    //如果当前和上一个Cell的IndexLetter一样,就不显示
    bool _hideIndexLetter = (index - 4 > 0 &&
        _listDatas[index - 4].indexLetter == _listDatas[index - 5].indexLetter);
    return _FriendCell(
      imageUrl: _listDatas[index - 4].imageUrl,
      name: _listDatas[index - 4].name,
      groupTitle: _hideIndexLetter ? null : _listDatas[index - 4].indexLetter,
    );

    // return _FriendCell(
    //   imageUrl: datas[index - 4].imageUrl,
    //   name: datas[index - 4].name,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WeChatThemeColor,
        title: Text('通讯录'),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              margin: EdgeInsets.only(right: 10),
              child: Image(
                image: AssetImage('images/icon_friends_add.png'),
                width: 25,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DiscoverChildPage(
                    title: '添加朋友',
                  )));
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: WeChatThemeColor,
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _listDatas.length + _headerData.length,
              itemBuilder: _itemForRow,
            ),
          ), //列表
          IndexBar(
            indexBarCallBack: (String str) {
              print(_groupOffsetMap[str]);
              //保证安全,是在我的字典里面的字符
              if (_groupOffsetMap[str] != null) {
                _scrollController.animateTo(
                  _groupOffsetMap[str], //字典中有每个字符的滚动距离,直接拿出来!
                  duration: Duration(microseconds: 100), curve: Curves.easeIn,
                );
              }
            },
          ), //悬浮控件
        ],
      ),
      // body: ListView.builder(
      //   itemCount: datas.length + _headerData.length,
      //   itemBuilder: _itemForRow,
      // )
    );
  }
}

class _FriendCell extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? groupTitle;
  final String? imageAssets;

  const _FriendCell(
      { this.imageUrl, this.name, this.groupTitle, this.imageAssets});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 10),
          height: groupTitle != null ? 30 : 0,
          color: Color.fromRGBO(1, 1, 1, 0.0),
          child: groupTitle != null
              ? Text(
            groupTitle!,
            style: TextStyle(color: Colors.grey),
          )
              : null,
        ), //cell的头
        Container(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    image: DecorationImage(
                      image: (imageUrl != null ?NetworkImage(imageUrl??'') : AssetImage(imageAssets??'')) as ImageProvider<Object>
                      ,
                    )),
              ), //图片
              Container(
                child: Text(
                  name!,
                  style: TextStyle(fontSize: 17),
                ),
              ), //昵称
            ],
          ),
        ), //Cell内容
        Container(
          height: 0.5,
          color: WeChatThemeColor,
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                color: Colors.white,
              )
            ],
          ),
        ) //分割线
      ],
    );
  }
}