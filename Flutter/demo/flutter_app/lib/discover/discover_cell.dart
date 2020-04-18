import 'package:flutter/material.dart';
import 'discover_child_page.dart';

class DiscoverCell extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final String? imageName;
  final String? subImageName;

  const DiscoverCell({super.key,  this.title, this.subTitle, this.imageName, this.subImageName}) :assert(title != null, 'title不能为空');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) =>
                DiscoverChildPage(title: '$title')));
      },
      child: Container(
        color: Colors.white,
        height: 54,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //left
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Image(
                    image: AssetImage(imageName!),
                    width: 20,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(title!),
                ],
              ),
            ),

            //right
            Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  subTitle != null ? Text(subTitle!) : const Text(''),
                  subImageName != null
                      ? Image(
                    image: AssetImage(subImageName!),
                    width: 12,
                  )
                      : Container(),
                  const Image(
                    image: AssetImage('images/icon_right.png'),
                    width: 15,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
