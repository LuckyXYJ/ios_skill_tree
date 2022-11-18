import 'package:flutter/material.dart';
import 'package:flutter_app/chat/search_page.dart';
import '../const.dart';
import 'chat_page.dart';

class SearchCell extends StatelessWidget {
  final List<Chat> datas;
  const SearchCell({required this.datas});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext conext) => SearchPage(
              datas: datas,
            )));
      },
      child: Container(
        height: 45,
        color: WeChatThemeColor,
        padding: EdgeInsets.all(5),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0)),
            ), //白色底
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage('images/放大镜b.png'),
                  width: 15,
                  color: Colors.grey,
                ),
                Text(
                  '  搜索',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                )
              ],
            ), //中间的按钮和文字
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SearchBar({required this.onChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _showClear = false;

  _onChang(String text) {
    widget.onChanged(text);
    if (text.length > 0) {
      setState(() {
        _showClear = true;
      });
    } else {
      setState(() {
        _showClear = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      color: WeChatThemeColor,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 40,
          ), //上半部分
          Container(
            height: 44,
//            color: Colors.red,
            child: Row(
              children: <Widget>[
                Container(
                  width: ScreenWidth(context) - 40,
                  height: 34,
                  margin: EdgeInsets.only(left: 5),
                  padding: EdgeInsets.only(left: 5, right: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  child: Row(
                    children: <Widget>[
                      Image(
                        image: AssetImage('images/放大镜b.png'),
                        width: 20,
                        color: Colors.grey,
                      ), //放大镜
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _controller,
                          onChanged: _onChang,
                          autofocus: true,
                          cursorColor: Colors.green,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.black,
                              fontWeight: FontWeight.w300),
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.only(left: 5, bottom: 10),
                            border: InputBorder.none,
                            hintText: '搜索',
                          ),
                        ),
                      ), //输入框
                      _showClear
                          ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _controller.clear();
                            _onChang('');
                          });
                        },
                        child: Icon(
                          Icons.cancel,
                          size: 20,
                          color: Colors.grey,
                        ),
                      )
                          : Container(), //取消按钮
                    ],
                  ),
                ), //圆角背景
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(' 取消'),
                ) //取消按钮,
              ],
            ),
          ), //下面的搜索条
        ],
      ),
    );
  }
}

