import 'package:flutter/material.dart';
import '../service/ScreenAdaper.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import 'package:dio/dio.dart';
import '../config/Config.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import '../service/Storage.dart';
import '../service/EventBus.dart';
class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String username='';
  String password='';

  //监听登录页面销毁的事件(页面销毁发送广播，让user的登陆状态刷新)

  dispose(){
    super.dispose();
    eventBus.fire(new UserEvent('登录成功...'));
  }

  doLogin() async{
    RegExp reg = new RegExp(r"^1\d{10}$");
    if (!reg.hasMatch(this.username)) {
      Fluttertoast.showToast(
        msg: '手机号格式不对',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if(password.length<6){
      Fluttertoast.showToast(
        msg: '密码不正确',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }else{
      var api = '${Config.domain}api/doLogin';
      var response = await Dio().post(api, data: {"username": this.username,"password":this.password});
      if (response.data["success"]) {
        print(response.data);
        //保存用户信息
        Storage.setString('userInfo', json.encode(response.data["userinfo"]));

        Navigator.pop(context);

      } else {
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // title: Text("登录页面"),
        actions: <Widget>[
          FlatButton(
            child: Text("客服"),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 30),
                height: ScreenAdaper.width(160),
                width: ScreenAdaper.width(160),
                child: Image.network(
                    'https://www.itying.com/images/flutter/list5.jpg',
                    fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 30),
            JdText(
              text: "请输入用户名",
              onChanged: (value) {
                this.username=value;
              },
            ),
            SizedBox(height: 10),
            JdText(
                text: "请输入密码",
                password: true,
                onChanged: (value) {
                  this.password=value;
                }),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.all(ScreenAdaper.width(20)),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text("忘记密码"),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/registerFirst');
                        },
                        child: Text('新用户注册'),
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 20),
            JdButton(
              text: "登陆",
              color: Colors.red,
              height: 72,
              cb: doLogin,
            )
          ],
        ),
      ),
    );
  }
}
