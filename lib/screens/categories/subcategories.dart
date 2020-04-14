import 'package:flutter/material.dart';

import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/service/product-service.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/productCard.dart';
import 'package:grocery_pro/style/style.dart';

SentryError sentryError = new SentryError();

class SubCategories extends StatefulWidget {
  final String catTitle;
  final String catId;
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
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
  @override
  void initState() {
    getToken();
    super.initState();
    getProductToCategory(widget.catId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  getProductToCategory(id) async {
    if (mounted)
      setState(() {
        isLoadingSubProductsList = true;
      });
    await ProductService.getProductToCategoryList(id).then((onValue) {
      try {
        if (mounted)
          setState(() {
            subProductsList = onValue['response_data'];
            isLoadingSubProductsList = false;
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
    await Common.getToken().then((onValue) {
      if (onValue != null) {
        if (mounted) {
          setState(() {
            getTokenValue = true;
            getFavListApi();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            getTokenValue = false;
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
      body: isLoadingSubProductsList
          ? SquareLoader()
          : Stack(
              children: <Widget>[
                subProductsList.length == 0
                    ? Center(
                        child: Image.asset('lib/assets/images/no-orders.png'),
                      )
                    : GridView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: subProductsList.length == null
                            ? 0
                            : subProductsList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
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
                                      productDetail: subProductsList[i],
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
                                  title: subProductsList[i]['title'].length > 10
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
    );
  }
}
