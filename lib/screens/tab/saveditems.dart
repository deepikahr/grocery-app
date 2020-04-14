import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:grocery_pro/widgets/productCard.dart';

SentryError sentryError = new SentryError();

class SavedItems extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;
  SavedItems({Key key, this.locale, this.localizedValues});

  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  bool isGetTokenLoading = false;
  bool isFavListLoading = false;
  String token, currency;
  List<dynamic> favProductList;
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFavListMethod() {
    if (mounted) {
      setState(() {
        isFavListLoading = true;
      });
    }
    Common.getFavList().then((value) {
      if (value == null) {
        if (mounted) {
          setState(() {
            getFavListApi();
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isFavListLoading = false;
            favProductList = value['response_data'];
            getFavListApi();
          });
        }
      }
    });
  }

  getFavListApi() async {
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isFavListLoading = false;
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

  getToken() async {
    if (mounted) {
      setState(() {
        isGetTokenLoading = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency');
    await Common.getToken().then((onValue) {
      try {
        if (onValue != null) {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
              token = onValue;
              getFavListMethod();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              isGetTokenLoading = false;
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
      appBar: isGetTokenLoading
          ? null
          : token == null
              ? null
              : GFAppBar(
                  title: Text(
                    MyLocalizations.of(context).savedItems,
                    style: textbarlowSemiBoldBlack(),
                  ),
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                ),
      body: isGetTokenLoading
          ? SquareLoader()
          : token == null
              ? Login(
                  locale: widget.locale,
                  localizedValues: widget.localizedValues,
                )
              : isFavListLoading
                  ? SquareLoader()
                  : favProductList.length != 0
                      ? GridView.builder(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 16),
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: favProductList.length == null
                              ? 0
                              : favProductList.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16),
                          itemBuilder: (BuildContext context, int i) {
                            if (favProductList[i]['averageRating'] == null) {
                              favProductList[i]['averageRating'] = 0;
                            }
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues,
                                      productDetail: favProductList[i]
                                          ['product'],
                                      favProductList: favProductList,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  ProductCard(
                                    image: favProductList[i]['product']
                                        ['imageUrl'],
                                    title: favProductList[i]['product']['title']
                                                .length >
                                            10
                                        ? favProductList[i]['product']['title']
                                                .substring(0, 10) +
                                            ".."
                                        : favProductList[i]['product']['title'],
                                    currency: currency,
                                    price: favProductList[i]['product']
                                        ['variant'][0]['price'],
                                    rating: favProductList[i]['averageRating']
                                        .toString(),
                                  ),
                                  favProductList[i]['isDealAvailable'] == true
                                      ? Positioned(
                                          child: Stack(
                                            children: <Widget>[
                                              Image.asset(
                                                  'lib/assets/images/badge.png'),
                                              Text(
                                                " " +
                                                    favProductList[i]
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
                        )
                      : Center(
                          child: Image.asset('lib/assets/images/no-orders.png'),
                        ),
    );
  }
}
