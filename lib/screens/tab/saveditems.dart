import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:grocery_pro/model/counterModel.dart';
import 'package:grocery_pro/screens/authe/login.dart';
import 'package:grocery_pro/screens/home/home.dart';
import 'package:grocery_pro/screens/product/product-details.dart';
import 'package:grocery_pro/service/common.dart';
import 'package:grocery_pro/service/localizations.dart';
import 'package:grocery_pro/service/sentry-service.dart';
import 'package:grocery_pro/service/fav-service.dart';
import 'package:grocery_pro/style/style.dart';
import 'package:grocery_pro/widgets/loader.dart';
import 'package:grocery_pro/widgets/subCategoryProductCart.dart';
import 'package:shared_preferences/shared_preferences.dart';

SentryError sentryError = new SentryError();

class SavedItems extends StatefulWidget {
  final Map<String, Map<String, String>> localizedValues;
  final String locale;

  SavedItems({Key key, this.locale, this.localizedValues}) : super(key: key);
  @override
  _SavedItemsState createState() => _SavedItemsState();
}

class _SavedItemsState extends State<SavedItems> {
  bool isGetTokenLoading = false, isFavListLoading = false;
  String token, currency;
  List<dynamic> favProductList;
  var cartData;
  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFavListMethod() async {
    if (mounted) {
      setState(() {
        isFavListLoading = true;
      });
    }
    await FavouriteService.getFavList().then((onValue) {
      try {
        if (mounted) {
          setState(() {
            isFavListLoading = false;
            favProductList = onValue['response_data'];
          });
        }
      } catch (error, stackTrace) {
        if (mounted) {
          setState(() {
            isFavListLoading = false;
            favProductList = [];
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isFavListLoading = false;
          favProductList = [];
        });
      }
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
        if (mounted) {
          setState(() {
            isGetTokenLoading = false;
          });
        }
        sentryError.reportError(error, stackTrace);
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isGetTokenLoading = false;
        });
      }
      sentryError.reportError(error, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (token != null) {
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
                  isSaveItem: true,
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
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width / 500,
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
                                      productID: favProductList[i]['product']
                                          ['_id'],
                                      favProductList: favProductList,
                                    ),
                                  ),
                                );
                              },
                              child: Stack(
                                children: <Widget>[
                                  SubCategoryProductCard(
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
                                    category: favProductList[i]['product']
                                        ['category'],
                                    price: favProductList[i]['product']
                                        ['variant'][0]['price'],
                                    rating: favProductList[i]['product']
                                            ['averageRating']
                                        .toString(),
                                    buttonName: "Add",
                                    cartAdded:
                                        favProductList[i]['cartAdded'] ?? false,
                                    cartId: favProductList[i]['cartId'],
                                    productQuantity: favProductList[i]
                                            ['cartAddedQuantity'] ??
                                        0,
                                    token: true,
                                    productList: favProductList[i]['product'],
                                    variantList: favProductList[i]['product']
                                        ['variant'],
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
      bottomNavigationBar: cartData == null
          ? Container(
              height: 10.0,
            )
          : InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        locale: widget.locale,
                        localizedValues: widget.localizedValues,
                        languagesSelection: false,
                        currentIndex: 2,
                      ),
                    ),
                    (Route<dynamic> route) => false);
              },
              child: Container(
                height: 35.0,
                color: primary,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 5.0, bottom: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            '${cartData['cart'].length} ' +
                                MyLocalizations.of(context).items +
                                " " +
                                " | " +
                                "$currency${cartData['grandTotal']}",
                            style: textBarlowRegularBlack(),
                          ),
                          new Text(
                            MyLocalizations.of(context).goToCart,
                            style: textbarlowBoldsmBlack(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
            ),
    );
  }
}
