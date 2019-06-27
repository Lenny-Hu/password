import 'package:flutter/material.dart';

void main() => runApp(new AboutPage());

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/flutter.png",),
            Text("使用sha256生成常用的10位、6位密码"),
            Text("by Flutter & Dart")
          ],
        ),
      ),
    );
  }
}
