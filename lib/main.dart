import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      home: new FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => new _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  String _password;
  String _salt;
  String _dropdownValue = "One";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _submit() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      performLogin();
    }
  }

  void performLogin() {
    var _bytes = utf8.encode(_password + _salt);
    var _digest = sha256.convert(_bytes);
//    final snackbar = new SnackBar(
//      content: new Text("盐 : $_salt, 密码 : $_password，加密后 $_digest"),
//    );
    final snackbar = new SnackBar(
      content: new Text('$_digest'),
      action: new SnackBarAction(
          label: '复制',
          onPressed: () {
            // 复制到粘贴版
            ClipboardData data = new ClipboardData(text: "$_digest");
            Clipboard.setData(data);
          }),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text("密码生成器"),
          actions: <Widget>[
            new IconButton(icon: const Icon(Icons.info), onPressed: _gotoAbout),
          ]
        ),
        body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Form(
            key: formKey,
            child: new Column(
              children: <Widget>[
                DropdownButton<String>(
                  value: _dropdownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      _dropdownValue = newValue;
                    });
                  },
                  items: <String>['One', 'Two', 'Free', 'Four']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  })
                  .toList(),
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "密码"),
                  validator: (val) => val.trim() == '' ? '请输入密码' : null,
                  onSaved: (val) => _password = val.trim(),
                ),
                new TextFormField(
                  decoration: new InputDecoration(labelText: "盐"),
                  validator: (val) => val.trim() == '' ? '请输入盐' : null,
                  onSaved: (val) => _salt = val.trim(),
//                  obscureText: true, // 显示成星号
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new RaisedButton(
                  child: new Text(
                    "生成",
                    style: new TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
                  onPressed: _submit,
                ),
              ],
            ),
          ),
        ));
  }

  // 关于页面
  void _gotoAbout() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return new Scaffold(
              appBar: new AppBar(
                title: const Text('关于'),
              ),
              body: new Container(
                // Center the content
                child: new Center(
                  // Add Text
                  child: new Text("使用sha256生成常用的10位、6位密码"),
                ),
              ),
            );
          }
      ),
    );
  }
}
