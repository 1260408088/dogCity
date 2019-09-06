import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
class ProductContentSecond extends StatefulWidget {
  final List _productContentList;
  ProductContentSecond(this._productContentList,{Key key}) : super(key: key);

  _ProductContentSecondState createState() => _ProductContentSecondState();
}

class _ProductContentSecondState extends State<ProductContentSecond> with AutomaticKeepAliveClientMixin{
  bool get wantKeepAlive =>true;
  var _id;
  @override
  Widget build(BuildContext context) {
    this._id=widget._productContentList[0].sId;
    return Container(
       child: Column(
         children: <Widget>[
           Expanded(
             child: InAppWebView(
                initialUrl: "http://jd.itying.com/pcontent?id=${ this._id}",
               onProgressChanged: (InAppWebViewController controller,int progress){

               },
             ),
           ),
         ],
       )
    );
  }

}