import 'package:flutter/material.dart';
import '../../service/ScreenAdaper.dart';
class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {


  Widget _recProduct() {

    var itemWidth = (ScreenAdaper.getScreenWidth() - 10) / 2;

    return new Container(
      width: itemWidth,
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Image.network(
            "https://www.itying.com/images/flutter/list1.jpg",
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.only(top:20),
            child:Text("188"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Wrap(
        spacing: 10,
        children: <Widget>[
          _recProduct(),
          _recProduct(),
        ],
      ),
    );
  }
}
