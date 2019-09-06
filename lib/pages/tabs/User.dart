import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Counter.dart';
class UserPage extends StatefulWidget {
  UserPage({Key key}) : super(key: key);

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    var counterProvider = Provider.of<Counter>(context);
    return Scaffold(
      appBar: AppBar(
        title:Text("用户中心"),
      ),
      body: Center(
        child: Text("${counterProvider.count}"),
      ),
    );
  }
}