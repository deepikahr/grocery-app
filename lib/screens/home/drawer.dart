import 'package:flutter/material.dart';
import 'package:grocery_pro/screens/aboutus/aboutus.dart';
import 'package:grocery_pro/screens/address/address.dart';
import 'package:grocery_pro/screens/categories/allcategories.dart';
import 'package:grocery_pro/screens/chat/chatpage.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/screens/tab/profile.dart';
import 'package:grocery_pro/screens/tab/saveditems.dart';
import '../../style/style.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  void initState() {
    super.initState();
  }

// bool selected=false;
  @override
  Widget build(BuildContext context) {
    return Container(
        // color: Colors.black54,
        child: Drawer(
      child: Stack(
        // fit: StackFit.passthrough,
        children: <Widget>[
          Container(
            color: Color(0xFF000000),
            child: ListView(
              children: <Widget>[
                SizedBox(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Grocery App',
                      style: textbarlowBoldWhitebig(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: _buildMenuTileList(
                      'lib/assets/icons/Home.png', 'Home', 0,
                      route: Home()),
                ),
                _buildMenuTileList(
                    'lib/assets/icons/products.png', 'Products', 0,
                    route: AllCategories()),
                _buildMenuTileList(
                    'lib/assets/icons/orders.png', 'My Profile', 0,
                    route: Profile()),
                _buildMenuTileList(
                    'lib/assets/icons/location.png', 'Saved Address', 0,
                    route: Address()),
                _buildMenuTileList('lib/assets/icons/fav.png', 'Favourites', 0,
                    route: SavedItems()),
                _buildMenuTileList('lib/assets/icons/chat.png', 'Chats', 0,
                    route: Chat()),
                _buildMenuTileList('lib/assets/icons/help.png', 'Help', 0,
                    route: Chat()),
                _buildMenuTileList('lib/assets/icons/about.png', 'About Us', 0,
                    route: AboutUs()),
                _buildMenuTileList1(
                  'lib/assets/icons/lg.png',

                  'Logout',
                  0,
                  // route: Login()
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildMenuTileList(String icon, String name, int count,
      {Widget route, bool check}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => route));
            //             setState(() {
            //   selected=!selected;
            // });
          } else {
            Navigator.pop(context);
          }
        },
        child: Container(
          // color: selected?primary:Colors.transparent,
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: ListTile(
                  leading: Image.asset(
                    icon,
                    width: 35,
                    height: 35,
                    color: Colors.white,
                  ),
                  selected: true,
                  // onTap: () => setState(() => selected = !selected),
                  // onTap: (){

                  // },
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  name,
                  style: textBarlowregwhitelg(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuTileList1(String icon, String name, int count,
      {Widget route, bool check}) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      // color: selected?primary:Colors.transparent,
      child: GestureDetector(
        onTap: () {
          if (route != null) {
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (BuildContext context) => route));
            setState(() {
              // selected=!selected;
            });
          } else {
            Navigator.pop(context);
          }
        },
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ListTile(
                leading: Image.asset(icon,
                    width: 35, height: 35, color: Color(0xFFF44242)),
                // onTap: (){

                // },
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                name,
                style: textBarlowregredlg(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
