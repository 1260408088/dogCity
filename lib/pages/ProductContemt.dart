import 'package:flutter/material.dart';
import '../service/ScreenAdaper.dart';
import './ProductContent/ProductContentFirst.dart';
import './ProductContent/ProductContentSecond.dart';
import './ProductContent/ProductContentThird.dart';
import '../widget/JdButton.dart';
class ProductContent extends StatefulWidget {
  Map arguments;

  ProductContent({Key key, this.arguments}) : super(key: key);

  _ProductContentState createState() => _ProductContentState();
}

class _ProductContentState extends State<ProductContent> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: ScreenAdaper.width(400),
                  child: TabBar(
                      indicatorColor: Colors.red,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: <Widget>[
                        Tab(
                          child: Text('商品'),
                        ),
                        Tab(
                          child: Text('详情'),
                        ),
                        Tab(
                          child: Text('评价'),
                        )
                      ]),
                )
              ],
            ),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.more_horiz), onPressed: () {
                showMenu(context: context,
                    position: RelativeRect.fromLTRB(ScreenAdaper.width(600), 76, 10, 0),
                    items: [PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.home),
                          Text("首页")
                        ],
                      ),
                    ),
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.search),
                            Text("搜索")
                          ],
                        ),
                      )]);
              })
            ],
          ),
          body: Stack(
            children: <Widget>[
              TabBarView(children: <Widget>[
                ProductContentFirst(),
                ProductContentSecond(),
                ProductContentThird(),
              ]),
              Positioned(
                  height: ScreenAdaper.height(90),
                  width: ScreenAdaper.width(750),
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Colors.black26,
                                width: 1
                            )
                        ),
                        color: Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top:ScreenAdaper.height(10)),
                          width: 100,
                          height: ScreenAdaper.height(88),
                          child: Column(
                            children: <Widget>[
                              Icon(Icons.shopping_cart),
                              Text("购物车",style: TextStyle(fontSize: 10),)
                            ],
                          ),
                        ),
                        Expanded(
                            flex:1,
                            child: JdButton(
                              color:Color.fromRGBO(253, 1, 0, 0.9),
                              text: "加入购物车",
                              cb: (){
                                print('加入购物车');
                              },
                            )),
                        Expanded(flex: 1,
                          child: JdButton(
                            color: Color.fromRGBO(255, 165, 0, 0.9),
                            text: "立即购买",
                            cb: (){
                              print('立即购买');
                            },
                          ),)
                      ],
                    )
                  )
              )
            ],
          ),
        ));
  }
}
