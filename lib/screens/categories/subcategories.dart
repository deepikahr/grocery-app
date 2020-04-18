import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/productCard.dart';
import 'package:grocery_pro/style/style.dart';

SentryError sentryError = new SentryError();

class SubCategories extends StatefulWidget {
  final String catTitle, locale, catId;
  final Map<String, Map<String, String>> localizedValues;

  SubCategories(
      {Key key, this.catId, this.catTitle, this.locale, this.localizedValues})
      : super(key: key);
  @override
  _SubCategoriesState createState() => _SubCategoriesState();
}

class _SubCategoriesState extends State<SubCategories> {
  bool isLoadingSubProductsList = false, getTokenValue = false;
  List subProductsList, favProductList;
  String currency;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getProductToCategory(id) async {
    print("  nnnnnnnnn");
    await ProductService.getProductToCategoryList(id).then((onValue) {
      print("dddddddddd $onValue");
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data'];
            isLoadingSubProductsList = false;
            _refreshController.refreshCompleted();
          });
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getProductToCategoryCartAdded(id) async {
    print("  nnnnnnnnn");
    await ProductService.getProductToCategoryListCartAdded(id).then((onValue) {
      print("dddddddddd $onValue");
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data'];
            isLoadingSubProductsList = false;
            _refreshController.refreshCompleted();
          });
      } catch (error, stackTrace) {
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    if (mounted)
      setState(() {
        isLoadingSubProductsList = true;
      });
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            getTokenValue = true;
            getProductToCategoryCartAdded(widget.catId);
            getFavListApi();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
            getProductToCategory(widget.catId);
          });
        }
      }
    }).catchError((error) {
      sentryError.reportError(error, null);
    });
  }

  getFavListApi() async {
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            favProductList = onValue['response_data'];
          });
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
      appBar: GFAppBar(
        title: Text(
          '${widget.catTitle}',
          style: TextStyle(
              color: Colors.black, fontSize: 17.0, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black, size: 1.0),
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: () {
          getProductToCategory(widget.catId);
        },
        child: isLoadingSubProductsList
            ? SquareLoader()
            : Stack(
                children: <Widget>[
                  subProductsList.length == 0
                      ? Center(
                          child: Image.asset('lib/assets/images/no-orders.png'),
                        )
                      : GridView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 16),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: subProductsList.length == null
                              ? 0
                              : subProductsList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / 400,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16),
                          itemBuilder: (BuildContext context, int i) {
                            if (subProductsList[i]['averageRating'] == null) {
                              subProductsList[i]['averageRating'] = 0;
                            }

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                        locale: widget.locale,
                                        localizedValues: widget.localizedValues,
                                        productID: subProductsList[i]['_id'],
                                        favProductList: getTokenValue
                                            ? favProductList
                                            : null),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  ProductCard(
                                    image: subProductsList[i]['imageUrl'],
                                    title:
                                        subProductsList[i]['title'].length > 10
                                            ? subProductsList[i]['title']
                                                    .substring(0, 10) +
                                                ".."
                                            : subProductsList[i]['title'],
                                    currency: currency,
                                    category: subProductsList[i]['category'],
                                    price: subProductsList[i]['variant'][0]
                                        ['price'],
                                    rating: subProductsList[i]['averageRating']
                                        .toString(),
                                    buttonName: getTokenValue
                                        ? subProductsList[i]['cartAdded'] ==
                                                true
                                            ? "Added"
                                            : "Add"
                                        : null,
                                    productList: subProductsList[i],
                                    variantList: subProductsList[i]['variant'],
                                  ),
                                  subProductsList[i]['isDealAvailable'] == true
                                      ? Positioned(
                                          child: Stack(
                                            children: <Widget>[
                                              Image.asset(
                                                  'lib/assets/images/badge.png'),
                                              Text(
                                                " " +
                                                    subProductsList[i]
                                                            ['delaPercent']
                                                        .toString() +
                                                    "% Off",
                                                style: hintSfboldwhitemed(),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
      ),
    );
  }
}
