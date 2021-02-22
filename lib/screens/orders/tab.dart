import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/screens/orders/orders.dart';
import 'package:readymadeGroceryApp/screens/orders/subscriptionsList.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color(0xFFFDFDFD),
        appBar: appBarPrimarynoradius(context, "ORDERS"),
        body: ListView(
          children: <Widget>[
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 20, left: 45, right: 45),
              child: GFSegmentTabs(
                tabController: tabController,
                width: 280,
                // initialIndex: 0,
                length: 2,
                tabs: const <Widget>[
                  Text(
                    'Purchases',
                  ),
                  Tab(
                    child: Text(
                      'Subscriptions',
                    ),
                  ),
                ],
                tabBarColor: GFColors.TRANSPARENT,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: primary(context),
                labelStyle: textbarlowmediumpri(context),
                unselectedLabelStyle: textbarlowmedium(context),
                unselectedLabelColor: Colors.black45,
                indicator: BoxDecoration(
                    color: primary(context).withOpacity(0.2),
                    // border: Border(bottom: BorderSide(color: primary)),
                    border: Border.all(color: primary(context)),
                    borderRadius: BorderRadius.circular(20)),
                indicatorPadding: const EdgeInsets.all(8),
                indicatorWeight: 3,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 140,
              child: GFTabBarView(
                controller: tabController,
                children: <Widget>[
                  Center(
                    child: Orders(),
                  ),
                  Center(
                    child: SubScriptionList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
