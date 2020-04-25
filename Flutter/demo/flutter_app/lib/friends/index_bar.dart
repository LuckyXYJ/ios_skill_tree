import 'package:flutter/material.dart';

import '../const.dart';

class IndexBar extends StatefulWidget {
  final void Function(String str) indexBarCallBack;
  IndexBar({required this.indexBarCallBack});

  @override
  _IndexBarState createState() => _IndexBarState();
}

int getIndex(BuildContext context, Offset globalPosition) {
  //拿到box
  RenderBox box = context.findRenderObject() as RenderBox;
  //拿到y值

  double y = box.globalToLocal(globalPosition).dy;
  //算出字符高度
  var itemHeight = ScreenHeight(context) / 2 / INDEX_WORDS.length;
  //算出第几个item,并且给一个取值范围
  int index = (y ~/ itemHeight).clamp(0, INDEX_WORDS.length - 1);
//  print(INDEX_WORDS[index]);
  return index;
}

class _IndexBarState extends State<IndexBar> {
  Color _bkColor = Color.fromRGBO(1, 1, 1, 0.0);
  Color _textColor = Colors.black;

  double _indicatorY = 0.0;
  String _indicatorText = 'A';
  bool _indecatorHidden = true;

  @override
  Widget build(BuildContext context) {
    List<Widget> words = [];
    for (int i = 0; i < INDEX_WORDS.length; i++) {
      words.add(Expanded(
          child: Text(
            INDEX_WORDS[i],
            style: TextStyle(fontSize: 10, color: _textColor),
          )));
    }
    return Positioned(
        right: 0.0,
        top: ScreenHeight(context) / 8,
        height: ScreenHeight(context) / 2,
        width: 120,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment(0, _indicatorY),
              width: 100,
//              color: Colors.red,
              child: _indecatorHidden
                  ? null
                  : Stack(
                alignment: Alignment(-0.2, 0),
                children: <Widget>[
                  Image(
                    image: AssetImage('images/气泡.png'),
                    width: 60,
                  ),
                  Text(
                    _indicatorText,
                    style: TextStyle(fontSize: 35, color: Colors.white),
                  )
                ],
              ),
            ), //这个是指示器
            GestureDetector(
              child: Container(
                width: 20,
                color: _bkColor,
                child: Column(
                  children: words,
                ),
              ),
              onVerticalDragUpdate: (DragUpdateDetails details) {
                int index = getIndex(context, details.globalPosition);
                widget.indexBarCallBack(INDEX_WORDS[index]);
                _indicatorText = INDEX_WORDS[index];
                _indicatorY = 2.2 / 28 * index - 1.1;
                _indecatorHidden = false;
                setState(() {});
              },
              onVerticalDragDown: (DragDownDetails details) {
                int index = getIndex(context, details.globalPosition);
                widget.indexBarCallBack(INDEX_WORDS[index]);
                setState(() {
                  _indicatorText = INDEX_WORDS[index];
                  _indicatorY = 2.2 / 28 * index - 1.1;
                  _indecatorHidden = false;
                  _bkColor = Color.fromRGBO(1, 1, 1, 0.5);
                  _textColor = Colors.white;
                });
              },
              onVerticalDragEnd: (DragEndDetails details) {
                setState(() {
                  _indecatorHidden = true;
                  _bkColor = Color.fromRGBO(1, 1, 1, 0.0);
                  _textColor = Colors.black;
                });
              },
            ), //这个是索引条
          ],
        ));
  }
}

const INDEX_WORDS = [
  '🔍',
  '☆',
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];
