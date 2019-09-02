import 'package:flutter/material.dart';
import '../service/ScreenAdaper.dart';
import '../config/Config.dart';
import '../model/ProductModel.dart';
import 'package:dio/dio.dart';
import '../widget/LoadingWidget.dart';

class ProductList extends StatefulWidget {
  Map arguments;

  ProductList({Key key, this.arguments}) : super(key: key);

  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 上拉分页控制器
  ScrollController _scrollController = ScrollController();

  // 分页
  int _page = 1;

  // 每页有多少条数据
  int _pageSize = 8;

  // 数据
  List _productList = [];

  // 是否有数据
  bool _hasMore = true;

  //排序:价格升序 sort=price_1 价格降序 sort=price_-1  销量升序 sort=salecount_1 销量降序 sort=salecount_-1
  String _sort = "";

  // 重复请求？？？？
  // 是否存在有数据
  bool flag = true;

  /*二级导航数据*/
  List _subHeaderList = [
    {
      "id": 1,
      "title": "综合",
      "fileds": "all",
      "sort":
      -1, //排序     升序：price_1     {price:1}        降序：price_-1   {price:-1}
    },
    {"id": 2, "title": "销量", "fileds": 'salecount', "sort": -1},
    {"id": 3, "title": "价格", "fileds": 'price', "sort": -1},
    {"id": 4, "title": "筛选"}
  ];

  //二级导航选中判断
  int _selectHeaderId = 1;

  @override
  void initState() {
    super.initState();
    _getProductListData();
    //监听滚动条滚动事件
    _scrollController.addListener(() {
      //_scrollController.position.pixels //获取滚动条滚动的高度
      //_scrollController.position.maxScrollExtent  //获取页面高度
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 20) {
        if (this.flag && this._hasMore) {
          _getProductListData();
        }
      }
    });
  }

  // 获得请求的数据
  _getProductListData() async {
    setState(() {
      this.flag = false;
    });
    var api =
        '${Config.domain}api/plist?cid=${widget.arguments["cid"]}&page=${this
        ._page}&sort=${this._sort}&pageSize=${this._pageSize}';
    var result = await Dio().get(api);

    var productList = new ProductModel.fromJson(result.data);

    print(productList.result.length);

    if (productList.result.length < this._pageSize) {
      setState(() {
        // this._productList = productList.result;
        this._productList.addAll(productList.result);
        this._hasMore = false;
        this.flag = true;
      });
    } else {
      setState(() {
        // this._productList = productList.result;
        this._productList.addAll(productList.result);
        this._page++;
        this.flag = true;
      });
    }
  }

  // 显示加载中的小圆圈
  Widget _showMore(index) {
    if (this._hasMore) {
      return (index == this._productList.length - 1)
          ? LoadingWidget()
          : Text("");
    } else {
      return (index == this._productList.length - 1)
          ? Text("--我是有底线的--")
          : Text("");
    }
  }

  Widget _ProductList() {
    if (this._productList.length > 0) {
      return Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: ScreenAdaper.height(80)), // 不让分栏遮挡住
          child: ListView.builder(
              controller: _scrollController,
              itemCount: this._productList.length,
              itemBuilder: (context, index) {
                String pic = this._productList[index].pic;
                pic = Config.domain + pic.replaceAll('\\', '/');
                return Column(children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: ScreenAdaper.width(180),
                        height: ScreenAdaper.height(180),
                        child: Image.network("${pic}", fit: BoxFit.cover),
                      ),
                      Expanded(
                          flex: 1,
                          child: Container(
                            height: ScreenAdaper.height(180),
                            margin: EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("${this._productList[index].title}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                Row(
                                  children: <Widget>[
                                    Container(
                                      height: ScreenAdaper.height(36),
                                      margin: EdgeInsets.only(right: 10),
                                      padding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),

                                      //注意 如果Container里面加上decoration属性，这个时候color属性必须得放在BoxDecoration
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                        Color.fromRGBO(230, 230, 230, 0.9),
                                      ),

                                      child: Text("4g"),
                                    ),
                                    Container(
                                      height: ScreenAdaper.height(36),
                                      margin: EdgeInsets.only(right: 10),
                                      padding:
                                      EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                        Color.fromRGBO(230, 230, 230, 0.9),
                                      ),
                                      child: Text("126"),
                                    ),
                                  ],
                                ),
                                Text(
                                  "¥${this._productList[index].price}",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 16),
                                )
                              ],
                            ),
                          ))
                    ],
                  ),
                  Divider(height: 20),
                  _showMore(index),
                ]);
              }));
    } else {
      return LoadingWidget();
    }
  }

  //筛选导航
  Widget _subHeaderWidget() {
    return Positioned(
      top: 0,
      height: ScreenAdaper.height(80),
      width: ScreenAdaper.width(750),
      child: Container(
        width: ScreenAdaper.width(750),
        height: ScreenAdaper.height(80),
        // color: Colors.red,
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 1, color: Color.fromRGBO(233, 233, 233, 0.9)))),
        child: Row(
          children: this._subHeaderList.map((value) {
            return Expanded(
                flex: 1,
                child: InkWell(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, ScreenAdaper.height(16), 0,
                        ScreenAdaper.height(16)),
                    child: Text(
                      "${value["title"]}",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: (this._selectHeaderId == value["id"])
                          ? Colors.red
                          : Colors.black54),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      this._selectHeaderId=value["id"];
                    });

                  },
                )
            );
          }).toList(),
//            Expanded(
//              flex: 1,
//              child: InkWell(
//                child: Padding(
//                  padding: EdgeInsets.fromLTRB(
//                      0, ScreenAdaper.height(16), 0, ScreenAdaper.height(16)),
//                  child: Text(
//                    "综合",
//                    textAlign: TextAlign.center,
//                    style: TextStyle(color: Colors.red),
//                  ),
//                ),
//                onTap: () {},
//              ),
//            ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return new Scaffold(
        appBar: AppBar(
          title: Text("商品列表"),
        ),
        endDrawer: Drawer(
          // 右侧边栏
          child: Container(
            child: Text("实现筛选功能"),
          ),
        ),
        // body:Text("${widget.arguments}")
        body: new Stack(
          children: <Widget>[
            _ProductList(),
            _subHeaderWidget(),
          ],
        ));
  }
}
