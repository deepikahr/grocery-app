import 'package:flutter/material.dart';
import 'package:getflutter/colors/gf_color.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:getflutter/components/badge/gf_badge.dart';
import 'package:getflutter/components/badge/gf_button_badge.dart';
import 'package:getflutter/components/button/gf_icon_button.dart';
import 'package:getflutter/components/card/gf_card.dart';
import 'package:getflutter/components/list_tile/gf_list_tile.dart';
import 'package:getflutter/components/tabs/gf_tabBar.dart';
import 'package:getflutter/components/button/gf_button.dart';
import 'package:getflutter/components/tabs/gf_tabBarView.dart';
import 'package:getflutter/components/tabs/gf_segment_tabs.dart';
import 'package:grocery_pro/screens/home/store.dart';
import 'package:grocery_pro/style/style.dart';

class Fruits extends StatefulWidget {
  @override
  _FruitsState createState() => _FruitsState();
}

class _FruitsState extends State<Fruits> {
  @override
  Widget build(BuildContext context) {
    Widget itemCard = GFCard(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      boxFit: BoxFit.cover,
      colorFilter: new ColorFilter.mode(
          Colors.black.withOpacity(0.67), BlendMode.darken),
      image: Image.asset(
        'lib/assets/images/apple.png',
        // width: MediaQuery.of(context).size.width,
        fit: BoxFit.fitHeight,
        width: 80,
        height: 80,
      ),

//              imageOverlay: AssetImage("lib/assets/food.jpeg"),
      // titlePosition: GFPosition.end,
      content: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text('Apple'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, top: 5.0),
                child: Row(
                  children: <Widget>[
                    Image.asset('lib/assets/icons/rupee.png'),
                    Text(
                      '85/kg',
                      style: TextStyle(color: const Color(0xFF00BFA5)),
                    )
                  ],
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 38.0, bottom: 15.0),
                child: GFIconButton(
                  onPressed: null,
                  icon: GestureDetector(
                    onTap: () {
                      setState(() {
                        fav = !fav;
                      });
                    },
                    child: fav
                        ? Icon(
                            Icons.favorite,
                            color: getGFColor(GFColor.danger),
                          )
                        : Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                          ),
                  ),
                  type: GFType.transparent,
                ),
              ),
            ],
          )
        ],
      ),
      // title: GFListTile(
      //   padding: EdgeInsets.zero,
      //   title: Text('Apple',
      //       style: TextStyle(
      //         fontSize: 13.0,
      //       )),
      //   // ),
      //   icon: GFIconButton(
      //     onPressed: null,
      //     icon: GestureDetector(
      //       onTap: () {
      //         setState(() {
      //           fav = !fav;
      //         });
      //       },
      //       child: fav
      //           ? Icon(
      //               Icons.favorite,
      //               color: getGFColor(GFColor.danger),
      //             )
      //           : Icon(
      //               Icons.favorite_border,
      //               color: Colors.grey,
      //             ),
      //     ),
      //     type: GFType.transparent,
      //   ),
      // ),
      // content: Row(
      //   children: <Widget>[
      //     // Image.asset('lib/assets/icons/rupee.png'),
      //     Text(
      //       ' 85/kg',
      //       style: TextStyle(color: const Color(0xFF00BFA5)),
      //     ),
      //   ],
      // ),

      // RichText(
      //   text: TextSpan(
      //     children: <TextSpan>[
      //       TextSpan(text: "85 /kg", style: comments()),
      //       TextSpan(
      //         text: '                             View all',
      //         style: TextStyle(color: primary),
      //       ),
      //     ],
      //   ),
      // ),
    );

    return Scaffold(
      appBar: GFAppBar(
        title: Text('Fruits',
            style: TextStyle(
                color: Colors.black,
                fontSize: 17.0,
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: Container(
        height: 800.0,
        child: GridView.builder(
          itemCount: 8,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (BuildContext context, int index) {
            return Container(child: itemCard);
          },
        ),
      ),
    );
  }
}
