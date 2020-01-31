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
      bottomNavigationBar: GFTabBar(
        initialIndex: 0,
        length: 4,
        controller: tabController,
        tabs: [
          Tab(
            icon: Icon(
              Icons.store,
            ),
            text: "Store",
          ),
          Tab(
            icon: Icon(Icons.save),
            text: "Saved Items",
          ),
          Tab(
            icon: Icon(
              Icons.shopping_cart,
            ),
            text: "My Cart",
          ),
          Tab(
            icon: Icon(
              Icons.person_outline,
            ),
            text: "Profile",
          ),
        ],
        indicatorColor: primary,

//        indicatorSize: TabBarIndicatorSize.label,
        labelColor: primary,
        labelPadding: EdgeInsets.all(0),
        tabBarColor: Colors.black,
        unselectedLabelColor: getGFColor(GFColor.light),
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
    );
  }
}
