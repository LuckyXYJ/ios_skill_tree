import 'package:flutter/material.dart';
import 'chat/chat_page.dart';
import 'discover/discover_page.dart';
import 'friends/friends_page.dart';
import 'mine/mine_page.dart';

class WechatAppRootPage extends StatefulWidget {
  const WechatAppRootPage({super.key});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<WechatAppRootPage> {
  int _currentIndex = 2;
  final List<Widget> _pages = [const ChatPage(), const FriendsPage(), const DiscoverPage(), const MinePage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedFontSize: 12.0, //默认点击字体变大
        currentIndex: _currentIndex,
        fixedColor: Colors.green,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/tabbar_chat.png',
              height: 20,
              width: 20,
            ),
            activeIcon: Image.asset(
              'images/tabbar_chat_hl.png',
              height: 20,
              width: 20,
            ),
            // ignore: deprecated_member_use
            label: '微信',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/tabbar_friends.png',
              height: 20,
              width: 20,
            ),
            activeIcon: Image.asset(
              'images/tabbar_friends_hl.png',
              height: 20,
              width: 20,
            ),
            // title: Text('通讯录')
            label: '通讯录',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/tabbar_discover.png',
              height: 20,
              width: 20,
            ),
            activeIcon: Image.asset(
              'images/tabbar_discover_hl.png',
              height: 20,
              width: 20,
            ),
            // title: Text('发现')
            label: '发现',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'images/tabbar_mine.png',
              height: 20,
              width: 20,
            ),
            activeIcon: Image.asset(
              'images/tabbar_mine_hl.png',
              height: 20,
              width: 20,
            ),
            // title: Text('我')
            label: '我',
          ),
        ],
      ),
    );
  }
}
