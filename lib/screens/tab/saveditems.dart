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

SentryError sentryError = new SentryError();

class SavedItems extends StatefulWidget {
  final Map localizedValues;
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
          });
        }
        if (onValue['response_code'] == 200) {
          if (mounted) {
            setState(() {
              favProductList = onValue['response_data'];
            });
          }
        } else {
          if (mounted) {
            setState(() {
              favProductList = [];
            });
          }
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
    await Common.getCurrency().then((value) {
      currency = value;
    });
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
                    MyLocalizations.of(context).getLocalizations("SAVED_ITEMS"),
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
                                      MediaQuery.of(context).size.width / 520,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16),
                          itemBuilder: (BuildContext context, int i) {
                            if (favProductList[i]['averageRating'] == null) {
                              favProductList[i]['averageRating'] = 0;
                            }

                            return InkWell(
                              onTap: () {
                                var result = Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      locale: widget.locale,
                                      localizedValues: widget.localizedValues,
                                      productID: favProductList[i]['_id'],
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
                                    currency: currency,
                                    price: favProductList[i]['variant'][0]
                                        ['price'],
                                    variantStock: favProductList[i]['variant']
                                        [0]['productStock'],
                                    productData: favProductList[i],
                                    variantList: favProductList[i]['variant'],
                                  ),
                                  favProductList[i]['isDealAvailable'] == true
                                      ? Positioned(
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                width: 61,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFFFAF72),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                              ),
                                              Text(
                                                " " +
                                                    favProductList[i]
                                                            ['dealPercent']
                                                        .toString() +
                                                    "% " +
                                                    MyLocalizations.of(context)
                                                        .getLocalizations(
                                                            "OFF"),
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
          ? Container(height: 1)
          : InkWell(
              onTap: () {
                var result = Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => Home(
                      locale: widget.locale,
                      localizedValues: widget.localizedValues,
                      currentIndex: 2,
                    ),
                  ),
                );
                result.then((value) => getToken());
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
                                '(${cartData['products'].length})  ' +
                                    MyLocalizations.of(context)
                                        .getLocalizations("ITEMS"),
                                style: textBarlowRegularWhite(),
                              ),
                              new Text(
                                "$currency${cartData['subTotal'].toStringAsFixed(2)}",
                                style: textbarlowBoldWhite(),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            new Text(
                              MyLocalizations.of(context)
                                  .getLocalizations("GO_TO_CART"),
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
