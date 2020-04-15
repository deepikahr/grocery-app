import 'package:flutter/material.dart';
import 'package:getflutter/components/appbar/gf_appbar.dart';
import 'package:grocery_pro/screens/categories/subcategories.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/screens/tab/searchitem.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/dealsCard.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

SentryError sentryError = new SentryError();

class AllDealsList extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale, currency;
  final bool token;
  final List productsList, favProductList;
  final String dealType, title;

  AllDealsList(
      {Key key,
      this.locale,
      this.localizedValues,
      this.favProductList,
      this.productsList,
      this.currency,
      this.dealType,
      this.title,
      this.token});
  @override
  _AllDealsListState createState() => _AllDealsListState();
}

class _AllDealsListState extends State<AllDealsList> {
  List dealsList, favProductList;
  String currency;
  bool getTokenValue = false, isAllDealsLoadingList = false;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController controller;
  @override
  void initState() {
    favProductList = widget.favProductList;
    currency = widget.currency;
    getTokenValue = widget.token;
    if (widget.dealType == "TopDeals") {
      getAllTopDealsListMethod();
    } else {
      getAllTodayDealsListMethod();
    }
    super.initState();
  }

  getAllTopDealsListMethod() async {
    if (mounted) {
      setState(() {
        isAllDealsLoadingList = true;
      });
    }
    await ProductService.getTopDealsListAll().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              dealsList = onValue['response_data'];
              isAllDealsLoadingList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              dealsList = [];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getAllTodayDealsListMethod() async {
    if (mounted) {
      setState(() {
        isAllDealsLoadingList = true;
      });
    }
    await ProductService.getTodayDealsListAll().then((onValue) {
      try {
        _refreshController.refreshCompleted();
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              dealsList = onValue['response_data'];
              isAllDealsLoadingList = false;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              dealsList = [];
            });
          }
        }
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: GFAppBar(
        backgroundColor: bg,
        elevation: 0,
        title: Text(
          widget.title,
          style: textbarlowSemiBoldBlack(),
        ),
        centerTitle: true,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: () {
          if (widget.dealType == "TopDeals") {
            getAllTopDealsListMethod();
          } else {
            getAllTodayDealsListMethod();
          }
        },
        child: isAllDealsLoadingList
            ? SquareLoader()
            : Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: ListView(
                  children: <Widget>[
                    GridView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          dealsList.length == null ? 0 : dealsList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 23,
                          mainAxisSpacing: 23),
                      itemBuilder: (BuildContext context, int i) {
                        return InkWell(
                          onTap: () {
                            if (dealsList[i]['delalType'] == 'Category') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SubCategories(
                                    locale: widget.locale,
                                    localizedValues: widget.localizedValues,
                                    catId: dealsList[i]['category'],
                                    catTitle:
                                        '${dealsList[i]['name'][0].toUpperCase()}${dealsList[i]['name'].substring(1)}',
                                  ),
                                ),
                              );
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues,
                                      productID: dealsList[i]['product'],
                                      favProductList: getTokenValue
                                          ? favProductList
                                          : null),
                                ),
                              );
                            }
                          },
                          child: Stack(
                            children: <Widget>[
                              DealCard(
                                image: dealsList[i]['imageUrl'],
                                title: dealsList[i]['name'].length > 10
                                    ? dealsList[i]['name'].substring(0, 10) +
                                        ".."
                                    : dealsList[i]['name'],
                                price: dealsList[i]['delaPercent'].toString() +
                                    "% off",
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
