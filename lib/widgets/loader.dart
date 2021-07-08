import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class SquareLoader extends StatelessWidget {
  final size;
  SquareLoader({this.size});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GFLoader(
        type: GFLoaderType.square,
        loaderColorOne: primary(context),
        loaderColorTwo: darkgrey(context),
        loaderColorThree: primaryLight(context),
        size: size ?? 45,
      ),
    );
  }
}
