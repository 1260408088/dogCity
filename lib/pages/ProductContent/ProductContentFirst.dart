import 'package:flutter/material.dart';
import '../../service/ScreenAdaper.dart';
import '../../widget/JdButton.dart';
import '../../model/ProductContentModel.dart';
import '../../config/Config.dart';
import '../../service/EventBus.dart';
import './CartNum.dart';
import '../../service/CartServices.dart';
import 'package:provider/provider.dart';
import '../../provider/Cart.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ProductContentFirst extends StatefulWidget {
  final List _productContentList;
  ProductContentFirst(this._productContentList,{Key key}) : super(key: key);
  _ProductContentFirstState createState() => _ProductContentFirstState();
}

class _ProductContentFirstState extends State<ProductContentFirst> with AutomaticKeepAliveClientMixin{
  bool get wantKeepAlive =>true;
  ProductContentitem _productContent;
  var cartProvider;
  // 广播监听
  var actionEventBus;
  List _attr = []; // 商品的属性
  String _selectedValue; // 商品的选中属性
  @override
  void initState() {
    super.initState();
    this._productContent=widget._productContentList[0];
    this._attr=this._productContent.attr;

    _initAttr();
    //监听广播
    //监听所有广播
    // eventBus.on().listen((event) {
    //   print(event);
    //   this._attrBottomSheet();
    // });
    // 监听底部的加入购物车按钮
    this.actionEventBus=eventBus.on<ProductContentEvent>().listen((str) {
      print(str);
      this._attrBottomSheet();
    });
  }

  //销毁
  void dispose(){
    super.dispose();
    this.actionEventBus.cancel();  //取消事件监听
  }

  _initAttr(){ //给数据添加一个"checked"的字段
    var attr=this._attr;
    for(var i=0;i<attr.length;i++){
      for(var j=0;j<attr[i].list.length;j++){
        if(j==0){
          attr[i].attrList.add({"title":attr[i].list[j],"checked":true});
        }else{
          attr[i].attrList.add({"title":attr[i].list[j],"checked":false});
        }
      }
    }
    _getSelectAttrValue();
  }

  //改变属性值
  _changeAttr(cate, title, setBottomState) {
    var attr = this._attr;
    for (var i = 0; i < attr.length; i++) {
      if (attr[i].cate == cate) {
        for (var j = 0; j < attr[i].attrList.length; j++) {
            attr[i].attrList[j]["checked"] = false;
          if (title == attr[i].attrList[j]["title"]) {
            attr[i].attrList[j]["checked"] = true;
          }
        }
      }
    }
    setBottomState(() {
      //注意  改变showModalBottomSheet里面的数据 来源于StatefulBuilder
      this._attr = attr;
    });
    _getSelectAttrValue();
  }

  // 获得选中的值
  _getSelectAttrValue(){
    var _list=this._attr;
    List tempArr = [];
    for (var i = 0; i < _list.length; i++) {
      for (var j = 0; j < _list[i].attrList.length; j++) {
        if (_list[i].attrList[j]['checked'] == true) {
          tempArr.add(_list[i].attrList[j]["title"]);
        }
      }
    }
    setState(() {
      this._selectedValue = tempArr.join(',');
      // 将商品的选中属性，赋值，便于传递
      this._productContent.selectedAttr=this._selectedValue;
    });
    print(this._selectedValue);
  }

  List<Widget> _getAttrItemWidget(attrItem,setBottomState) {
    List<Widget> attrItemList = [];
    attrItem.attrList.forEach((item) {
      attrItemList.add(Container(
        margin: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            _changeAttr(attrItem.cate, item["title"], setBottomState);
          },
          child: Chip(
            label: Text("${item["title"]}",style: TextStyle(
              color: item["checked"] ? Colors.white : Colors.black38
            ),),
            padding: EdgeInsets.all(10),
            backgroundColor: item["checked"] ? Colors.red : Colors.black26,
          ),
        ),
      ));
    });
    return attrItemList;
  }

  //封装一个组件 渲染attr ,分为了两层，两个循环，都返回Widget
  List<Widget> _getAttrWidget(setBottomState) {
    List<Widget> attrList = [];
    this._attr.forEach((attrItem) {
      attrList.add(Wrap(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10),
            width: ScreenAdaper.width(130),
            child: Padding(
              padding: EdgeInsets.only(top: ScreenAdaper.height(40)),
              child: Text("${attrItem.cate}: ",
                  style: TextStyle(fontWeight: FontWeight.bold,)),
            ),
          ),
          Container(
            width: ScreenAdaper.width(580),
            child: Wrap(
              children: _getAttrItemWidget(attrItem,setBottomState),
            ),
          )
        ],
      ));
    });

    return attrList;
  }

  // 加入购物车的弹窗
  _attrBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (BuildContext context,setBottomState){
              return GestureDetector(
                onTap: () {
                  return false;
                },
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      child: ListView(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _getAttrWidget(setBottomState),
                          ),
                          Divider(),
                          Container(
                            margin: EdgeInsets.fromLTRB(10,10,0,0),
                            height: ScreenAdaper.height(80),
                            child:  Row(
                              children: <Widget>[
                                // TODO
                                Text("数量:",
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  padding: EdgeInsets.only(left:10),
                                  child: CartNum(this._productContent),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 0,
                        width: ScreenAdaper.width(750),
                        height: ScreenAdaper.height(90),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: JdButton(
                                    color: Color.fromRGBO(253, 1, 0, 0.9),
                                    text: "加入购物车",
                                    cb: () async{
                                      await CartServices.addCart(this._productContent);
                                      Navigator.pop(context);
                                      this.cartProvider.updateCartList();
                                      Fluttertoast.showToast(
                                        msg: '加入购物车成功',
                                        toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.CENTER,);
                                      print('加入购物车');
                                    },
                                  ),
                                )),
                            Expanded(flex: 1,
                              child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  child: JdButton(
                                    color: Color.fromRGBO(255, 165, 0, 0.9),
                                    text: "立即购买",
                                    cb: () {
                                      print('立即购买');
                                    },
                                  )),),
                          ],
                        ))
                  ],
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    this.cartProvider = Provider.of<Cart>(context);
    //处理图片
    String pic = Config.domain + this._productContent.pic;
    pic = pic.replaceAll('\\', '/');
    return Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                  "${pic}",
                  fit: BoxFit.cover),
            ),
            // 标题
            Container(
                padding: EdgeInsets.only(top: 10),
                child: Text("${this._productContent.title}",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: ScreenAdaper.size(38),
                    ))),
            Container(
              padding: EdgeInsets.only(top: 10),
              child:this._productContent.subTitle!=null?Text(
                  "${this._productContent.subTitle}",
                  style: TextStyle(
                      color: Colors.black87, fontSize: ScreenAdaper.size(32))):Text(""),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: <Widget>[
                        Text("特价"),
                        Text("¥${this._productContent.price}",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: ScreenAdaper.size(46)))
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text("原件:"),
                        Text("¥${this._productContent.oldPrice}",
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: ScreenAdaper.size(28),
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            // 筛选
            Container(
                margin: EdgeInsets.only(top: 10),
                height: ScreenAdaper.height(80),
                child: InkWell(
                  onTap: () {
                    _attrBottomSheet();
                  },
                  child: Row(
                    children: <Widget>[ // TODO
                      Text("已选:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("115，黑色，XL， 1件")
                    ],
                  ),
                )),
            Divider(),
            Container(
              height: ScreenAdaper.height(80),
              child: Row(
                children: <Widget>[
                  Text("运费:", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("免运费"),
                ],
              ),
            ),
            Divider(),
          ],
        ));
  }
}
