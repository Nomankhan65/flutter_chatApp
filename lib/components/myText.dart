import 'dart:ui';

import 'package:flutter/cupertino.dart';

class MyText extends StatelessWidget {
  var text;
  double? fontSize;
  Color? color;
  int maxlines;
  double? spacing;
  MyText({super.key,this.text,this.fontSize,this.color,this.spacing,this.maxlines=1});

  @override
  Widget build(BuildContext context) {
    return Text(text,maxLines:maxlines,style:TextStyle(
      fontSize:fontSize,
      color:color,
      letterSpacing:spacing,
      fontFamily:'sans',

    ),);
  }
}