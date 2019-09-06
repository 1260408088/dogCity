import 'package:flutter/material.dart';

class Counter with ChangeNotifier{
  int _count=10;
  int get count=> _count;

  incCount(){
    this._count++; // 更新状态
    notifyListeners(); // 表示更新状态
  }
  deleteCount(){
    this._count--;
    notifyListeners();
  }
}