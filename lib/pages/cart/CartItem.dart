import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import '../../provider/Counter.dart';
import './CartNum.dart';
import '../../service/ScreenAdaper.dart';
import '../../provider/Cart.dart';
class CartItem extends StatefulWidget {
  Map _itemData;

  CartItem(this._itemData, {Key key}) : super(key: key);

  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  Map _itemData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._itemData = widget._itemData;
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider=Provider.of<Cart>(context);
//    var countProvider=Provider.of<Counter>(context);
    return Container(
      height: ScreenAdaper.height(200),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Colors.black12)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: ScreenAdaper.width(60),
            child: Checkbox(
              value: _itemData["checked"],
              onChanged: (val) {
                _itemData["checked"] = !_itemData["checked"];
                cartProvider.itemChange();
              },
              activeColor: Colors.pink,
            ),
          ),
          Container(
            width: ScreenAdaper.width(160),
            child: Image.network(
              "${_itemData["pic"]}",
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("${_itemData["title"]}", maxLines: 2),
                    Text("${_itemData["selectedAttr"]}", maxLines: 2),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "￥${_itemData["price"]}",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: CartNum(_itemData),
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
