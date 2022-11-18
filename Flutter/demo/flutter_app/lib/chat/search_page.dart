import 'package:flutter/material.dart';
import 'package:flutter_app/chat/chat_page.dart';
import 'package:flutter_app/chat/search_bar.dart';


class SearchPage extends StatefulWidget {
  final List<Chat> datas;
  const SearchPage({required this.datas});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Chat> _modals = [];
  String _searchStr = '';

  void _searchData(String text) {
    //每次新的搜索内容一来!我先清空数组!
    _modals.clear();
    _searchStr = text;
    print(text);
    if ((text != null) && text.length > 0) {
      //你有内容我再搜索!
      print('开始搜索');
      for (int i = 0; i < widget.datas.length; i++) {
        String name = widget.datas[i].name;
        if (name.contains(text)) {
          _modals.add(widget.datas[i]);
        }
      }
      print(_modals);
    }
    setState(() {});
  }

  TextStyle _normalStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );
  TextStyle _highlightedStyle = TextStyle(
    fontSize: 16,
    color: Colors.green,
  );
  Widget _title(String name) {
    List<TextSpan> spans = [];
    //剪切出来
    List<String> strs = name.split(_searchStr);
    for (int i = 0; i < strs.length; i++) {
      String str = strs[i];
      if (str == '' && i < strs.length - 1) {
        spans.add(TextSpan(text: _searchStr, style: _highlightedStyle));
      } else {
        spans.add(TextSpan(text: str, style: _normalStyle));
        if (i < strs.length - 1) {
          spans.add(TextSpan(text: _searchStr, style: _highlightedStyle));
        }
      }
    }
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SearchBar(
            onChanged: (String text) {
              _searchData(text);
            },
          ),
          Expanded(
              flex: 1,
              child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: NotificationListener(
                    onNotification: (note) {
                      FocusScope.of(context).requestFocus(FocusNode());
                      return true;
                    },
                    child: ListView.builder(
                      itemCount: _modals.length,
                      itemBuilder: _buildCellForRow,
                    ),
                  )))
        ],
      ),
    );
  }

  Widget _buildCellForRow(BuildContext context, int index) {
    return ListTile(
        title: _title(_modals[index].name),
        subtitle: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(right: 10),
          height: 25,
          child: Text(
            _modals[index].message,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.0),
              image: DecorationImage(
                  image: NetworkImage(_modals[index].imageUrl))),
        ));
  }
}
