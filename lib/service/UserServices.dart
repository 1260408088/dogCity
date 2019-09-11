
import '../service/Storage.dart';
import 'dart:convert';

class UserServices{
  static getUserInfo() async{ // 获得用户信息，获取不到直接赋值为空
    List userinfo;
    try {
      List userInfoData = json.decode(await Storage.getString('userInfo'));
      userinfo = userInfoData;
    } catch (e) {
      userinfo = [];
    }
    return userinfo;
  }
  static getUserLoginState() async{
    var userInfo=await UserServices.getUserInfo();
    if(userInfo.length>0&&userInfo[0]["username"]!=""){
      return true;
    }
    return false;
  }

  static loginOut(){
    Storage.remove('userInfo');
  }
}