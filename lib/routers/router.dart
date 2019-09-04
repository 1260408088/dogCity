import 'package:flutter/material.dart';
import '../pages/tabs/Tabs.dart';
import '../pages/Search.dart';
import '../pages/ProductList.dart';
import '../pages/ProductContemt.dart';
//配置路由
final routes = {
  '/': (context) => Tabs(),
  '/search': (context) => SearchPage(),
  '/productlist' :(context,{arguments}) => ProductList(arguments:arguments),
  '/search': (context) => SearchPage(),
  '/productContent': (context,{arguments}) => ProductContent(arguments:arguments),
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
