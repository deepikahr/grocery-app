import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/tabs/gf_tabBar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/tabs/gf_tabBarView.dart';
import 'package:getflutter/components/tabs/gf_segment_tabs.dart';
import 'package:grocery_pro/screens/home/mycart.dart';
import 'package:grocery_pro/screens/home/profile.dart';
import 'package:grocery_pro/screens/home/saveditems.dart';
import 'package:grocery_pro/screens/home/store.dart';
import 'package:grocery_pro/style/style.dart';

class ProductDetails extends StatefulWidget {
  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
                height: 400.0,
                // width: 600,
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 58.0,
                  ),
                  child: Image.asset('lib/assets/images/product.png'),
                )),
            Positioned(
              top: 40.0,
              left: 15.0,
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            Positioned(
              top: 330.0,
              left: 60.0,
              child: Container(
                height: 25.0,
                width: 60.0,
                child: GFButton(
                  onPressed: () {},
                  // text: '1kg',
                  child: Text('1kg', style: TextStyle(color: Colors.black)),
                  color: GFColor.light,
                  type: GFType.solid,
                  // size: GFSize.small,
                ),
              ),
            ),
            Positioned(
              top: 330.0,
              left: 130.0,
              child: Container(
                height: 25.0,
                width: 60.0,
                child: GFButton(
                  onPressed: () {},
                  // text: '1kg',
                  child: Text('1kg', style: TextStyle(color: Colors.black)),
                  color: GFColor.light,
                  type: GFType.solid,
                  // size: GFSize.small,
                ),
              ),
            ),
            Positioned(
              top: 330.0,
              left: 200.0,
              child: Container(
                height: 25.0,
                width: 60.0,
                child: GFButton(
                  onPressed: () {},
                  // text: '1kg',
                  child: Text('1kg', style: TextStyle(color: Colors.black)),
                  color: GFColor.light,
                  type: GFType.solid,
                  // size: GFSize.small,
                ),
              ),
            ),
            Positioned(
              top: 330.0,
              left: 250.0,
              child: Container(
                height: 25.0,
                width: 60.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(80.0)),
              ),
            ),
          ],
        )
      ],
    )));
  }
}
