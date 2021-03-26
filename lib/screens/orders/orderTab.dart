import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/screens/orders/orders.dart';

class OrdersTab extends StatefulWidget {
  final String? locale;
  final Map? localizedValues;

  OrdersTab({Key? key, this.locale, this.localizedValues}) : super(key: key);
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bg(context),
        appBar: appBarPrimarynoradius(context, "ORDERS") as PreferredSizeWidget?,
        body: ListView(
          children: <Widget>[
            Container(
              height: 35,
              margin:
                  const EdgeInsets.only(left: 45, right: 45, top: 5, bottom: 5),
              child: GFSegmentTabs(
                tabController: tabController,
                width: 280,
                length: 2,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      MyLocalizations.of(context)!.getLocalizations("PURCHASES"),
                      style: textbarlowRegularBlackb(context),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Tab(
                    child: Text(
                      MyLocalizations.of(context)!
                          .getLocalizations("SUBSCRIPTION"),
                      style: textbarlowRegularBlackb(context),
                      textAlign: TextAlign.center,
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
                    border: Border.all(color: primary(context)),
                    borderRadius: BorderRadius.circular(20)),
                indicatorPadding: const EdgeInsets.all(8),
                indicatorWeight: 3,
                border: Border.all(color: Colors.transparent, width: 2),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 140,
              child: GFTabBarView(
                controller: tabController,
                children: <Widget>[
                  Center(
                    child: Orders(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                    ),
                  ),
                  Center(
                    child: Orders(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      isSubscription: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
