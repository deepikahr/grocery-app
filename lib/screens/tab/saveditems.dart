import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:readymadeGroceryApp/model/counterModel.dart';
import 'package:readymadeGroceryApp/screens/authe/login.dart';
import 'package:readymadeGroceryApp/screens/home/home.dart';
import 'package:readymadeGroceryApp/screens/product/product-details.dart';
import 'package:readymadeGroceryApp/service/common.dart';
import 'package:readymadeGroceryApp/service/localizations.dart';
import 'package:readymadeGroceryApp/service/sentry-service.dart';
import 'package:readymadeGroceryApp/service/fav-service.dart';
import 'package:readymadeGroceryApp/style/style.dart';
import 'package:readymadeGroceryApp/widgets/loader.dart';
import 'package:readymadeGroceryApp/widgets/subCategoryProductCart.dart';
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
                            if (favProductList[i]['product']['averageRating'] ==
                                null) {
                              favProductList[i]['product']['averageRating'] = 0;
                            }

                            return InkWell(
                              onTap: () {
                                var result = Navigator.push(
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
                                result.then((value) {
                                  getToken();
                                });
                              },
                              child: Stack(
                                children: <Widget>[
                                  SubCategoryProductCard(
                                      image: favProductList[i]['product']['filePath'] ??
                                          favProductList[i]['product']
                                              ['imageUrl'],
                                      title: favProductList[i]['product']
                                          ['title'],
                                      currency: currency,
                                      category: favProductList[i]['product']
                                          ['category'],
                                      price: favProductList[i]['product']
                                          ['variant'][0]['price'],
                                      dealPercentage: favProductList[i]
                                              ['product']['isDealAvailable']
                                          ? double.parse(favProductList[i]
                                                  ['product']['delaPercent']
                                              .toStringAsFixed(1))
                                          : null,
                                      unit: favProductList[i]['product']
                                          ['variant'][0]['unit'],
                                      rating: favProductList[i]['product']['averageRating']
                                          .toStringAsFixed(1),
                                      buttonName: MyLocalizations.of(context).add,
                                      cartAdded: favProductList[i]['cartAdded'] ?? false,
                                      cartId: favProductList[i]['cartId'],
                                      productQuantity: favProductList[i]['cartAddedQuantity'] ?? 0,
                                      variantStock: favProductList[i]['product']['variant'][0]['productstock'],
                                      token: true,
                                      productList: favProductList[i]['product'],
                                      variantList: favProductList[i]['product']['variant'],
                                      subCategoryId: favProductList[i]['subcategory']),
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
                                                    "% " +
                                                    MyLocalizations.of(context)
                                                        .off,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      languagesSelection: false,
                      currentIndex: 2,
                    ),
                  ),
                );
              },
              child: Container(
                height: 55.0,
                padding: EdgeInsets.only(right: 20),
                decoration: BoxDecoration(color: primary, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.29), blurRadius: 5)
                ]),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          color: Colors.black,
                          height: 55,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 7),
                              new Text(
                                '(${cartData['cart'].length})  ' +
                                    MyLocalizations.of(context).items,
                                style: textBarlowRegularWhite(),
                              ),
                              new Text(
                                "$currency${cartData['grandTotal']}",
                                style: textbarlowBoldWhite(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            new Text(
                              MyLocalizations.of(context).goToCart,
                              style: textBarlowRegularBlack(),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              IconData(
                                0xe911,
                                fontFamily: 'icomoon',
                              ),
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
