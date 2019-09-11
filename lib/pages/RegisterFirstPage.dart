import 'package:flutter/material.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import '../config/Config.dart';
import '../service/ScreenAdaper.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFirstPage extends StatefulWidget {
  RegisterFirstPage({Key key}) : super(key: key);

  _RegisterFirstPageState createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  String tel;

  sendCode() async {
    RegExp reg = new RegExp(r"^1\d{10}$");
    if (reg.hasMatch(this.tel)) {
      var api = '${Config.domain}api/sendCode';
      var response = await Dio().post(api, data: {"tel": this.tel});
      print(response);
      if (response.data["success"]) {
        Navigator.pushNamed(context, "/registerSecond",
            arguments: {"tel": this.tel});
      } else {
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: '手机号格式不对',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("用户注册第一步"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            JdText(
              text: "请输入手机号",
              onChanged: (value) {
                this.tel = value;
              },
            ),
            SizedBox(height: 20),
            JdButton(
                text: "下一步",
                color: Colors.red,
                height: 74,
                cb: sendCode )
          ],
        ),
      ),
    );
  }
}
