
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ScreenAdaper{ // 屏幕适配器

  static init(context){
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
  }
  static height(double value){
     return ScreenUtil.getInstance().setHeight(value);
  }
  static width(double value){
      return ScreenUtil.getInstance().setWidth(value);
  }
  static getScreenHeight(){
    return ScreenUtil.screenHeightDp;
  }
  static getScreenWidth(){
    return ScreenUtil.screenWidthDp;
  }
}
