import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:grocery_pro/style/style.dart';

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: GFAppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text('Products', style: textbarlowSemiBoldBlack(),),
        centerTitle: true,
        actions: <Widget>[
          Padding(padding: EdgeInsets.only(right:20), child: Icon(Icons.search),)
        ],

      ),
      body: Container(
        margin: EdgeInsets.only(left: 15, right: 15, top:15),
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Suggested for you', style: textBarlowMediumBlack(),),
                Row(
                  children: <Widget>[
                    Image.asset('lib/assets/icons/filter.png', width: 20,),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Filters', style: textBarlowMediumBlack(),)
                  ],
                ),

              ],
            ),
            Divider(color: Colors.black.withOpacity(0.20), thickness: 1,),

          ],
        ),
      ),
    );
  }
}
