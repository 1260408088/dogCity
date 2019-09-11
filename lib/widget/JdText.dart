import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../service/ScreenAdaper.dart';

class JdText extends StatelessWidget {

  final String text;
  final bool password;
  final Object onChanged;
  final double height;
  JdText({Key key,this.text="输入内容",this.password=false,this.height=68,this.onChanged=null}):super(key:key);

  @override
  Widget build(BuildContext context) {

    return Container(
      child: TextField(
        obscureText: this.password,
        decoration: InputDecoration(
          hintText: this.text,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none
          )
        ),
        onChanged: this.onChanged,
      ),
      height: ScreenAdaper.height(this.height),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: 1,
              color: Colors.black12
          ),
        )
      ),
    );
  }
}