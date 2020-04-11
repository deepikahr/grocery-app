import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/style/style.dart';

class SquareLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GFLoader(
        type: GFLoaderType.square,
        loaderColorOne: primary,
        loaderColorTwo: darkGrey,
        loaderColorThree: primaryLight,
        size: 45,
      ),
    );
  }
}
