/*
          1、获取本地存储里面的数据  (searchList)

          2、判断本地存储是否有数据

              2.1、如果有数据

                    1、读取本地存储的数据
                    2、判断本地存储中有没有当前数据，
                        如果有不做操作、
                        如果没有当前数据,本地存储的数据和当前数据拼接后重新写入


              2.2、如果没有数据

                    直接把当前数据放在数组中写入到本地存储
      */
import 'dart:convert';
import 'Storage.dart';

class SearchServices {
  static setHistoryDate(keywords) async{
    // 这个方法的问题，获取为空会报错，所以要try catch一下
    try{
      List searchListData = json.decode(await Storage.getString('searchList'));
      var hasDate=searchListData.any((v){ // 这是一个方法有返回值的，直接返回给了hasData
        return v==keywords;
      });
      if(!hasDate){ // 存在就放进去
        searchListData.add(keywords);
        await Storage.setString('search', json.encode(searchListData));
      }
    }catch(e){ //
      List tempList = new List();
      tempList.add(keywords);
      await Storage.setString('searchList', json.encode(tempList));
    }
  }

  static getHistoryList() async{
    try{
      List searchListData = json.decode(await Storage.getString('searchList'));
      return searchListData;
    }catch(e){
      return[];
    }
  }
  static clearHistoryList() async{
    await Storage.remove('searchList');
  }

  static removeHistoryData(keywords) async{
    List searchListData = json.decode(await Storage.getString('searchList'));
    searchListData.remove(keywords);
    await Storage.setString('searchList', json.encode(searchListData));
  }
}