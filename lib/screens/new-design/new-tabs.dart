import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/screens/new-design/new-category.dart';
import 'package:readymadeGroceryApp/screens/new-design/new-home.dart';
import 'package:readymadeGroceryApp/screens/new-design/new-profile.dart';
import 'package:readymadeGroceryApp/screens/new-design/new-search.dart';
import 'package:readymadeGroceryApp/style/style.dart';

class NewTabsPage extends StatefulWidget {
  @override
  _NewTabsPageState createState() => _NewTabsPageState();
}

class _NewTabsPageState extends State<NewTabsPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            child: GFTabBarView(
              controller: tabController,
              children: <Widget>[
                NewHomePage(),
                NewCategoryPage(),
                NewSearchPage(),
                NewProfilePage()
              ],
            )),
        bottomNavigationBar: Container(
          child: GFTabBar(
            length: 1,
            controller: tabController,
            tabs: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.home,
                  ),
                  const Text(
                    'Home',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.category,
                  ),
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search_outlined,
                  ),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  )
                ],
              ),
            ],
            indicatorColor: white,
            labelColor: primarybg,
            labelPadding: const EdgeInsets.all(8),
            tabBarColor: white,
            unselectedLabelColor: Color(0xFFAEB5C3),
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: 'BarlowSemiBold',
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              fontFamily: 'BarlowSemiBold',
            ),
          ),
        ),
      );
}
