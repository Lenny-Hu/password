import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:html' show document;
import 'package:flutter/services.dart';
import 'package:easyPassword/about.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: new ThemeData(),
      home: new FormPage(),
      //注册路由表
      routes: {
        'about': (context) => AboutPage(),
      } ,
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

  // 控制输入框显示星号还是明文
  bool _pwdObscureText = true;
  bool _saltObscureText = true;

  // 是否添加固定特殊字符下划线
  bool _switchSelected = false;

  String _password;
  String _salt;
  String _selectedType; // 下拉菜单（截取长度）
  Map _typeMap = {
    '10': '前十位(首个字母大写)',
    '6': '前六位数字',
    '0': '全部'
  };
  List<DropdownMenuItem<String>> _typeItems;

  @override
  void initState() { // 相当于vue生命周期的create()
    // TODO: implement initState
    _typeItems = buildAndGetTypeItems(_typeMap); // 获取设置的项
    _selectedType = _typeItems[0].value; // 默认选中第一项
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
      _generatePwd();
    }
  }

  void _generatePwd() {
    String _pwd;
    String _newPwd = '';
    print('密码<$_password>盐<$_salt>');
    var _bytes = utf8.encode(_password + _salt);
    _pwd = sha256.convert(_bytes).toString();

    // 根据type值进行处理
    switch (_selectedType) {
      case '6':
        for (var i = 0; i < _pwd.length; i++) {
          
          if (_newPwd.length >= 6) {
            break;
          }
          if (_pwd[i].contains(new RegExp('\\d'))) {
            _newPwd += _pwd[i];
          }
        }
        break;

      case '10':
        _pwd = _pwd.substring(0, 10);
        var _changed = false;
        for (var i = 0; i < _pwd.length; i++) {
          if (!_changed & _pwd[i].contains(new RegExp('[a-z]'))) {
            _newPwd += _pwd[i].toUpperCase();
            _changed = true;
          } else {
             _newPwd += _pwd[i];
          }
        }
        break;
      default:
        _newPwd = _pwd;
    }

    // 特殊字符
    if (_switchSelected) {
      _newPwd = '_' + _newPwd + '_';
    }

    // 使用输入框展示密码，同时选中输入框中的密码
    TextEditingController _pwdCtrl = TextEditingController();
    _pwdCtrl.text = _newPwd;
    _pwdCtrl.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _pwdCtrl.text.length
    );
    FocusNode focusNode = new FocusNode();

    final snackbar = new SnackBar(
      content: TextField(
        controller: _pwdCtrl,
        focusNode: focusNode,
        enabled: true,
        readOnly: false,
        autofocus: true,
      ),
      onVisible: () {
        // 让密码框获得焦点
        FocusScope.of(context).requestFocus(focusNode);
      },
      action: new SnackBarAction(
          label: '复制',
          onPressed: () {
            // web复制到粘贴板
            document.execCommand('Copy');
            // 客户端复制到粘贴板
            ClipboardData data = new ClipboardData(text: "$_newPwd");
            Clipboard.setData(data);
          }),
    );
    scaffoldKey.currentState.hideCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  // 生成下拉选项
  List<DropdownMenuItem<String>> buildAndGetTypeItems(Map _typeMap) {
    List<DropdownMenuItem<String>> items = new List();
    _typeMap.forEach((k, v) {
      items.add(new DropdownMenuItem(value: k, child: new Text(v)));
    });
    return items;
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
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(20.0),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 700
            ),
            child: new Form(
              key: formKey,
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: [
                      Expanded(
                        child: DropdownButton<String>(
                          icon: Icon(Icons.expand_more),
                          isExpanded: true,
                          value: _selectedType,
                          onChanged: (String newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                          items: _typeItems
                        ),
                      )
                    ]
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: "密码",
                      hintText: "支持中文，首尾空格会被移除",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_pwdObscureText ? Icons.no_encryption : Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            _pwdObscureText = !_pwdObscureText;
                          });
                        }
                      ),
                    ),
                    validator: (val) => val.trim().isEmpty ? '请输入密码' : null,
                    onSaved: (val) => _password = val.trim(),
                    obscureText: _pwdObscureText, // 显示成星号
                    keyboardType: TextInputType.text,
                  ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      labelText: "盐",
                      hintText: "加点盐，生成更安全的密码",
                      prefixIcon: Icon(Icons.assistant_photo),
                      suffixIcon: IconButton( // TODO 此处待优化
                          icon: Icon(_saltObscureText ? Icons.no_encryption : Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              _saltObscureText = !_saltObscureText;
                            });
                          }
                      ),
                    ),
                    validator: (val) => val.trim().isEmpty ? '请输入盐' : null,
                    onSaved: (val) => _salt = val.trim(),
                    obscureText: _saltObscureText, // 显示成星号
                    keyboardType: TextInputType.text, // 好像没啥用
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                  ),
                  new Row(
                    children: <Widget>[
                      Switch(
                        value: _switchSelected,
                        onChanged: (v) {
                          setState(() {
                            _switchSelected = v;
                          });
                        },
                      ),
                      Text('添加特殊字符')
                    ],
                  ),
                  new Row(
                    children: <Widget>[
                      Expanded(
                        child: new RaisedButton(
                          child: new Text(
                            "生 成",
                            style: new TextStyle(color: Colors.white),
                          ),
                          color: Colors.blue,
                          onPressed: _submit,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        )
    );
  }

  // 关于页面
  void _gotoAbout() {
    Navigator.pushNamed(context, 'about');
  }
}
