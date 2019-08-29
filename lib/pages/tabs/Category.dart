import 'package:flutter/material.dart';
import '../../service/ScreenAdaper.dart';
import 'package:dio/dio.dart';
import '../../config/Config.dart';
import '../../model/CateModel.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectIndex = 0;
  List _leftdata = [];
  List _rightdata = [];

  @override
  void initState() {
    super.initState();
    _getLeftdata();
  }

  // 左边的数据请求
  _getLeftdata() async {
    var api = '${Config.domain}api/pcate';
    print("left:" + "${api}");
    var result = await Dio().get(api);
    print("result:+${result}");
    var leftList = Catemodel.fromJson(result.data);
    print("sult:+${leftList}");
    setState(() {
      this._leftdata = leftList.result;
    });
    _getRightCateData(this._leftdata[0].sId);
  }

  //右侧分类
  _getRightCateData(pid) async {
    var api = '${Config.domain}api/pcate?pid=${pid}';
    var result = await Dio().get(api);
    var rightCateList = new Catemodel.fromJson(result.data);
    // print(rightCateList.result);
    setState(() {
      this._rightdata = rightCateList.result;
    });
  }

  // 左边
  _leftWidget(leftWidth) {
    if (this._leftdata.length > 0) {
      return Container(
        width: leftWidth,
        height: double.infinity,
        // color: Colors.cyan,
        child: ListView.builder(
            itemCount: this._leftdata.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      setState(() {
                        _selectIndex= index;
                        this._getRightCateData(this._leftdata[index].sId);
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      //padding:EdgeInsets.only(top:ScreenAdaper.height(24)),
                      height: ScreenAdaper.height(84),
                      child: Text(
                        "${this._leftdata[index].title}",
                        textAlign: TextAlign.center,
                      ),
                      color: _selectIndex == index
                          ? Color.fromRGBO(240, 246, 246, 0.9)
                          : Colors.white,
                    ),
                  ),
                  Divider(height: 2),
                ],
              );
            }),
      );
    } else {
      return Container(
        width: leftWidth,
        height: double.infinity,
      );
    }
  }
  // 右边
  _rightWidget(rightItemWidth, rightItemHeight) {
    if (this._rightdata.length > 0) {
      return Expanded(
          flex: 1,
          child: Container(
              padding: EdgeInsets.all(ScreenAdaper.width(10)),
              height: double.infinity,
              color: Color.fromRGBO(240, 246, 246, 0.9),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: rightItemWidth / rightItemHeight,
                      crossAxisSpacing: 5, // 左右的间距
                      mainAxisSpacing: 2 // 上下的间距
                      ),
                  itemCount: this._rightdata.length,
                  itemBuilder: (context, index) {
                    //处理图片
                    String pic=this._rightdata[index].pic;
                    pic=Config.domain+pic.replaceAll('\\', '/');
                    return Container(
                      child: Column(
                        children: <Widget>[

                          AspectRatio(
                            aspectRatio: 1/1,
                            child: Image.network("${pic}",fit: BoxFit.cover),
                          ),

                          Container(
                            margin: EdgeInsets.only(top:5),
                            height: ScreenAdaper.height(30),
                            child: Text("${this._rightdata[index].title}",style: TextStyle(fontSize: 12),),
                          )
                        ],
                      ),
                    );
                  })));
    } else {
      return Expanded(
          flex: 1,
          child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            color: Color.fromRGBO(240, 246, 246, 0.9),
            child: Text("加载中..."),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    var leftWidth = ScreenAdaper.getScreenWidth() / 4;
    //右侧每一项宽度=（总宽度-左侧宽度-GridView外侧元素左右的Padding值-GridView中间的间距）/3
    var rightItemWidth =
        (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20) / 3;
    //获取计算后的宽度
    rightItemWidth = ScreenAdaper.width(rightItemWidth);
    //获取计算后的高度
    var rightItemHeight = rightItemWidth + ScreenAdaper.height(28);
    return new Row(
      children: <Widget>[
        _leftWidget(leftWidth),
        _rightWidget(rightItemWidth, rightItemHeight)
      ],
    );
  }
}
