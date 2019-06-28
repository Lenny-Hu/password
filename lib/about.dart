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
            new Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("使用Sha256生成常用的10位、6位数字密码，密码和盐的内容支持中文哦，如果系统开启了安全键盘，可点下输入框后的锁按钮切换为明文状态即可输入中文～",
                style: TextStyle(

                ),
              ),
            ),
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
