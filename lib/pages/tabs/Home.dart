import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../../service/ScreenAdaper.dart';
import '../../model/FocusModel.dart';
import 'package:dio/dio.dart';
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _focusData=[];
  @override
  void initState() {
    super.initState();
    _getFocusData();
  }

  _getFocusData() async{
    var api='http://jd.itying.com/api/focus';

    var result=await Dio().get(api);

    print(result);

    var focusList=FocusModel.fromJson(result.data);

    print("modeldate:${focusList.result}");

    // focusList.result.forEach((value){
    //   print(value.title);
    //   print(value.pic);
    // });

    setState(() {
      this._focusData= focusList.result;
    });




  }

  //轮播图
  Widget _swiperWidget() {
    List<Map> imgList = [
      {"url": "https://www.itying.com/images/flutter/slide01.jpg"},
      {"url": "https://www.itying.com/images/flutter/slide02.jpg"},
      {"url": "https://www.itying.com/images/flutter/slide03.jpg"},
    ];

    return Container(
      child: AspectRatio(
        aspectRatio: 2/1,
        child: Swiper(
            itemBuilder: (BuildContext context, int index) {

              String pic=this._focusData[index].pic;
              return new Image.network(
                "http://jd.itying.com/${pic.replaceAll('\\', '/')}",
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

  Widget _hotProductListWidget(){

    return  Container(

      height: ScreenAdaper.height(234),
      padding: EdgeInsets.all(ScreenAdaper.width(20)),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (contxt,index){
          return Column(
            children: <Widget>[
              Container(
                height: ScreenAdaper.height(140),
                width: ScreenAdaper.width(140),
                margin: EdgeInsets.only(right: ScreenAdaper.width(21)),
                // padding: EdgeInsets.only(right: ScreenAdaper.width(21)),
                child: Image.network("https://www.itying.com/images/flutter/hot${index+1}.jpg",fit: BoxFit.cover),
              ),
              Container(
                padding: EdgeInsets.only(top:ScreenAdaper.height(10)),
                height: ScreenAdaper.height(44),
                child: Text("第${index}条"),
              )
            ],
          );
        },
        itemCount: 10,
      ),
    );
  }

  //推荐商品

  _recProductItemWidget() {
    var itemWidth = (ScreenAdaper.getScreenWidth() - 30) / 2;

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
                "https://www.itying.com/images/flutter/list1.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdaper.height(20)),
            child: Text(
              "2019夏季新款气质高贵洋气阔太太有女人味中长款宽松大码",
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
                    "¥188.0",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("¥198.0",
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
          Container(
            padding: EdgeInsets.all(10),
            child: Wrap(
              runSpacing: 10,
              spacing: 10,
              children: <Widget>[
                _recProductItemWidget(),
                _recProductItemWidget(),
                _recProductItemWidget(),
                _recProductItemWidget(),
                _recProductItemWidget(),
                _recProductItemWidget()
              ],
            ),
          )
        ],
      )
    );
  }
}