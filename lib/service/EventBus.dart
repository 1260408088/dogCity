import 'package:event_bus/event_bus.dart';

// bus 初始化
EventBus eventBus = EventBus();

class ProductContentEvent{
  String str;
  ProductContentEvent(String str){
    this.str=str;
  }
}

//用户中心广播
class UserEvent{
  String str;
  UserEvent(String str){
    this.str=str;
  }
}
