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
            Image.asset(
              "images/flutter.png",
              width: 50.0,
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Text("使用Sha256生成常用的10位、6位数字密码"),
            new Padding(
              padding: const EdgeInsets.only(top: 10.0),
            ),
            Text("by Flutter & Dart")
          ],
        ),
      ),
    );
  }
}
