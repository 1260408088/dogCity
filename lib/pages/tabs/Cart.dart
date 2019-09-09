import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../../provider/Counter.dart';
import '../../service/ScreenAdaper.dart';
import '../Cart/CartItem.dart';
import '../Cart/CartNum.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("cart");
  }

  @override
  Widget build(BuildContext context) {
    //var counterProvider = Provider.of<Counter>(context);

    var cartProvider = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
      ),
      body: cartProvider.cartList.length > 0
          ? Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Column(
                        children: cartProvider.cartList.map((value) {
                          return CartItem(value);
                        }).toList()),
                    SizedBox(height: ScreenAdaper.height(100))
                  ],
                ),

                Positioned(
                  bottom: 0,
                  width: ScreenAdaper.width(750),
                  height: ScreenAdaper.height(90),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black12)),
                      color: Colors.white,
                    ),
                    width: ScreenAdaper.width(750),
                    height: ScreenAdaper.height(90),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenAdaper.width(60),
                                child: Checkbox(
                                  value:  cartProvider.isCheckedAll,
                                  activeColor: Colors.pink,
                                  onChanged: (val) {
                                    //实现全选或者反选
                                    cartProvider.checkAll(val);
                                  },
                                ),
                              ),
                              Text("全选")
                            ],
                          ),
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(right: 2),
                              child: RaisedButton(
                                child: Text("结算",
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.red,
                                onPressed: () {},
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Text("购物车空空如也"),
            ),
    );
  }
}
