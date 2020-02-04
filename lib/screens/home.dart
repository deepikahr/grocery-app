import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/home/mycart.dart';
import 'package:grocery_pro/screens/home/profile.dart';
import 'package:grocery_pro/screens/home/saveditems.dart';
import 'package:grocery_pro/screens/home/store.dart';
import 'package:grocery_pro/style/style.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GFTabBarView(
        controller: tabController,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Store(),
          ),
          Container(
            color: Colors.white,
            child: SavedItems(),
          ),
          Container(
            color: Colors.white,
            child: MyCart(),
          ),
          Container(
            color: Colors.white,
            child: Profile(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(),
        child: GFTabBar(
          initialIndex: 0,
          length: 4,
          controller: tabController,
          tabs: [
            Tab(
              icon: Icon(
                IconData(
                  0xe90f,
                  fontFamily: 'icomoon',
                ),
                // color: getGFColor(GFColor.white),
              ),
              text: "Store",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe90d,
                  fontFamily: 'icomoon',
                ),
                // color: getGFColor(GFColor.white),
              ),
              text: "Saved Items",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe911,
                  fontFamily: 'icomoon',
                ),
                // color: getGFColor(GFColor.white),
              ),
              text: "My Cart",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe912,
                  fontFamily: 'icomoon',
                ),
                // color: getGFColor(GFColor.white),
              ),
              text: "Profile",
            ),
          ],
          indicatorColor: primary,

//        indicatorSize: TabBarIndicatorSize.label,
          labelColor: primary,
          labelPadding: EdgeInsets.all(0),
          tabBarColor: Colors.black,
          unselectedLabelColor: Colors.white,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10.0,
            color: primary,
            fontFamily: 'OpenSansBold',
          ),

          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 10.0,
            color: Colors.black,
            fontFamily: 'OpenSansBold',
          ),
        ),
      ),
    );
  }
}
