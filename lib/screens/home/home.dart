import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/cart/mycart.dart';
import 'package:grocery_pro/screens/profile/profile.dart';
import 'package:grocery_pro/screens/saveitems/saveditems.dart';
import 'package:grocery_pro/screens/store/store.dart';

import 'package:grocery_pro/style/style.dart';

class Home extends StatefulWidget {
  final int currentIndex;
  final Map<String, Map<String, String>> localizedValues;
  var locale;
  Home({Key key, this.currentIndex, this.locale, this.localizedValues})
      : super(key: key);

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
              ),
              text: "Store",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe90d,
                  fontFamily: 'icomoon',
                ),
              ),
              text: "Saved Items",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe911,
                  fontFamily: 'icomoon',
                ),
              ),
              text: "My Cart",
            ),
            Tab(
              icon: Icon(
                IconData(
                  0xe912,
                  fontFamily: 'icomoon',
                ),
              ),
              text: "Profile",
            ),
          ],
          indicatorColor: primary,
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
