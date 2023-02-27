import 'package:flutter/material.dart';
import 'package:flutter_app/chat/search_bar.dart';
import '/tools/http_manager.dart' as http;
import '../const.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin {
  Widget _buildPopupMenuItem(String imageAss, String title) {
    return Row(
      children: <Widget>[
        Image(
          image: AssetImage(imageAss),
          width: 20,
        ),
        Container(
          width: 20,
        ),
        Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }

  List<Chat> _datas = [];
  @override
  void initState() {
    super.initState();

    print('Chat的init来了!');
    getDatas().then((List<Chat> datas) {
      print('数据来了!');
      print('更新数据');
      setState(() {
        _datas = datas;
      });
    }).catchError((e) {
      print('拿到了错误$e');
    }).whenComplete(() {
      print('完毕!');
    });
//        .timeout(Duration(microseconds: 6))
//        .catchError((timeout) {
////          _cancleConnect = true;
//          _token.cancel('请求超时了!取消!');
//          print('超时输出:$timeout');
//        });
  }

  Future<List<Chat>> getDatas() async {
    //不再是取消连接了!
//    _cancleConnect = false;
    final response = await http.get(
        'http://rap2api.taobao.org/app/mock/283676/api/chat/list',
        timeOut: 6000);

    if (response.statusCode == 200) {
      //转模型数组 map中遍历的结果需要返回出去
      List<Chat> chatList = response.data['chat_list'].map<Chat>((item) {
        return Chat.fromJson(item);
      }).toList();
      return chatList;
    } else {
      throw Exception('statusCode:${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('微信'),
        backgroundColor: WeChatThemeColor,
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: PopupMenuButton(
              offset: Offset(0, 60.0),
              child: Image(
                image: AssetImage('images/圆加.png'),
                width: 25,
              ),
              itemBuilder: (BuildContext context) {
                return <PopupMenuItem<String>>[
                  PopupMenuItem(
                      child: _buildPopupMenuItem('images/发起群聊.png', '发起群聊')),
                  PopupMenuItem(
                      child: _buildPopupMenuItem('images/添加朋友.png', '添加朋友')),
                  PopupMenuItem(
                      child: _buildPopupMenuItem('images/扫一扫1.png', '扫一扫')),
                  PopupMenuItem(
                      child: _buildPopupMenuItem('images/收付款.png', '收付款')),
                ];
              },
            ),
          ) //右上角按钮
        ],
      ),
      body: Container(
        child: _datas.length == 0
            ? Center(
          child: Text("Loading..."),
        )
            : ListView.builder(
          itemCount: _datas.length + 1,
          itemBuilder: _buildCellForRow,
        ),
      ),
    );
  }

  Widget _buildCellForRow(BuildContext context, int index) {

    if (index == 0) {
      return SearchCell(
        datas: _datas,
      );
    }
    //保证从模型数据正确取数据!从0开始!
    index--;
    return ListTile(
        title: Text(_datas[index].name),
        subtitle: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(right: 10),
          height: 25,
          child: Text(
            _datas[index].message,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              image:
              DecorationImage(image: NetworkImage(_datas[index].imageUrl))),
        ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
/*
  FutureBuilder(
    future: getDatas(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
    //正在加载
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(
    child: Text('Loading...'),
    );
    }
    //加载完毕
    return ListView(
    children: snapshot.data.map<Widget>((item) {
    return ListTile(
    title: Text(item.name),
    subtitle: Container(
    alignment: Alignment.bottomCenter,
    padding: EdgeInsets.only(right: 10),
    height: 25,
    child: Text(
    item.message,
    overflow: TextOverflow.ellipsis,
    ),
    ),
    leading: Container(
    width: 44,
    height: 44,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(6.0),
    image: DecorationImage(
    image: NetworkImage(item.imageUrl))),
    ));
    }).toList(),
    );
    },
    )),
 * */

class Chat {
  final String name;
  final String message;
  final String imageUrl;

  const Chat({required this.name, required this.message, required this.imageUrl});

  factory Chat.fromJson(Map json) {
    return Chat(
      name: json['name'],
      message: json['message'],
      imageUrl: json['image_url'],
    );
  }
}

//关于Map和Json
/*
*
//    final chat = {
//      'name': '张三',
//      'message': '吃了吗?',
//    };
    //Map转Json
//    final chatJson = json.encode(chat);
//    print(chatJson);

    //Json转Map
//    final newChat = json.decode(chatJson);
//    print(newChat['name']);
//    print(newChat['message']);
//    print(newChat is Map);
* */
