import 'package:event_bus/event_bus.dart';

// bus 初始化
EventBus eventBus = EventBus();

class ProductContentEvent{
  String str;
  ProductContentEvent(String str){
    this.str=str;
  }
}
