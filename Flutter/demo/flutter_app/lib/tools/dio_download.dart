import 'dart:io';

import 'package:dio/dio.dart';

main() {
  dioDemo();
}

void dioDemo() {
  //发送网络请求
  //1.创建dio对象
  final dio = Dio();
  //2.下载数据
  var downloadUrl =
      'http://pub.idqqimg.com/pc/misc/groupgift/fudao/CourseTeacher_1.3.16.80_DailyBuild.dmg';
  //获取temp路径!
  String savePath = Directory.systemTemp.path + '/腾讯课堂.dmg';
  print(savePath);
  download1(dio, downloadUrl, savePath);
}

void download2(Dio dio, String url, String savePath) {
  dio
      .download(url, (header) {
    return savePath;
  }, onReceiveProgress: showDownloadProgress)
      .whenComplete(() => print('完成'))
      .catchError((e) => print(e));
}

void download1(Dio dio, String url, savePath) {
  dio
      .download(url, savePath, onReceiveProgress: showDownloadProgress)
      .then((value) => print(value))
      .whenComplete(() => print('结束了'))
      .catchError((e) => print(e));
}

void showDownloadProgress(received, total) {
  if (total != -1) {
    print((received / total * 100).toStringAsFixed(0) + "%");
  }
}