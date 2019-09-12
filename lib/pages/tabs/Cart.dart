import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gou_dong_store/provider/CheckOut.dart';
import '../../provider/Cart.dart';
import '../../service/ScreenAdaper.dart';
import '../../service/CartServices.dart';
import '../../service/UserServices.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Cart/CartItem.dart';
import 'dart:convert';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEdit=false;
  var checkOutProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("cart");
  }

  doCheckOut() async{
    //1、获取购物车选中的数据
    List checkOutData = await CartServices.getCheckOutData();
    print("----------------------------------${checkOutData}");
    //2、保存购物车选中的数据
    //this.checkOutProvider.changeCheckOutListData(checkOutData);
    //3、购物车有没有选中的数据
    if (checkOutData.length > 0) {
      //4、判断用户有没有登录
      var loginState = await UserServices.getUserLoginState();
      if (loginState) {
        Navigator.pushNamed(context, '/Text',arguments:{"flag":1234});
        // Navigator.pushNamed(context, '/Text');

      } else {
        Fluttertoast.showToast(
          msg: '您还没有登录，请登录以后再去结算',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.pushNamed(context, '/login');
      }
    } else {
      Fluttertoast.showToast(
        msg: '购物车没有选中的数据',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    //var counterProvider = Provider.of<Counter>(context);
    var cartProvider = Provider.of<Cart>(context);
    //checkOutProvider = Provider.of<CheckOut>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.launch),
            onPressed: (){
              setState(() {
                this._isEdit=!this._isEdit;
                cartProvider.notCheckAll();
              });
            },
          )
        ],
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
                              Text("全选"),
                              SizedBox(width: 20),
                              this._isEdit==false?Text("合计:"):Text(""),
                              Container(
                                padding: EdgeInsets.only(left:5),
                                child: this._isEdit==false?Text("${cartProvider.allPrice}",style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.red
                                )):Text(""),
                              )
                            ],
                          ),
                        ),
                        this._isEdit==false?Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.only(right: 2),
                              child: RaisedButton(
                                child: Text("结算",
                                    style: TextStyle(color: Colors.white)),
                                color: Colors.red,
                                onPressed:doCheckOut,
                              ),
                            )):
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            child: Text("删除",
                                style: TextStyle(color: Colors.white)),
                            color: Colors.red,
                            onPressed: () {
                              cartProvider.removeItem();
                            },
                          ),)
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
