import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../service/ScreenAdaper.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _focusData=[];
  List _faverData=[];
  List _hotData=[];
  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getFaverDate();
    _getHotData();
  }
    // 获取轮播图数据
  _getFocusData() async{
    var api='${Config.domain}api/focus';
    print("api:"+"${api}");
    var result=await Dio().get(api);
    print(result);
    var focusList=FocusModel.fromJson(result.data);
    print("modeldate:${focusList.result}");
    setState(() {
      this._focusData= focusList.result;
    });
  }
  // 获取猜你喜欢的商品的数据
  _getFaverDate() async{
    var api='${Config.domain}api/plist?is_hot=1';
    print("faver:"+"${api}");
    var result=await Dio().get(api);
    var faverList=ProductModel.fromJson(result.data);
    setState(() {
      this._faverData = faverList.result;
    });
  }
  // 获得热门推荐数据
  _getHotData() async{
    var api='${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var hotList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotData=hotList.result;
    });
  }
  //轮播图
  Widget _swiperWidget() {
    return Container(
      child: AspectRatio(
        aspectRatio: 2/1,
        child: Swiper(
            itemBuilder: (BuildContext context, int index) {

              String pic=this._focusData[index].pic;
              pic = Config.domain+pic.replaceAll('\\', '/');
              return new Image.network(
                "${pic}",
                fit: BoxFit.fill,
              );
            },
            itemCount: this._focusData.length,
            pagination: new SwiperPagination(), // index标志
            autoplay: true),
      ),
    );
  }

  Widget _titleWidget(value){
    return Container(
      height: ScreenAdaper.height(38),
      margin: EdgeInsets.only(left: ScreenAdaper.width(10)),
      padding: EdgeInsets.only(left: ScreenAdaper.width(10)),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
                color: Colors.red,
                width: ScreenAdaper.width(10),
              )
          )
      ),
      child: Text(value,style: TextStyle(
          color: Colors.black54
      ),),
    );
  }
  // 猜你喜欢
  Widget _hotProductListWidget(){
    if(_faverData.length>0){
      return  Container(
        height: ScreenAdaper.height(234),
        padding: EdgeInsets.all(ScreenAdaper.width(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (contxt,index){
            var pic =this._faverData[index].sPic;
            pic =Config.domain+pic.replaceAll('\\', '/');
            return Column(
              children: <Widget>[
                Container(
                  height: ScreenAdaper.height(140),
                  width: ScreenAdaper.width(140),
                  margin: EdgeInsets.only(right: ScreenAdaper.width(21)),
                  // padding: EdgeInsets.only(right: ScreenAdaper.width(21)),
                  child: Image.network(pic,fit: BoxFit.cover),
                ),
                Container(
                  padding: EdgeInsets.only(top:ScreenAdaper.height(10)),
                  height: ScreenAdaper.height(44),
                  child: Text("￥${this._faverData[index].price}"),
                )
              ],
            );
          },
          itemCount: _faverData.length,
        ),
      );
    }else{
      return Text("");
    }
  }

  _recProductItemWidgetfix(){
    var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: this._hotData.map((value){
          var pic = value.sPic;
          pic=Config.domain+pic.replaceAll('\\', '/');
          return Container(
            padding: EdgeInsets.all(10),
            width: itemWidth,
            decoration: BoxDecoration(
                border:
                Border.all(color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: AspectRatio(   //防止服务器返回的图片大小不一致导致高度不一致问题
                    aspectRatio: 1/1,
                    child: Image.network(
                      '${pic}',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                  child: Text(
                    "${value.title}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black54),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "${value.price}",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text("${value.oldPrice}",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                decoration: TextDecoration.lineThrough)),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }).toList()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return Center(
      child:ListView(
        children: <Widget>[
          _swiperWidget(),
          SizedBox(height: ScreenAdaper.width(20)),
          _titleWidget("猜你喜欢"),
          SizedBox(height: ScreenAdaper.width(20)),
          _hotProductListWidget(),
          _titleWidget("热门推荐"),
          _recProductItemWidgetfix(),
        ],
      )
    );
  }
}