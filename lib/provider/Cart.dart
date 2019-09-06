import 'package:flutter/material.dart';
class Cart with ChangeNotifier{
  List _cartList=[]; //状态
  int get cartNum=>this._cartList.length;
  List get cartList=>this._cartList;

  addData(value){
    this._cartList.add(value);
    notifyListeners();
  }

  deleteData(value){
    this._cartList.remove(value);
    notifyListeners();
  }

}