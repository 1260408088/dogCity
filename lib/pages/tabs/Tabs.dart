import 'package:flutter/material.dart';
import '../../service/ScreenAdaper.dart';
import 'Cart.dart';
import 'Category.dart';
import 'Home.dart';
import 'User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    this._pageController = new PageController(initialPage: this._currentIndex);
  }

  int _currentIndex = 0;

  List<Widget> _pageList = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return new Scaffold(
//      appBar:_currentIndex!=3?:AppBar(
//        title: Text("用户中心"),
//      ),
      body: PageView(
        controller: this._pageController,
        children: this._pageList,
        onPageChanged: (index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        // physics: NeverScrollableScrollPhysics(), //禁止pageView滑动
      ), // this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (index) {
          setState(() {
            this._currentIndex = index;
            this._pageController.jumpToPage(index);
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text("首页")),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), title: Text("分类")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), title: Text("购物车")),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text("我的"))
        ],
      ),
    );
  }

/*
  *
  * IndexedStack( // 切换页面状态的一种方法，但不适于精确的页面控制，在商城项目中不太适用（购物车模块需要更新的，但是，此种方法的加载是一次加载所有的页面）
        index: this._currentIndex,
        children: _pageList,
      ),
  */
}
