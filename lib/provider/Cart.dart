import 'package:flutter/material.dart';
import 'dart:convert';
import '../service/Storage.dart';

class Cart with ChangeNotifier {
  List _cartList = []; //状态
  bool _isCheckedAll = false; //状态
  double _allPrice = 0; // 总价
  double get allPrice=> this._allPrice;
  List get cartList => this._cartList;
  bool get isCheckedAll => this._isCheckedAll;
  Cart() {
    this.init();
  }

  //初始化的时候获取购物车数据
  init() async {
    try {
      List cartListData = json.decode(await Storage.getString('cartList'));
      this._cartList = cartListData;
    } catch (e) {
      this._cartList = [];
    }
    // 获取全部选中的状态
    this._isCheckedAll=this.isCheckAll();
    getPriceTotal();
    notifyListeners();
  }

  updateCartList() {
    this.init();
  }

  // 改变购物车中，商品的数量
  itemCountChange() {
    Storage.setString("cartList", json.encode(this._cartList));
    getPriceTotal();
    notifyListeners();
  }

  //全选 反选
  checkAll(value) {
    for (var i = 0; i < this._cartList.length; i++) {
      this._cartList[i]["checked"] = value;
    }
    this._isCheckedAll = value;
    Storage.setString("cartList", json.encode(this._cartList));
    getPriceTotal();
    notifyListeners();
  }

  // 判断是否全部选中
  bool isCheckAll() {
    if (this._cartList.length > 0) {
      for (var i = 0; i < this._cartList.length; i++) {
        if (this._cartList[i]["checked"] == false) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  // 监听每一项的选中事件
  itemChange() {
    if (this.isCheckAll() == true) {
      this._isCheckedAll = true;
    } else {
      this._isCheckedAll = false;
    }
    Storage.setString("cartList", json.encode(this._cartList));
    getPriceTotal();
    notifyListeners();
  }

  // 计算总价
  getPriceTotal(){
    double tempAllPrice = 0;
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == true) {
        tempAllPrice += this._cartList[i]["price"] * this._cartList[i]["count"];
      }
    }
    this._allPrice = tempAllPrice;
    notifyListeners();
  }
  // 删除选中的购物车条目
  removeItem(){
    // 不可直接删除,迂回，得到不删除的，再进行赋值就阔以了
    List tempList=[];
    for (var i = 0; i < this._cartList.length; i++) {
      if (this._cartList[i]["checked"] == false) {
        tempList.add(this._cartList[i]);
      }
    }

    this._cartList=tempList;
    //计算总价
    this.getPriceTotal();
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

  // 删除状态下，要将所有的设置为全不选中
  notCheckAll() {
    for (var i = 0; i < this._cartList.length; i++) {
      this._cartList[i]["checked"] = false;
    }
    this._isCheckedAll = false;
    Storage.setString("cartList", json.encode(this._cartList));
    notifyListeners();
  }

}
