import 'package:flutter/material.dart';
import 'Cart.dart';
import 'Category.dart';
import 'Home.dart';
import 'User.dart';
class Tabs extends StatefulWidget{
  Tabs({Key key}):super(key:key);
  _TabsState createState()=> _TabsState();
}
class _TabsState extends State<Tabs>{

  int _currentIndex=0;

  List _pageList=[
    HomePage(),
    UserPage(),
    CategoryPage(),
    CartPage()
  ];

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        title: Text("狗东商城"),
      ),
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:this._currentIndex ,
        onTap: (index){
          setState(() {
            this._currentIndex=index;
          });
        },
        type:BottomNavigationBarType.fixed ,
        fixedColor:Colors.red,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("首页")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.category),
              title: Text("分类")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text("购物车")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.people),
              title: Text("我的")
          )
        ],
      ),
    );
  }

}