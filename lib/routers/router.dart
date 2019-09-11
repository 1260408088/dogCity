import 'package:flutter/material.dart';
import '../pages/tabs/Tabs.dart';
import '../pages/Search.dart';
import '../pages/ProductList.dart';
import '../pages/ProductContemt.dart';
import '../pages/tabs/Cart.dart';
import '../pages/Login.dart';
import '../pages/RegisterFirstPage.dart';
import '../pages/RegisterSecondPage.dart';
import '../pages/RegisterThird.dart';
//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/search': (context) => SearchPage(),
  '/productlist' :(context,{arguments}) => ProductList(arguments:arguments),
  '/search': (context) => SearchPage(),
  '/productContent': (context,{arguments}) => ProductContent(arguments:arguments),
  '/cart': (context) => CartPage(),
  '/login': (context) => LoginPage(),
  '/registerFirst':(context) => RegisterFirstPage(),
  '/registerSecond':(context,{arguments})=> RegisterSecondPage(arguments: arguments),
  '/registerThird':(context,{arguments})=> RegisterThirdPage(arguments: arguments),
};

//固定写法
var onGenerateRoute = (RouteSettings settings) {
// 统一处理
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
