import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../../service/ScreenAdaper.dart';

class CartNum extends StatefulWidget {
  Map _itemData;

  CartNum(this._itemData, {Key key}) : super(key: key);

  _CartNumState createState() => _CartNumState();
}

class _CartNumState extends State<CartNum> {
  Map _itemData;
  var cartProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._itemData = widget._itemData;
  }

  @override
  Widget build(BuildContext context) {
    this.cartProvider = Provider.of<Cart>(context);
    return Container(
      width: ScreenAdaper.width(164),
      decoration:
      BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Row(
        children: <Widget>[
          _leftBtn(),
          _centerArea(),
          _rightBtn()
        ],
      ),
    );
  }

  //左侧按钮

  Widget _leftBtn() {
    return InkWell(
      onTap: () {
        setState(() {
          if (this._itemData["count"] > 1) {
            this._itemData["count"]--;
            this.cartProvider.itemCountChange();
          }
        });
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdaper.width(45),
        height: ScreenAdaper.height(45),
        child: Text("-"),
      ),
    );
  }

  //右侧按钮
  Widget _rightBtn() {
    return InkWell(
      onTap: () {
        //setState(() {  // 加完provider的的通知以后，可以不适用setState来改变数值
          this._itemData["count"]++;
          this.cartProvider.itemCountChange();
        //});
      },
      child: Container(
        alignment: Alignment.center,
        width: ScreenAdaper.width(45),
        height: ScreenAdaper.height(45),
        child: Text("+"),
      ),
    );
  }

//中间
  Widget _centerArea() {
    return Container(
      alignment: Alignment.center,
      width: ScreenAdaper.width(70),
      decoration: BoxDecoration(
          border: Border(
            left: BorderSide(width: 1, color: Colors.black12),
            right: BorderSide(width: 1, color: Colors.black12),
          )),
      height: ScreenAdaper.height(45),
      child: Text("${_itemData["count"]}"),
    );
  }
}