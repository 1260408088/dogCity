import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../../provider/Counter.dart';
import './CartNum.dart';
import '../../service/ScreenAdaper.dart';
class CartItem extends StatefulWidget {
  CartItem({Key key}) : super(key: key);

  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  @override
  Widget build(BuildContext context) {
//    var cartProvider=Provider.of<Cart>(context);
//    var countProvider=Provider.of<Counter>(context);
    return Container(
      height: ScreenAdaper.height(200),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1,color: Colors.black12)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenAdaper.width(60),
            child: Checkbox(value: true, onChanged: (val){

            },activeColor: Colors.pink,),
          ),
          Container(
            width: ScreenAdaper.width(160),
            child: Image.network("https://www.itying.com/images/flutter/list2.jpg",fit: BoxFit.cover,),
          ),
          Expanded(flex:1,child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("菲特旋转盖轻量杯不锈钢保温杯学生杯商务杯情侣杯保冷杯子便携水杯LHC4131WB(450Ml)白蓝",
                    maxLines: 2),
                Stack(
                  children: <Widget>[
                    Align(alignment: Alignment.centerLeft,
                    child: Text("￥12",style: TextStyle(color:Colors.red),),
                    ),
                    Align(alignment: Alignment.centerRight,
                      child: CartNum(),
                    )
                  ],
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}