import 'package:flutter/material.dart';

class DiscoverChildPage extends StatelessWidget {
  final String title;
  const DiscoverChildPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Center(
        child: Text('$title'),
      ),
    );
  }
}