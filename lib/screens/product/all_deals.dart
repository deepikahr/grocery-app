import 'package:flutter/material.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/categories/subcategories.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/product-service.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/appBar.dart';
import 'package:readymadeGroceryApp/widgets/dealsCard.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

SentryError sentryError = new SentryError();

class AllDealsList extends StatefulWidget {
  final Map localizedValues;
  final bool token;
  final List productsList, favProductList;
  final String dealType, title, locale, currency;

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
  var cartData;
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
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          dealsList = onValue['response_data'];
          isAllDealsLoadingList = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          dealsList = [];
          isAllDealsLoadingList = false;
        });
      }
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
      _refreshController.refreshCompleted();
      if (mounted) {
        setState(() {
          dealsList = onValue['response_data'];
          isAllDealsLoadingList = false;
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          dealsList = [];
          isAllDealsLoadingList = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (getTokenValue) {
      CounterModel().getCartDataMethod().then((res) {
        if (mounted) {
          setState(() {
            cartData = res;
          });
        }
      });
    } else {
      if (mounted) {
        setState(() {
          cartData = null;
        });
      }
    }
    return Scaffold(
      backgroundColor: bg,
      appBar: appBarWhite(context, widget.title, false, false, null),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
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
            : dealsList.length > 0
                ? Container(
                    margin: EdgeInsets.only(
                        left: 15, right: 15, top: 15, bottom: 16),
                    child: ListView(
                      children: <Widget>[
                        GridView.builder(
                          padding: EdgeInsets.only(bottom: 25),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              dealsList.length == null ? 0 : dealsList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / 720,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16),
                          itemBuilder: (BuildContext context, int i) {
                            return InkWell(
                              onTap: () {
                                if (dealsList[i]['dealType'] == 'CATEGORY') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SubCategories(
                                          locale: widget.locale,
                                          localizedValues:
                                              widget.localizedValues,
                                          catId: dealsList[i]['categoryId'],
                                          catTitle:
                                              '${dealsList[i]['title'][0].toUpperCase()}${dealsList[i]['title'].substring(1)}',
                                          token: getTokenValue),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetails(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        productID: dealsList[i]['productId'],
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: DealsCard(
                                image: dealsList[i]['filePath'] ??
                                    dealsList[i]['imageUrl'],
                                isPath: dealsList[i]['filePath'] == null
                                    ? false
                                    : true,
                                title: dealsList[i]['title'],
                                price: dealsList[i]['dealPercent'].toString() +
                                    "% " +
                                    MyLocalizations.of(context)
                                        .getLocalizations("OFF"),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Image.asset('lib/assets/images/no-orders.png'),
                  ),
      ),
    );
  }
}
